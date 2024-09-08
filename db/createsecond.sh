
jq -s "." 0a2/*.json 0b2/*.json bushou/*.json life/*.json | jq 'reduce .[] as $item ({}; .[$item.set] += {($item.subset): $item.data})' > data.json

jq -r '
  reduce ( .. | select(type == "string") ) as $item (""; . + $item) |
  split("") |
  unique |
  sort |
  join("")
' data.json > text.txt

truncate --size -1 text.txt
echo "練習國子秀朗國小補校-南一書局創作者劉喆" >> text.txt
jq -Rr 'split("") | unique | sort | join("")' text.txt >> text.txt

glyphhanger text.txt > unicode.txt

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.ttf" --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.ttf" --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.ttf" --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.woff2" --flavor=woff2 --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.woff2" --flavor=woff2 --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.woff2" --flavor=woff2 --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

cp data.json ../second/data/
mv *ttf ../second/fonts/
mv *woff2 ../second/fonts/

echo "Done second."
