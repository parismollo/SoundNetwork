#!/bin/bash

python3 CSV/data_gen.py
psql -d noisebook -c "\copy users(name) FROM 'CSV/users.csv' DELIMITER ',' CSV HEADER;"
