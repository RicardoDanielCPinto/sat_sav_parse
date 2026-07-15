#!/usr/bin/env bash
# generate_map.sh
# Runs sav_to_html.py against a Satisfactory save file and outputs save.html
# plus all map PNG images (save_slug.png, save_hd.png, etc.) to a given directory.
#
# Usage: ./generate_map.sh <save_file.sav> <output_dir>
#
# NOTE: Map PNG images are only generated when sat_sav_parse/blank_map20.png
# is present. The file is distributed with the sat_sav_parse release but is
# not committed to this repo. Place it at:
#   sat_sav_parse/blank_map20.png
# to enable full map generation.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SAV_PARSE_DIR="$(pwd)/sat_sav_parse"

# Validate arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $(basename "$0") <save_file.sav> <output_dir>" >&2
    exit 1
fi

SAV_FILE="$1"
OUTPUT_DIR="$2"

# Ensure the save file exists
if [[ ! -f "$SAV_FILE" ]]; then
    echo "ERROR: Save file not found: $SAV_FILE" >&2
    exit 1
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Warn if blank map is missing (map images won't be generated)
if [[ ! -f "$SAV_PARSE_DIR/blank_map20.png" ]]; then
    echo "WARNING: $SAV_PARSE_DIR/blank_map20.png not found."
    echo "         Only save.html will be generated (no map PNG images)."
    echo "         Download blank_map20.png from the sat_sav_parse GitHub release and place it in sat_sav_parse/."
    echo ""
fi

echo "Generating save map from: $SAV_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Run sav_to_html.py from within sat_sav_parse/ so local imports resolve correctly
cd "$SAV_PARSE_DIR"
python3 sav_to_html.py "$SAV_FILE" "$OUTPUT_DIR"

echo ""
echo "Done! Output files:"
for f in "$OUTPUT_DIR"/save.html "$OUTPUT_DIR"/save_*.png; do
    [[ -f "$f" ]] && echo "  $f"
done
