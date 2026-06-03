#!/usr/bin/env python2

## Author: Martin Oti
## Version: 1.0
##
## This file is released under the Creative Commons CC0 license.
## For more information see https://creativecommons.org/about/cc0

"""
Predict CTCF loops based on CTCF motifs in ChIP-seq peaks.

Input: BED6 file with CTCF motifs that lie within ChIP-seq peaks.
       Both strand and score fields are required.
       Strand is based on motif orientation.
       Score is based on ChIP-seq peak strength for containing peak and/or motif strength. Should be scaled to 0-1000 range.

Approach:
- Read in all peak motifs from BED file
- Determine thresholds to use from peak scores
- For all thresholds, scan through motif set, identifying loops with approach outlined below
- For all chromosomes:
 -- Start at beginning of chromosome:
 -- Get first peak with '+' motif. Open loop. This is first current loop.
 -- Walk through subsequent peaks:
  --- if it is a '+' peak (and there are open loops), close and write out all open loops and then start a new loop.
  --- if it is a '-' peak, add it as a loop end for all currently open loops.
- Note: Genome is only scanned in forward direction; reverse scan gives identical loop predictions so is unnecessary.

Output: BED12 file for UCSC Genome Browser, similar to existing UCSC ChIA-PET files
"""


import sys, optparse, gzip, os, math


## Global variables

# BED file field separator (tab-separated)
BEDFIELDSEPERATOR = '\t'

# BED field indices
CHROM = 0
START = 1
END = 2
NAME = 3
SCORE = 4
STRAND = 5

# Very small number to stabilize floating point comparison
EPSILON = 1e-12



