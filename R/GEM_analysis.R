# usage: Rscript GEM_analysis.R [path to XMLfile] [--batch]

library(tidyverse)
library(magrittr)

# input XML file from argument
args = commandArgs(T)

if(length(args) < 1 | !endsWith(args[1], ".xml"))
  cli::cli_abort("XML file required as argument")

# get XML from first argument
file = args[1]

# set batch based on whether --batch present in args
BATCH = "--batch" %in% args

# if batch processing is happening, then no temp folder or analysis needed
if(BATCH) {
  cli::cli_alert_info("Batch mode activated")
  TEMP_FOLDER = "Data"
}

# now, if batch processing is not the name of the game
if(!BATCH) {
  # create temporary folder
  TEMP_FOLDER = paste0("R_temp_", rlang::hash(runif(1)))
  system(glue::glue("mkdir {TEMP_FOLDER}"))

  # run the analysis code on the inputted file
  system(glue::glue("Scripts/batchScript.command '{file}' {TEMP_FOLDER}/genes.csv {TEMP_FOLDER}/reactions.csv {TEMP_FOLDER}/metabolites.csv --noJSON --noR"))
}

GEMdata = list()

GEMdata$reactions = read_csv(paste0(TEMP_FOLDER, "/reactions.csv")) %>%
  select(-1) %>%
  mutate(across(c(Subsystem, Genes, EC, KEGG, BiGG, VMH), as.factor))

GEMdata$metabolites = read_csv(paste0(TEMP_FOLDER, "/metabolites.csv")) %>%
  select(-1) %>%
  mutate(across(c(Name, Formula, Compartment, KEGG, BiGG, ChEBI, VMH, Reactions), as.factor),
         ID_without_prefix = substr(ID, 0, 8) %>% as.factor()) %>%
  relocate(ID_without_prefix, .after = ID)

GEMdata$genes = read_csv(paste0(TEMP_FOLDER, "/genes.csv")) %>%
  select(-1) %>%
  mutate(across(c(Uniprot, Reactions), as.factor))

generateStoichiometryMatrix = function(reactions, metabolites) {
  mat = matrix(data = 0, nrow = nrow(reactions), ncol = nrow(metabolites))
  colnames(mat) = metabolites$ID
  rownames(mat) = reactions$ID

  getStoich = function(reaction) {
    # regex explanation
    # "([0-9\\.]*)[ ]{0,1}(MAM[0-9]{5}[a-z])|\\-\\->|<=>"
    # ([0-9\\.]*): matches and captures decimal numbers, if present
    # [ ]{0,1}: matches 0 or 1 space
    # (MAM[0-9]{5}[a-z])|\\-\\->|<=>: matches and captures MAM + 5 digits + letter, or matches -->, or matches <=>
    matches = str_match_all(reaction, "([0-9\\.]*)[ ]{0,1}(MAM[0-9]{5}[a-z])|\\-\\->|<=>")[[1]]
    arrow = which(matches[,1] == "-->" | matches[,1] == "<=>" )
    stoich = matches[-arrow,2]
    stoich[stoich == ""] = "1"
    stoich = as.numeric(stoich)
    stoich[1:arrow - 1] = -1 * stoich[1:arrow - 1]
    metabs = matches[-arrow,3]
    structure(stoich, names = metabs)
  }
  
  for(n in 1:nrow(reactions)) {
    rxn = reactions$Reaction[n]
    stoich = getStoich(rxn)
    mat[n, names(stoich)] = stoich
  }
  return(mat)
}

GEMdata$stoichiometry = generateStoichiometryMatrix(GEMdata$reactions, GEMdata$metabolites)

GEMdata$version = str_match(file, "\\-(v[0-9]+\\.[0-9]+)")[1,2]

# if version is NA, change to current date and time
if(is.na(GEMdata$version))
  GEMdata$version = lubridate::date()

GEMdata$fileHash = rlang::hash_file(file)

exportFile = if(startsWith(GEMdata$version, "v")) glue::glue("Data/data-{GEMdata$version}.RData") else "Data/data.RData"
  
save(GEMdata, file = exportFile)


# delete R_temp folder if needed
if(!BATCH)
  system(paste("rm -rf", TEMP_FOLDER))
