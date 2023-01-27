#!/bin/bash

# this script looks for library names in all files, save these names on
# a 'requirement.txt' file and then installs all those packages

rmd_lessons=./lessons
rmd_labs=./labs
rmd_std=.

# find all .Rmd files
rmdFiles=()
for p in ${!rmd_@}; do
  for f in "${!p}"/*.Rmd; do
    rmdFiles=("${rmdFiles[@]}" "$f")
  done
done

# parse every file (ripgrep/sed/awk commands)
rg -o "library\((\w+)\)" -r '$1' "${rmdFiles[@]}" | # find all 'library' statements and get package
  sed 's/.*://' | # remove filename prefix
  awk '!_[$0]++' > requirements.txt # unique

# launch one 'install.packages()' command for each package
while IFS=" " read -r package; 
do 
  Rscript -e "install.packages('$package', repos = 'http://cran.us.r-project.org')";
done < "requirements.txt"
