#!/bin/bash

set -e

typst compile progetto.typ

rm -f db_lab_gruppo_7.zip
rm -rf db_lab_gruppo_7
mkdir db_lab_gruppo_7

cp -r db db_lab_gruppo_7/db
cp -r docker db_lab_gruppo_7/docker

mkdir db_lab_gruppo_7/seed
cp seed/main.py db_lab_gruppo_7/seed/main.py
cp seed/pyproject.toml db_lab_gruppo_7/seed/pyproject.toml
cp seed/README.md db_lab_gruppo_7/seed/README.md

cp progetto.pdf db_lab_gruppo_7/progetto.pdf

zip -r db_lab_gruppo_7.zip db_lab_gruppo_7
