
#!/usr/bin/env python3

import os
import sys
from textwrap import dedent

from mako.template import Template
import argparse

def cmd_line_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-n",
                        "--num_inputs",
                        action='store',
                        default=11,
                        help="Number of input bits for the serial adder tree")
    parser.add_argument("-i",
                        "--infile",
                        action='store',
                        help="Name of input file")
    parser.add_argument("-o",
                        "--outfile",
                        action='store',
                        help="Name of output file")
    args = parser.parse_args()
    return args

def render_template_file(template_fname, result_fname, num_inps):
    template_basename = os.path.basename(template_fname)
    header_text = dedent("""\
        ////////////////////////////////////////////////////////////////////////////////
        // THIS FILE WAS AUTOMATICALLY GENERATED FROM ${filename}
        // DO NOT EDIT
        ////////////////////////////////////////////////////////////////////////////////
    """)
    header = Template(header_text).render(filename=template_basename)

    with open(template_fname, "r") as f:
        template = Template(f.read())
    rendered = template.render(num_inputs=num_inps)
    output = header + rendered

    result_dirname = os.path.dirname(result_fname)
    os.makedirs(result_dirname, exist_ok=True)
    with open(result_fname, "w") as f:
        f.write(output)

def main():
    args = cmd_line_args()
    render_template_file(args.infile, args.outfile, args.num_inputs)

if __name__ == "__main__":
    main()