#jq -sr '.[].data[] | "\(.fields.side1) \(.fields.side2) \(.fields.side2b)"' */*.json | jq -nR '[inputs | split("")] | flatten | unique' | jq -r 'join("")' > text.txt
jq -sr '.[] | "\(.set) \(.subset) \(.data[].fields.side1) \(.data[].fields.side2) \(.data[].fields.side2b)"' */*.json | jq -nR '[inputs | split("")] | flatten | unique' | jq -r 'join("")' > text.txt
glyphhanger text.txt > unicode.txt
