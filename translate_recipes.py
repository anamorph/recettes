#!/usr/local/bin/python3
import boto3
import sys
import os

# 
# change to your region of choice here
defaultRegion = 'eu-west-1'
translate = boto3.client(service_name='translate', region_name=defaultRegion, use_ssl=True)

if len(sys.argv) >= 3:
	inputFile = sys.argv[1]
	outputLanguage = sys.argv[2]
	inputRecipeName = sys.argv[3]
	#
	# Translating the filename, for consistency sake
	outputTranslatedFileName = translate.translate_text(Text=inputRecipeName, SourceLanguageCode="fr", TargetLanguageCode=outputLanguage)
	outputTranslatedFileName = outputTranslatedFileName.get('TranslatedText').replace(' ', '-')
	outputFile = outputLanguage + "/" + outputLanguage + "-" + outputTranslatedFileName + ".md"

	if not os.path.isdir(outputLanguage):
		#
		# If directory structure doesn't exist, then create it. 
		# This should only happen at first run.
		# Otherwise, go translate.
		os.makedirs(outputLanguage)

	with open(inputFile, 'r') as text:data = text.read() 
	outputTranslation = translate.translate_text(Text=data, SourceLanguageCode="fr", TargetLanguageCode=outputLanguage)

	print('translating: ' + inputFile)
	print('to: ' + outputFile)
	#
	# Fixing inconsistencies with markdown
	outputTranslationData = outputTranslation.get('TranslatedText')
	outputTranslationData = outputTranslationData.replace('! [', '![')
	outputTranslationData = outputTranslationData.replace('] (', '](')
	file = open(outputFile,'w')
	file.write(outputTranslationData)
	file.close()
else:
	print('usage : ' + sys.argv[0] + 'inputfile output_language_iso')