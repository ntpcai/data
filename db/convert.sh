for file in */*.json; do
  jq 'to_entries | map(.value | to_entries[] | {set: .key, subset: .key, data: .value})' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

