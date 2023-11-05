#!/bin/sh
# id:				ship.sh
# author:			nicolas david - nicolas.david@anamor.ph
#
## version history:
# ----------------------------------------------------------------------------
#			v1.0	nicolas@	Initial Version
#			v1.1	nicolas@	Adding checksum to remove the need to
#								systematically translate everything all over
#								again.
#			v1.2	nicolas@	Adding translation capabilities to multiple
#								languages, but keeping it simple with spanish.
#
#			v1.3	nicolas@	Adding recipe filename translation.
#
## purpose:
# ----------------------------------------------------------------------------
# This script will launch the translation of cooking recipes from French to 
# English, Arabic and Spanish. It will then ask for a commit message and push 
# to the recipes repository.
# 
## variables:
# ----------------------------------------------------------------------------
export dir=$(PWD)
export recipe_checksum_file="$dir/ship_it-checksums"
export translation_languages=(en ar es)
#
# Checking if recipe checksum file exists. This file is used to keep track of
# recipes that have been translated.
if [ ! -f "$recipe_checksum_file" ]; then
		touch "$recipe_checksum_file"
fi
#
# Now moving to the translation part.
echo "### Translating recipes"
for i in $(ls fr/*.md)
	do
		recipe_original_name=$(basename $i .md | sed 's/^fr-//g' | sed 's/[-_]/ /g')
		echo $recipe_original_name
		#
		# Exporting this recipe's checksum.
		export recipe_checksum=$(shasum $i)
		#
		# If it exists in the checksum file, we skip it.
		if grep -q $recipe_checksum $recipe_checksum_file; then
			echo "-> [found!] original recipe hasn't changed. moving on."
		#
		# if it doesn't exist, we translate it.
		else
			echo "-> [not found!] original recipe is new or has changed."
			echo $i
			for lang in "${translation_languages[@]}"
			do
				python3 translate_recipes.py $i $lang "$recipe_original_name"
			done
			#
			# once translated in all the selected languages, we add the
			# checksum to the recipe checksum file
			echo "-> adding checksum to file"
			echo $recipe_checksum >> $recipe_checksum_file
			echo "---"
		fi
	done
#
# Moving to the commit part.
echo "### Preparing recipes commit"
git add .
read -p "Please enter a commit message" commitMessage
git commit -m "$commitMessage"
echo "### Shipping recipes!"
git push
