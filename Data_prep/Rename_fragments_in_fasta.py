#/usr/bin/python2
import itertools

# Ce script est pour convertir un fasta avec des entetes de SPAdes, pacbio ou la reference vers les entetes de TBA/multiZ, blastZ et co.


def fasta_iter(input_file):
    """ Given a fasta file. yield tuples of header, sequence

    """
    fh = open(input_file)
    # ditch the boolean (x[0]) and just keep the header or sequence since
    # we know they alternate.
    faiter = (x[1] for x in itertools.groupby(fh, lambda line: line[0] == ">"))
    for header in faiter:
        # drop the ">"
        header = header.next()[1:].strip()
        # join all sequence lines to one.
        seq = "".join(s.strip() for s in faiter.next())
        yield header, seq  # renvoie un tuple header et sequence


def write_seq_with_line_size(sequence, out, match_length_lines=False, length_line=None):
    if match_length_lines:
        length_seq = len(sequence)
        start_line = 0
        while start_line < length_seq:
            end_line = start_line + length_line
            out.write(sequence[start_line:end_line] + "\n")
            start_line = end_line
    else:
        out.write(sequence + "\n")


import sys
import getopt
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", required=True,
                    help="Path to your fasta file.")
parser.add_argument("-o", "--output", default="based_on_input",
                    help="Path to your output fasta file. Highly recommended since the default will just give the file back without any extension.")
parser.add_argument("-s", "--sample_name")
parser.add_argument("-f", "--format", required=True,
                    help="You must provide your fasta file format: pacbio, spades, reference (here = IPO323) or ncbi. If you have a '|' in the header (which is added at the polishing steps with pacbio assemblies), please use 'pacbio'.")
parser.add_argument(
    "--simple", action="store_true", help="Adding this flag will rename all the fragments with a simple name. Otherwise, the header is the one intended for TBA.")
parser.add_argument(
    "--for_REPET", action="store_true", help="Adding this flag will change the pipe symbols to underscore and will add contig_ at the beginning of the headers if they start with a number. Because Repet needs the sequence to be in short lines, this option will set the lines to be from the same size as the input (match_length_lines) if the lines are below 1000 or it will set the length of the lines at 100.")
parser.add_argument("--threshold", default=1000, type=int)
parser.add_argument("--match_length_lines",
                    help="This flag is to choose whether the sequence is written all on one line (the default) or on lines of length matching the input file.", action="store_true")
parser.add_argument("--set_length_lines", default=None, type=int)
A = parser.parse_args()

print "Your input file name is", A.input
if not any([A.simple, A.sample_name, A.for_REPET]):
    sample_name = A.input.split(".")[0].split("/")[-1]
    print "You have not provided any sample name. By default, the sample name is:", sample_name, ". If this is incorrect, use -s to specify a sample name."
elif A.sample_name:
    sample_name = A.sample_name

if A.format not in ["pacbio", "spades", "reference", "custom", "ncbi"]:
    sys.exit("You must provide your fasta file format as either pacbio, spades or reference. Your current format is: " + A.format)

if A.output == "based_on_input":
    out_name = A.input.rsplit(".", 1)[0]
else:
    out_name = A.output
out = open(out_name, "w")
print "Your output file name is", out_name

if any([A.for_REPET, A.match_length_lines, A.set_length_lines]):
    match_length_lines = True
else:
    match_length_lines = False

# This is to find how many letters are on each line of the input file
if match_length_lines:
    accepted_letters = ["n", "a", "c", "g", "t"]
    length_line = 0
    for k, i in enumerate(open(A.input)):
        if i.startswith("#"):
            pass
        elif i.startswith(">"):
            pass
        elif any([letter in i.lower() for letter in accepted_letters]):
            if len(i.strip()) >= length_line:
                length_line = len(i.strip())
                break
        else:
            pass
elif A.set_length_lines:
    length_line = int(A.set_length_lines)
else:
    length_line = None


iterateur = fasta_iter(A.input)

for name, seq in iterateur:
    if A.for_REPET:
        if len(seq) >= A.threshold:
            if "|" in name:
                new_name = name.replace("|", "_")
            else:
                new_name = name
            if name[0].isdigit():
                out.write(">" + "contig_" + new_name + "\n")
            else:
                out.write(">" + new_name + "\n")
            if length_line > 1000:
                length_line = 100
            write_seq_with_line_size(
                seq, out, True, length_line)

    elif A.simple:
        if len(seq) >= A.threshold:
            if A.format == "pacbio":
                out.write(">" + name.split("|")[0] + "\n")
            elif A.format == "spades":
                out.write(">" + "scaf" + name.split("_")[1] + "\n")
            elif A.format == "ncbi":
                out.write(">" + name.split(" ")[0] + "\n")
            else:
                out.write(">" + name + "\n")
            write_seq_with_line_size(
                seq, out, match_length_lines, length_line)
    else:
        if len(seq) >= A.threshold:
            if A.format == "pacbio":
                out.write(">" + sample_name + ":" + name.split("|")
                          [0] + ":1:+:" + str(len(seq)) + "\n")
            elif A.format == "spades":
                out.write(">" + sample_name + ":scaf" + name.split("_")
                          [1] + ":1:+:" + name.split("_")[3] + "\n")
            else:
                out.write(">" + sample_name + ":" + name +
                          ":1:+:" + str(len(seq)) + "\n")
            write_seq_with_line_size(
                seq, out, match_length_lines, length_line)

out.close()

