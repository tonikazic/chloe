#!/usr/local/bin/perl

# this is /athe/c/maize/crops/sort_into_inventory_order.perl


# given a file, each line of which begins with a maternal numerical
# genotype (or some constant before the numerical genotype), sort the lines
# into our usual inventory order:
#
#       crop, R > G > N
#       mutants > S > W > M > B > crop improvement > popcorn
#
# idea is to grab each line:
#
#       ($front,$ma_num_gtype,$rest);
#
# insert into a set of hashes for each crop and type of ear (e.g., 10RS,
# 10Rmutants, etc.), with key $ma_rowplant and value $ma_num_gtype ::
# $front :: rest;
#
# sort the keys of each hash;
#
# use hash references, building rules to recognize each hash by name
# (hardest step);
#
# output the hashes in an order given by a combination of @crop =
# ('R','G','N'), ordering rules for type of ear, and @years, the latter
# obtained from the $ma_num_gtype as they're read;
#
#
# output existing comments;
#
# include appropriate separating comments of the form, %\n% crop\n%\n as we
# do now by hand, if not already present.
#
# Is it ok to overwrite the input file?
#
# Kazic, 11.6.2014
