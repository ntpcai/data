import json
import csv
import os
from collections import defaultdict

def process_json(file_path):
    """处理单个 JSON 文件，返回扁平化数据及字段集合"""
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # 基础信息提取
    metadata = {
        'set': data.get('set', ''),
        'year': data.get('year', ''),
        'grade': data.get('grade', ''),
        'publisher': data.get('publisher', ''),
        'subset': data.get('subset', '')
    }
    
    # 动态收集字段
    field_keys = set()
    records = []
    
    for item in data.get('data', []):
        # 合并基础信息与动态字段
        record = {
            **metadata,
            'id': item.get('id', ''),
            'type': item.get('type', ''),    # NEW: Include "type"
            'lang': item.get('lang', ''),    # NEW: Include "lang"
            **item.get('fields', {})
        }
        # 更新字段集合
        field_keys.update(record.keys())
        records.append(record)
    
    return records, field_keys

def generate_combined_csv(root_dir, output_file):
    """生成合并后的 CSV 文件"""
    # 用于收集全局字段
    global_fields = defaultdict(set)
    all_records = []
    
    # 第一轮遍历：收集所有字段
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith('.json'):
                file_path = os.path.join(dirpath, filename)
                try:
                    records, fields = process_json(file_path)
                    all_records.extend(records)
                    global_fields['all'].update(fields)
                except Exception as e:
                    print(f"错误处理文件 {file_path}: {str(e)}")
    
    # 构建最终字段列表
    base_columns = ['set', 'year', 'grade', 'publisher', 'subset', 'id']
    dynamic_columns = sorted(global_fields['all'] - set(base_columns))
    fieldnames = base_columns + dynamic_columns
    
    # 第二轮写入：确保字段一致性
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        
        for record in all_records:
            # 填充缺失字段
            full_record = {col: record.get(col, '') for col in fieldnames}
            writer.writerow(full_record)

if __name__ == "__main__":
    # 配置参数
    ROOT_DIR = os.getcwd()  # 从当前目录开始
    OUTPUT_CSV = os.path.join(ROOT_DIR, 'combined_output.csv')
    
    # 执行处理
    generate_combined_csv(ROOT_DIR, OUTPUT_CSV)
    print(f"合并完成！输出文件: {OUTPUT_CSV}")