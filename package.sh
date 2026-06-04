#!/bin/bash

set -e

typst compile progetto.typ

rm -rf release
mkdir release

cp -r db release/db
cp -r docker release/docker

mkdir release/seed
cp seed/main.py release/seed/main.py
cp seed/pyproject.toml release/seed/pyproject.toml
cp seed/README.md release/seed/README.md

cp progetto.pdf release/progetto.pdf

zip -r release.zip release
