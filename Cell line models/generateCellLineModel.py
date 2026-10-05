#!/usr/bin/env python3

# usage: ./generateCellLineModel.py <base model XML file> <cell line CSV file> <output cell line XML file> <cell line ID (optional)>

import sys
import cobra
import pandas as p

baseline_model = cobra.io.read_sbml_model(sys.argv[1])

def cellLineModel(KO_file, id = None):
    model = baseline_model.copy()
    if KO_file != "":
        KOs = list(p.read_csv(KO_file).iloc[:,0])
        for KO in KOs:
            model.reactions.get_by_id(KO).knock_out()
    if id is not None:
        model.id = id
    return(model)

model_csv = sys.argv[2]
model_id = sys.argv[4] if len(sys.argv) > 4 else None

model = cellLineModel(model_csv, model_id)

cobra.io.write_sbml_model(model, sys.argv[3])