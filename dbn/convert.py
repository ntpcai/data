import csv
import json
from collections import defaultdict

# Chinese numeral order mapping
CHINESE_NUMERALS_ORDER = {
    '零': 0, '一': 1, '二': 2, '三': 3, '四': 4,
    '五': 5, '六': 6, '七': 7, '八': 8, '九': 9, '十': 10
}

# Custom subset ordering for specific sets
CUSTOM_ORDERS = {
    "注音符號": ["注音聲符", "注音韻母", "注音結合"]
}

def get_sort_key(s):
    """Extract sorting key based on first Chinese numeral found in string"""
    for char in s:
        if char in CHINESE_NUMERALS_ORDER:
            return CHINESE_NUMERALS_ORDER[char]
    return float('inf')  # Put items without numerals last

def should_include(value):
    """Determine if a value should be included in output"""
    return value not in ('', None)

def convert_csv_to_json(csv_file, json_file):
    # Read and process CSV data
    data = []
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Clean empty values and convert numbers
            processed = {}
            for k, v in row.items():
                if not should_include(v):
                    continue
                if k in ['strokes'] and v.isdigit():
                    processed[k] = int(v)
                else:
                    processed[k] = v
            
            # Skip rows with invalid grouping keys
            grouping_keys = ['publisher', 'year', 'set', 'subset']
            if any(not should_include(processed.get(k)) for k in grouping_keys):
                continue
            
            # Pad ID to 5 digits
            processed['id'] = processed.get('id', '').zfill(5)
            data.append(processed)

    # Create hierarchical structure
    hierarchy = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(list))))
    
    for item in sorted(data, key=lambda x: x.get('id', '')):
        # Extract grouping keys
        publisher = item['publisher']
        year = item['year']
        set_name = item['set']
        subset = item['subset']

        # Create entry
        entry = {
            k: v for k, v in item.items()
            if k in ['id', 'type', 'lang'] and should_include(v)
        }
        
        # Create fields
        fields = {
            k: v for k, v in item.items()
            if k not in ['publisher', 'year', 'set', 'subset', 'id', 'type', 'lang']
            and should_include(v)
        }
        if fields:
            entry['fields'] = fields
        
        # Add to hierarchy
        hierarchy[publisher][year][set_name][subset].append(entry)

    # Custom sorting function
    def sort_subsets(subsets_dict, set_name):
        """Sort subsets with custom ordering or numeral-based sorting"""
        if set_name in CUSTOM_ORDERS:
            # Apply custom order first
            ordered = []
            remaining = []
            custom_order = CUSTOM_ORDERS[set_name]
            
            for subset in custom_order:
                if subset in subsets_dict:
                    ordered.append((subset, subsets_dict[subset]))
            
            # Add remaining subsets sorted by Chinese numerals
            remaining_subsets = [
                (k, v) for k, v in subsets_dict.items()
                if k not in custom_order
            ]
            remaining_sorted = sorted(remaining_subsets, key=lambda x: get_sort_key(x[0]))
            return ordered + remaining_sorted
        else:
            # Default numeral-based sorting
            return sorted(subsets_dict.items(), key=lambda x: get_sort_key(x[0]))

    # Convert to regular dict with proper sorting
    def sort_structure(d):
        if isinstance(d, defaultdict):
            sorted_dict = {}
            # Publisher level
            for publisher, years in sorted(d.items(), key=lambda x: x[0]):
                sorted_years = {}
                # Year level
                for year, sets in sorted(years.items(), key=lambda x: get_sort_key(x[0])):
                    sorted_sets = {}
                    # Set level
                    for set_name, subsets in sorted(sets.items(), key=lambda x: get_sort_key(x[0])):
                        # Subset level
                        sorted_subsets = sort_subsets(subsets, set_name)
                        sorted_sets[set_name] = dict(sorted_subsets)
                    sorted_years[year] = sorted_sets
                sorted_dict[publisher] = sorted_years
            return sorted_dict
        return d

    final_data = sort_structure(hierarchy)

    # Write to JSON
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(final_data, f, ensure_ascii=False, indent=2, separators=(',', ': '))

if __name__ == "__main__":
    convert_csv_to_json('data.csv', 'data.json')
    print("JSON file generated successfully!")