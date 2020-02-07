#!/usr/local/bin/python3
import boto3
import sys
import os

defaultRegion = 'eu-west-1'
translate = boto3.client(service_name='translate', region_name=defaultRegion, use_ssl=True)


if len(sys.argv) >= 3:
        inputFile = sys.argv[1]
        outputLanguage = sys.argv[2]
        outputFile =  str(inputFile).replace('fr', outputLanguage)

        if not os.path.isdir(outputLanguage):
                os.makedirs(outputLanguage)

        with open(inputFile, 'r') as text:data = text.read() 
        outputTranslation = translate.translate_text(Text=data, SourceLanguageCode="fr", TargetLanguageCode=outputLanguage)

        print('translating: ' + inputFile)
        print('from: ' + outputTranslation.get('SourceLanguageCode'))
        print('to: ' + outputTranslation.get('TargetLanguageCode'))

        file = open(outputFile,'w')
        file.write(outputTranslation.get('TranslatedText'))
        file.close()
else:
        print('usage : ' + sys.argv[0] + 'inputfile output_language_iso')