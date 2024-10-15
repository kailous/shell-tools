#!/bin/bash

# 检查参数是否正确
if [ "$#" -lt 2 ]; then
  echo "suofang v1.0"
  echo "用法: suofang <目标目录> <宽度>"
  exit 1
fi

# 获取传递的参数
target_directory=$1  # 目标目录
width=$2             # 目标宽度

# 判断目标目录是否存在
if [ ! -d "$target_directory" ]; then
    echo "错误：目标目录不存在"
    exit 1
fi

# 启用 nullglob 选项
shopt -s nullglob

# 遍历目录中的所有图片（jpg, jpeg, png 格式）
for image_file in "$target_directory"/*.{jpg,jpeg,png}; do
    # 检查文件是否存在
    if [ -f "$image_file" ]; then
        # 获取文件名
        filename=$(basename "$image_file")
        echo "正在处理: $filename"
        
        # 调整图片尺寸，保持输出文件覆盖原文件
        sips --resampleWidth $width "$image_file" --out "$image_file"
    else
        echo "跳过: $image_file 不是有效的文件"
    fi
done

echo "所有图片处理完毕！"
