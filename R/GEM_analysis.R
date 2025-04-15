library(tidyverse)
library(magrittr)

reactions <- read_csv("Data/reactions.csv") %>%
  select(-1) %>%
  mutate(across(c(Subsystem, Genes, EC, KEGG, BiGG, VMH), as.factor))

metabolites <- read_csv("Data/metabolites.csv") %>%
  select(-1) %>%
  mutate(across(c(Name, Formula, Compartment, KEGG, BiGG, ChEBI, VMH, Reactions), as.factor),
         ID_without_prefix = substr(ID, 0, 8) %>% as.factor()) %>%
  relocate(ID_without_prefix, .after = ID)

genes <- read_csv("Data/genes.csv") %>%
  select(-1) %>%
  mutate(across(c(Uniprot, Reactions), as.factor))
  
save(reactions, metabolites, genes, file = "Data/data.RData")
