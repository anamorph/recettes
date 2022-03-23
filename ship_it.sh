#!/bin/sh
# id:				ship.sh
# author:			nicolas david - nicolas.david@anamor.ph
# version: 			1
#
# purpose:			This script will launch the translation of cooking recipes
#					from FR to both EN & AR. It will then ask for a commit me-
#					ssage and push to the recipe repository.
# 
echo "### Translating recipes"
for i in $(ls fr/*.md)
    do
        /opt/homebrew/bin/python3 translate_recipes.py $i en
        /opt/homebrew/bin/python3 translate_recipes.py $i ar
    done

echo "### Preparing recipes commit"
git add .
read -p "Please enter a commit message" commitMessage
git commit -m "$commitMessage"
echo "### Shipping recipes!"
git push
