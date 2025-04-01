#!/usr/bin/env python3

import sys
import cobra

model = cobra.io.read_sbml_model(str(sys.argv[1]))
cobra.io.save_json_model(model, str(sys.argv[2]))

print("Success")