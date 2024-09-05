
#jq -s "." 0a/*.json 0b/*.json 1a/*.json 1b/*.json 2a/*.json 2b/*.json bushou/*.json life/*.json | jq 'reduce .[] as $item ({}; .[$item.set] += {($item.subset): $item.data})' > data.json
jq -s "." 0a/*.json 0b/*.json 1a/*.json 1b/*.json 2a/*.json bushou/*.json life/*.json | jq 'reduce .[] as $item ({}; .[$item.set] += {($item.subset): $item.data})' > data.json

jq -sr '.[] | "\(.set) \(.subset) \(.data[].fields.side1) \(.data[].fields.side2) \(.data[].fields.side2b)"' */*.json | jq -nR '[inputs | split("")] | flatten | unique' | jq -r 'join("")' > text.txt
glyphhanger text.txt > unicode.txt

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.ttf" --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.ttf" --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.ttf" --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.woff2" --flavor=woff2 --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.woff2" --flavor=woff2 --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.woff2" --flavor=woff2 --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

cp data.json ../first/data/
mv *ttf ../first/fonts/
mv *woff2 ../first/fonts/

echo "Done."
