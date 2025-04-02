#!/usr/bin/env python3

# usage: ./getReactionData.py <input XML file> <output file>

import sys
import cobra
import pandas as p
import re

model = cobra.io.read_sbml_model(sys.argv[1])

readableNames = {m.id:m.name + " [" + m.compartment + "]" for m in model.metabolites}

def readableReaction(text, pattern = "MAM[0-9]{5}[a-z]", names = readableNames):
    def replace(match):
        return names[match.group(0)]
    return re.sub(pattern, replace, text)

def getDictValue(d, key, NAvalue = ""):
    try:
        value = d[key]
    except KeyError:
        value = NAvalue
    finally:
        if isinstance(value, list):
            value = ", ".join(value)
        return(value)

p.DataFrame({'ID': [r.id for r in model.reactions],
             'Name': [r.name for r in model.reactions],
             'Subsystem': [r.subsystem for r in model.reactions],
             'Reaction': [r.reaction for r in model.reactions],
             'Readable reaction': [readableReaction(r.reaction) for r in model.reactions],
             'Lower bound': [r.lower_bound for r in model.reactions],
             'Upper bound': [r.upper_bound for r in model.reactions],
             'Reversibility': [r.reversibility for r in model.reactions],
             'Boundary': [r.boundary for r in model.reactions],
             'Genes': [r.gene_reaction_rule for r in model.reactions],
             'EC': [getDictValue(r.annotation, 'ec-code') for r in model.reactions],
             'KEGG': [getDictValue(r.annotation, 'kegg.reaction') for r in model.reactions],
             'BiGG': [getDictValue(r.annotation, 'bigg.reaction') for r in model.reactions],
             'VMH': [getDictValue(r.annotation, 'vmhreaction') for r in model.reactions]}).to_csv(sys.argv[2])

print("Success")