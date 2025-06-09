#!/usr/bin/env zsh
cd /Users/liam2/Documents/GitHub/Human-GEM-custom

XML="${1:-Current/Human-GEM-custom.xml}"
JSON="${XML%.*}.json"
GENES="${2:-Data/genes.csv}"
REACTIONS="${3:-Data/reactions.csv}"
METABOLITES="${4:-Data/metabolites.csv}"

# check for --noJSON and --noR arguments
makeJSON=true
runR=true
for arg in "$@"; do
  case $arg in
    --noJSON)
      makeJSON=false
      shift # Remove the argument from the list
      ;;
    --noR)
      runR=false
      shift # Remove the argument from the list
      ;;
  esac
done

if $makeJSON; then
    echo "Generating new JSON"
    ./Scripts/XMLtoJSON.py $XML $JSON
fi

echo "Generating new gene table"
./Scripts/getGeneData.py $XML $GENES

echo "Generating new reaction table"
./Scripts/getReactionData.py $XML $REACTIONS

echo "Generating new metabolite table"
./Scripts/getMetaboliteData.py $XML $METABOLITES

if $runR; then
    echo "Generating new R data file"
    Rscript R/GEM_analysis.R $XML --batch
fi