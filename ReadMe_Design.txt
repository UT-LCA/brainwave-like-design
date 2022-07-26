Author: Tanmay Anand
Email: tanmay.anand29@gmail.com
GitHub Username: saitama0300

For block-floating point design - 
1. Use floating_pt_brainwave/brainwave_v3_only_dual_port as default design directory for block-floating point brainwave design generation
2. Change the design configuration across each individual mako files in the dirctory for controller, MVU, MFU, floating point units, NPU and Include files
3. Run cmd_gen.sh in the directory to generate the desired design file for brainwave (resultant file would be a single .v file)

For fixed-point design -
1. Use floating_pt_brainwave/brainwave_multi_tile_generator as default design directory for block-floating point brainwave design generation
2. Change the design configuration across each individual mako files in the dirctory for controller, MVU, MFU, NPU and Include files
3. Run cmd_gen.sh in the directory to generate the desired design file for brainwave (resultant file would be a single .v file)

One may use the already created design files for synthesis or simulation