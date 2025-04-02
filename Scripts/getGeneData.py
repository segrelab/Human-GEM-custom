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

p.DataFrame({'ID': [g.id for g in model.genes],
             'Symbol': [getDictValue(g.annotation, 'hgnc.symbol') for g in model.genes],
             'Ensembl': [getDictValue(g.annotation, 'ensembl') for g in model.genes],
             'Entrez': [getDictValue(g.annotation, 'ncbigene') for g in model.genes],
             'Uniprot': [getDictValue(g.annotation, 'uniprot') for g in model.genes],
             'Reactions':  [", ".join([r.id for r in g.reactions]) for g in model.genes]}).to_csv(sys.argv[2])

print("Success")