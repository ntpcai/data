
jq -s "." */*.json | jq 'reduce .[] as $item ({}; .[$item.set][$item.subset] += $item.data)' > data.json