###############################################################################
## Class to predict CTCF loops from directional ChIP-seq peak data
###############################################################################
class CTCFLoopPredictor:
	"""Class for predicting CTCF loops from ChIP-seq peak motif data"""
	
	#############################################################
	## Constructor
	#############################################################
	def __init__(self):
		# Options
		self.optionparser = None
		self.options = None
		self.args = []
		
		# Input/output files
		self.inputFile = None
		self.outputFile = None
		
		# Predicted loops-related variables
		self.anchorRecords = []    # input BED file fields
		self.loops = {}            # dictionary keyed on (anchor1,anchor2) tuples; no values
		
		# Thresholds used in predictions
		self.peakThresholds = []   # set of score thresholds to use for filtering anchor motifs
		self.thresholdProportions = []    # what proportion of peaks pass corresponding thresholds
		self.minThreshold = 0.0    # default: start with all peaks
		self.maxThreshold = 0.5    # default: end with 50% of peaks
		self.thresholdIncrement = 0.1  # increment thresholds by this proportion of anchors
		
		# Set of currently open loops (start & end motif lists packaged in a dictionary)
		self.openLoops = {"starts":[], "ends":[]}
		
		# Configurable output BED field parameters
		self.itemRgb = "16711680"    # default value from UCSC ChIA-PET tracks
	# End Function
	
	
	#############################################################
	## Parse command line options
	#############################################################
	def ParseOptions(self):
		self.optionparser = optparse.OptionParser()
		self.optionparser.add_option("-p", "--proportions", dest="proportions", default="1.0:0.5", 
		                  help="maximum:minimum:stepsize proportions of peaks to use (default: 1.0:0.5:0.1)")
		self.optionparser.add_option("-t", "--thresholds", dest="thresholds", 
		                  help="minimum:maximum:stepsize peak score thresholds to use (supersedes -p if given)")
		self.optionparser.add_option("-i", "--inputfile", dest="inputFile", 
		                  help="(gzipped) input BED file of CTCF motifs from ChIP-seq peaks (default: stdin)")
		self.optionparser.add_option("-o", "--outputfile", dest="outputFile", 
		                  help="(gzipped) output filename; output file will be gzipped if name ends in '.gz' (default: stdout)")
		self.optionparser.add_option("-n", "--trackname", dest="trackName", default="Predicted_CTCF_Loops", 
		                  help="track name for UCSC genome browser track (default: Predicted_CTCF_Loops)")
		self.optionparser.add_option("-s", "--nostrength", dest="nostrength", 
		                             action="store_true", default=False, 
		                             help="do NOT shade loops according to strength in UCSC track (all loops black)")
		(self.options, self.args) = self.optionparser.parse_args()
	# End Function
	
	
	#############################################################
	## Open input and/or output files
	#############################################################
	def OpenFiles(self, whichFiles=("input","output")):
		"""
		Open input and output files
		Can be gzipped, in which case the file name must end in '.gz'.
		If no filename is given, standard input/output is used.
		"""
		try:
			# Input file
			if "input" in whichFiles:
				if self.options.inputFile:
					if self.options.inputFile.endswith(".gz"):
						self.inputFile = gzip.open(self.options.inputFile, 'rb')
					else:
						self.inputFile = file(self.options.inputFile, 'r')
				else:
					self.inputFile = sys.stdin
			# Output file
			if "output" in whichFiles:
				if self.options.outputFile:
					if self.options.outputFile.endswith(".gz"):
						self.outputFile = gzip.open(self.options.outputFile, 'wb')
					else:
						self.outputFile = file(self.options.outputFile, 'w')
				else:
					self.outputFile = sys.stdout
		except IOError, msg:
			sys.stderr.write("Error opening file: "+str(msg)+"\n")
			return False
	# End Function
	
	
	#############################################################
	## Read in CTCF ChIP-seq peak motifs BED file
	#############################################################
	def ReadChIPseqMotifsBEDFile(self):
		"""
		Read in all ChIP-seq peak CTCF motifs from input BED file.
		Store in list of tuples, with the fields of each line stored in a tuple.
		All fields are text, except the score feild which will be used for anchor filtering.
		"""
		
		self.OpenFiles( ("input") )    # note: function argument should be tuple not string
		for line in self.inputFile:
			lineFields = line.strip().split(BEDFIELDSEPERATOR)
			if len(lineFields) < 6:
				continue
			lineFields[SCORE] = float(lineFields[SCORE])
			self.anchorRecords.append(tuple(lineFields))
		self.inputFile.close()
	# End Function
	
	
	#############################################################
	## Write all loops to output BED12 file
	#############################################################
	def WriteAllLoopsToFile(self):
		"""
		Write all predicted loops to output file.
		Output file is in BED12 format, similar to UCSC ChIA-PET tracks.
		"""
		
		if not self.options.outputFile: outputFname = "stdout"
		else: outputFname = self.options.outputFile
		sys.stderr.write("Writing output file: "+outputFname+"\n")
		
		self.OpenFiles( ("output") )    # note: function argument should be tuple not string
		
		# Write track header
		useScore = 1
		if self.options.nostrength: useScore = 0
		self.outputFile.write("track name=%s useScore=%d\n" % (self.options.trackName, useScore))
		
		# Sort loops by input file index of anchor1 and anchor2 respectively
		# (i.e sort by genomic coordinates, as input file should be position-sorted)
		sortedLoops = self.loops.keys()
		sortedLoops.sort()
		
		# Write out loops in BED12 file format
		for loop in sortedLoops:
			s = self.anchorRecords[loop[0]]
			e = self.anchorRecords[loop[1]]
			
			# Loop score (geometric mean of anchor peak scores, truncated to integer value)
			# Note that this should be between 0-1000 in order to use for coloring loops
			# according to their strength in the UCSC track (i.e. the "useScore=1" track option)
			score = str(int( math.sqrt(s[SCORE] * e[SCORE]) ))
			
			# Compose name from start and end anchors and score, like in UCSC ChIA-PET track files
			nameField = s[CHROM] + ":" + s[START] + ".." + s[END] + "-" + \
					e[CHROM] + ":" + e[START] + ".." + e[END] + "," + score
			
			# Block (anchor) sizes and relative start coordinates
			blockSizes = str(int(s[END])-int(s[START])) + "," + str(int(e[END])-int(e[START]))
			blockStarts = "0," + str( int(e[START])-int(s[START]) )
			
			# Put together all BED12 fields and write out to file
			outputFields = ( s[CHROM], s[START], e[END], nameField, score, ".", 
						s[START], e[END], self.itemRgb, "2", blockSizes, blockStarts)
			self.outputFile.write("\t".join(outputFields) + "\n")
		self.outputFile.close()
	# End Function
	
	
	#############################################################
	## Determine ChIP-seq peak score thresholds to use
	#############################################################
	def GetPeakThresholds(self):
		"""
		Get set of peak score thresholds to use for filtering ChIP-seq peaks.
		"""
		
		# Get list of peak scores to determine thresholds/proportions with
		scores = []
		for anchorFields in self.anchorRecords:
			scores.append(anchorFields[SCORE])
		numScores = len(scores)
		
		# Get minimum and maximum thresholds based on user-provided peak proportions if not explicitly provided
		if not self.options.thresholds:
			try:
				proportions = [float(x) for x in self.options.proportions.split(":")]
				
				# Ensure proportions are between 0.0 and 1.0, then subtract from 1.0 as
				# user provides INCLUDED proportion but it will be used to EXCLUDE peaks
				self.minThreshold = 1.0 - min(max(0.0, proportions[0]), 1.0)
				self.maxThreshold = 1.0 - min(max(0.0, proportions[1]), 1.0)
				
				# If step size provided, use it (first ensure it is within 0-1 range)
				if len(proportions) > 2:
					self.thresholdIncrement = min(max(0.0, proportions[2]), 1.0)
			except ValueError:
				sys.stderr.write("\nUnable to get proportions: " + self.options.proportions + "\n\n")
				sys.exit(2)
			
			# Get set of peak score thresholds based on set of peak proportions
			scores.sort()    # scores need to be sorted for this
			proportion = self.minThreshold
			while proportion <= (self.maxThreshold + EPSILON):
				thresholdScore = scores[int(proportion * numScores)]
				self.peakThresholds.append(thresholdScore)
				self.thresholdProportions.append(1-proportion)
				proportion += self.thresholdIncrement
		else:
			try:
				thresholds = [float(x) for x in self.options.thresholds.split(":")]
				self.minThreshold = thresholds[0]
				self.maxThreshold = thresholds[1]
				self.thresholdIncrement = thresholds[2]
			except ValueError:
				sys.stderr.write("\nERROR: Unable to get thresholds: " + self.options.thresholds + "\n\n")
				sys.exit(2)
			except IndexError:
				sys.stderr.write("\nERROR: Missing one or more threshold fields: " + self.options.thresholds + "\n")
				sys.stderr.write("All three fields (min:max:step) should be provided.\n\n")
				sys.exit(3)
			
			# Get set of peak score thresholds based on user-provided min & max thresholds
			thresholdScore = self.minThreshold
			while thresholdScore <= (self.maxThreshold + EPSILON):
				self.peakThresholds.append(thresholdScore)
				thresholdProp = float(len([s for s in scores if s >= thresholdScore])) / float(numScores)
				self.thresholdProportions.append(thresholdProp)
				thresholdScore += self.thresholdIncrement
			
	# End Function
	
	
	#############################################################
	## Store one set of loops
	#############################################################
	def StoreLoopSet(self):
		"""
		Store one set of predicted loops to loop collection.
		Only add it if it does not already exist.
		"""
		for s in self.openLoops["starts"]:
			for e in self.openLoops["ends"]:
				if not self.loops.has_key((s,e)):
					self.loops[(s,e)] = None
	# End Function
	
	
	#############################################################
	## Walk through motif anchors and call loops
	#############################################################
	def PredictLoops(self):
		"""
		Predict loops using several peak thresholds and merge them into a single loop set.
		At each threshold scan the through the peak motifs and predict loops.
		"""
		
		# For all peak thresholds
		for pt in range(len(self.peakThresholds)):
			
			# Report progress
			thresholdPerc = self.thresholdProportions[pt] * 100
			sys.stderr.write("Using peak score threshold: %s (top %d%s of peaks)\n" % (self.peakThresholds[pt],thresholdPerc,"%"))
			
			# Get loops for peaks at this threshold
			currentChrom = ""
			for an in range(0, len(self.anchorRecords), 1):
				
				# Ignore peaks that do not meet necessary criteria
				if (float(self.anchorRecords[an][SCORE]) <= self.peakThresholds[pt]):
					continue
				
				# Close all open loops if this is a new chromosome
				if self.anchorRecords[an][CHROM] != currentChrom:
					self.StoreLoopSet()
					self.openLoops = {"starts":[], "ends":[]}
				# Keep track of current chromosome
				currentChrom = self.anchorRecords[an][CHROM]
				
				if self.anchorRecords[an][STRAND] == "+":
					if len(self.openLoops["ends"]) > 0:
						self.StoreLoopSet()
						self.openLoops = {"starts":[], "ends":[]}
					self.openLoops["starts"].append(an)
				elif self.anchorRecords[an][STRAND] == "-":
					self.openLoops["ends"].append(an)
			self.StoreLoopSet()
		# end thresholds
		
	# End Function
	
	
	#############################################################
	## Main loop prediction function.
	#############################################################
	def GetPredictedLoops(self):
		"""
		Main loop prediction function.
		"""
		self.ReadChIPseqMotifsBEDFile()
		self.GetPeakThresholds()
		self.PredictLoops()
		self.WriteAllLoopsToFile()
	# End Function
# End Class


#################################################
## Main function.
#################################################

if __name__ == '__main__':
	# Predict CTCF loops from ChIP-seq peak motifs
	loopPredictor = CTCFLoopPredictor()
	loopPredictor.ParseOptions()
	loopPredictor.GetPredictedLoops()
	sys.stderr.write("Done.\n")
#
