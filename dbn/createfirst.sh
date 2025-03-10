 
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
    top_level_keys + next_level_keys + field_values + "練習國子秀朗國小補校-共南一書局創作者劉喆主選單子選單這是應用的起點。選擇不同科目後會進入子選單選擇主選單項目後，進入特定主題的次級選單，包含更細分的學習單元在子選單中選擇特定單元後，進入最終學習材料選擇層級。在按鈕左側僅選擇這課程。在按鈕右側，選擇這課程和之前的所有課程模式：學習抽認卡片模式：練習抽認卡片模式：練習寫字學習材料以可翻轉的口語抽認卡的形式呈現透過練習看看你是否記得字符的發音透過練習看看你能不能記住如何寫字從學習模式中，可以試著寫字自動播放從學習和練習模式中,可以自動播放抽認卡並調整速度複習表可以將卡片加到複習表中，然後從任何選單開啟複習表三種學習模式返回";

  combined_string | split("") | sort | unique | join("")
' data.json > text.txt

#truncate --size -1 tmp_text.txt
#echo "練習國子秀朗國小補校-共南一書局創作者劉喆" >> tmp_text.txt
#jq -Rr 'split("") | unique | sort | join("")' tmp_text.txt > text.txt

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

echo "Done first."
