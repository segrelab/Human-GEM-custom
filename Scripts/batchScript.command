#!/usr/bin/env zsh
cd /Users/liam2/Documents/GitHub/Human-GEM-custom

XML="${1:-Current/Human-GEM-custom.xml}"
JSON="${XML%.*}.json"
GENES="${2:-Data/genes.csv}"
REACTIONS="${3:-Data/reactions.csv}"
METABOLITES="${4:-Data/metabolites.csv}"

echo "Generating new JSON"
./Scripts/XMLtoJSON.py $XML $JSON

echo "Generating new gene table"
./Scripts/getGeneData.py $XML $GENES

echo "Generating new reaction table"
./Scripts/getReactionData.py $XML $REACTIONS

echo "Generating new metabolite table"
./Scripts/getMetaboliteData.py $XML $METABOLITES

echo "Generating new R data file"
Rscript R/GEM_analysis.R