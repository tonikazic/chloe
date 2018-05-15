#!/bin/bash

# this is ../c/maize/demeter/data/find_changes.sh
#
# a script to grep handily for thing that need changing
# change string and exclusions as needed.
#
# Kazic, 2.5.2018

grep 06R200:S000I104 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I208 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I219 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R400:M000I309 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I504 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I507 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I518 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I805 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
grep 06R300:W000I815 *.pl | grep -v '%' | grep -v old  | grep -v crop_rowplant | grep -v row_members | grep -v index ;
