# Changelog 

Changes in version 1.20:
- Added GLUL mitochondrial reaction (MAR20184)
- Fixed directionality of MAR04356 (fructose 1-phosphate aldolase) to make it reversible
- Renamed "i" compartment from "Inner mitochondria" to "Mitochondrial intermembrane space" for increased clarity
- Altered DHODH reaction to more accurately match compartmentalization of the reaction:
    - Created intermembrane space versions of DHO (MAM00180i) and orotate (MAM02659i)
    - Altered DHODH reaction (MAR04575) to utilize "i" compartment metabolites
    - Altered FMN:ubiquinone reaction (MAR20167) to utilize "i" compartment FMN and FMNH2
    - Created transport reactions between cytosol and intermembrane space for DHO (MAR20185) and orotate (MAR20186)