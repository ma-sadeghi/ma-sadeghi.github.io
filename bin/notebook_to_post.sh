#!/bin/bash

# Instructions:
# 1. Copy this file to your blog repository's bin directory
# 2. Make the file executable:
#    $ chmod +x ./bin/notebook_to_post.sh
# 2. Convert an IPyNB to Markdown using the following command:
#    $ ./bin/notebook_to_post.sh.sh _notebooks/<notebook_title>.ipynb
# 3. Check the _posts directory for the new post

fpath="$1"

dir_posts="_posts"
dir_notebooks="_notebooks"
dir_nb_assets=$(basename $fpath)
dir_nb_assets="${dir_nb_assets%.*}_files"

path_assets="assets/img/notebooks"
path_assets_sed=$(sed 's/\//\\\//g' <<< "$path_assets")
path_nb_assets="${fpath%.*}_files"

datestamp=$(date +"%Y-%m-%d %H:%M:%S")

jupyter nbconvert --to markdown "$fpath"

# Extract h1 title from notebook and assign it "title"
title=$(sed -n '1s/^# //p' "${fpath%.*}.md")
# Strip title of any special characters
title=$(sed 's/[^a-zA-Z0-9 ]//g' <<< "$title")
# Remove h1 title (since it's already in the front matter)
sed -i '/^#/d' "${fpath%.*}.md"

# Add front matter to the top of the file
sed -i '1s/^/---\
layout: post\
title: '"$title"'\
date: '"$datestamp"'\
tags: ???\
categories: sample-posts\
published: true\
---/' "${fpath%.*}.md"

# Replace image paths
sed -i 's/'"$dir_nb_assets"'/\/'"$path_assets_sed"'\/'"$dir_nb_assets"'/' "${fpath%.*}.md"

# Match pattern ![anything](anything.anything) and add {:width="70%"} to the end
sed -i 's/\!\[\(.*\)\](\(.*\)\.\(.*\))/\!\[\1\](\2.\3){:width="70%"}/' "${fpath%.*}.md"

# Move the file to the _posts directory
mv ${fpath%.*}.md "$dir_posts"/

# Move assets to the _assets directory (clean up if it already exists)
rm -rf $path_assets/$dir_nb_assets
mv "$path_nb_assets" "$path_assets"
