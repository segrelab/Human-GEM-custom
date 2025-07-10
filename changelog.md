# Changelog 

## Changes in version 1.20:
- Added GLUL mitochondrial reaction (MAR20184)
- Fixed directionality of MAR04356 (fructose 1-phosphate aldolase) to make it reversible
- Renamed "i" compartment from "Inner mitochondria" to "Mitochondrial intermembrane space" for increased clarity
- Altered DHODH reaction to more accurately match compartmentalization of the reaction:
    - Created intermembrane space versions of DHO (MAM00180i) and orotate (MAM02659i)
    - Altered DHODH reaction (MAR04575) to utilize "i" compartment metabolites
    - Altered FMN:ubiquinone reaction (MAR20167) to utilize "i" compartment FMN and FMNH2
    - Created transport reactions between cytosol and intermembrane space for DHO (MAR20185) and orotate (MAR20186)

## Changes in version 1.21:
- Changed biomass [e] from MAM03971e to MAM03970e to match biomass [c] (MAM03970c). Also changed relevant reactions.
- Changed name of MAR03964 from "ATP phosphohydrolase" to "ATP phosphohydrolase (ATP maintenance reaction)" to make it clear what it represents
- Changed name of MAR06916 from "ATP phosphohydrolase" to "ATP synthase" to make it more clearly named
- Created two new maintenance reactions based on existing maintenance reactions present in the model:
    - MAR20187: based on MAR09931 ("Biomass maintenance reaction without replication precursors", which includes precursors for protein and RNA synthesis). Modified to not produce biomass.
    - MAR20188: based on MAR09932 ("Biomass maintenance reaction without replication precursors", which only includes ATP and lipid precursors). Modified to not produce biomass.

## Changes in version 1.22:
- Reversed annotated direction of reversible glycolysis reactions: PGI (MAR04381), aldolase (MAR04375), GADPH (MAR04373), PGM (MAR04365)
- Reversed annotated direction of reversible TCA cycle reactions: ACO (MAR04458), SDH (MAR04652), MDH (MAR04141)

## Changes in version 1.23:
- Renamed fatty acid-related metabolites and reactions for consistency (i.e. decanoic acid is now caprate, behenic acid is now behenate, etc.)
- Reversed annotated direction of reversible beta oxidation reaction MAR02207 (NADPH-dependent oxidation of caproyl-CoA)
- Knockout of simplified "shortcut" reactions for fatty acid beta oxidation, like C12->C10 in one step (MAR05095) or C16->C6 in one step (MAR00757)

## Possible changes to implement in later versions:
- Removal/functional KO of MAR04280 (mitochondrial LDH reaction)
- Removal/functional KO of non-ADP pyruvate kinase reactions (MAR04193, MAR04171, MAR04421, MAR04573, MAR04210)
- Change kinetics of citrate/isocitrate antiport that bypasses aconitase