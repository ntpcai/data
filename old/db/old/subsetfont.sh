pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.ttf" --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.ttf" --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.ttf" --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"

pyftsubset ../../fonts/TW-Kai-98_1.ttf --output-file="frontfont.woff2" --flavor=woff2 --layout-features="rtla,vert" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-Zhuyin-Kai-Traditional.ttf --output-file="backfont.woff2" --flavor=woff2 --layout-features="ss01,ss02,ss03,ss04,ss05,ss10,vert,vrt2" --unicodes-file="unicode.txt"
pyftsubset ../../fonts/ToneOZ-RadicalZ-KaiTraditional.ttf --output-file="radicals.woff2" --flavor=woff2 --layout-features="ss10,vert,vrt2" --unicodes-file="unicode.txt"
