cp e/data.json .

jq -r '
  def top_level_keys:
    keys | map(tostring) | join("");
  
  def next_level_keys:
    (to_entries | map(.value | 
      if type == "object" then 
        (keys | map(tostring) | join(""))
      else 
        ""
      end) | join(""));

  def field_values:
    reduce ( .. | select(type == "string") ) as $item (""; . + $item) |
    split("") |
    unique |
    sort |
    join("");

  
  def combined_string:
    top_level_keys + next_level_keys + field_values + "舊新約永星光學院教會練習國子秀朗國小補校-南一書局創作者劉喆";

  combined_string | split("") | sort | unique | join("")
' data.json > text.txt

#truncate --size -1 tmp_text.txt
#echo "星光學院練習國子秀朗國小補校-南一書局創作者劉喆" >> tmp_text.txt
#jq -Rr 'split("") | unique | sort | join("")' tmp_text.txt > text.txt

glyphhanger text.txt > unicode.txt

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.ttf" --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.ttf" --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.ttf" --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.woff2" --flavor=woff2 --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.woff2" --flavor=woff2 --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.woff2" --flavor=woff2 --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

cp data.json ../elight/data/
mv *ttf ../elight/fonts/
mv *woff2 ../elight/fonts/

echo "Done first."
