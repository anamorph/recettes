#!/bin/sh
# id:				ship.sh
# author:			nicolas david - nicolas.david@anamor.ph
# version history:
# ----------------------------------------------------------------------------
#					v1.0	nicolas@	Initial Version
#					v1.1	nicolas@	Adding checksum to remove the need to
#										systematically translate everything 
#										all over again.
#					v1.2	nicolas@	Adding translation capabilities to 
#										multiples languages, but keeping it
#										relatively "easy" with spanish.
#
# purpose:
# ----------------------------------------------------------------------------
# This script will launch the translation of cooking recipes from FR to both 
# EN & AR. It will then ask for a commit message and push to the recipe 
# repository.
# 
# variables:
# ----------------------------------------------------------------------------
export dir=$(PWD)
export recipe_checksum_file="$dir/ship_it-checksums"
export translation_languages=(en ar es)

if [ ! -f "$recipe_checksum_file" ]; then
		touch "$recipe_checksum_file"
fi

echo "### Translating recipes"
for i in $(ls fr/*.md)
	do
		export recipe_checksum=$(/usr/bin/shasum $i)
		if grep -q $recipe_checksum $recipe_checksum_file; then
			echo "-> [found!] original recipe hasn't changed. moving on."
		else
			echo "-> [not found!] original recipe is new or has changed."
			for lang in "${translation_languages[@]}"
			do
				/opt/homebrew/bin/python3 translate_recipes.py $i $lang
			done
			echo "adding checksum to file"
			echo $recipe_checksum >> $recipe_checksum_file
		fi
	done

echo "### Preparing recipes commit"
git add .
read -p "Please enter a commit message" commitMessage
git commit -m "$commitMessage"
echo "### Shipping recipes!"
git push
