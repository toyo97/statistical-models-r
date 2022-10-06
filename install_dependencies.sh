#!/bin/bash
rg -o "library\((\w+)\)" -r '$1' *.Rmd | # find all 'library' statements and get package
  sed 's/.*://' | # remove filename prefix
  awk '!_[$0]++' > requirements.txt # unique

while IFS=" " read -r package; 
do 
  Rscript -e "install.packages('"$package"', repos = 'http://cran.us.r-project.org')";
done < "requirements.txt"
