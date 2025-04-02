#!/usr/bin/env python3

# usage: ./getMetaboliteData.py <input XML file> <output file>

import sys
import cobra
import pandas as p

model = cobra.io.read_sbml_model(sys.argv[1])

def getDictValue(d, key, NAvalue = ""):
    try:
        value = d[key]
    except KeyError:
        value = NAvalue
    finally:
        if isinstance(value, list):
            value = ", ".join(value)
        return(value)

p.DataFrame({'ID': [m.id for m in model.metabolites],
             'Name': [m.name for m in model.metabolites],
             'Formula': [m.formula for m in model.metabolites],
             'Formula weight':  [m.formula_weight for m in model.metabolites],
             'Charge': [m.charge for m in model.metabolites],
             'Compartment': [m.compartment for m in model.metabolites],
             'KEGG': [getDictValue(m.annotation, 'kegg.compound') for m in model.metabolites],
             'BiGG': [getDictValue(m.annotation, 'bigg.metabolite') for m in model.metabolites],
             "ChEBI": [getDictValue(m.annotation, 'chebi') for m in model.metabolites],
             'VMH': [getDictValue(m.annotation, 'vmhmetabolite') for m in model.metabolites],
             'Reactions':  [", ".join([r.id for r in m.reactions]) for m in model.metabolites]}).to_csv(sys.argv[2])

print("Success")