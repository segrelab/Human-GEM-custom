#!/usr/bin/env python3

# usage: ./XMLtoJSON.py <input XML file> <output JSON file>

import sys
import cobra

model = cobra.io.read_sbml_model(sys.argv[1])
cobra.io.save_json_model(model, sys.argv[2])

print("Success")