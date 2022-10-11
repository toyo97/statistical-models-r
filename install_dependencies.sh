#!/bin/bash
rmd_lessons=./lessons
rmd_labs=./labs
rmd_std=.

rmdFiles=()
for p in ${!rmd_@}; do
  for f in "${!p}"/*.Rmd; do
    rmdFiles=("${rmdFiles[@]}" "$f")
  done
done

rg -o "library\((\w+)\)" -r '$1' "${rmdFiles[@]}" | # find all 'library' statements and get package
  sed 's/.*://' | # remove filename prefix
  awk '!_[$0]++' > requirements.txt # unique

while IFS=" " read -r package; 
do 
  Rscript -e "install.packages('$package', repos = 'http://cran.us.r-project.org')";
done < "requirements.txt"
