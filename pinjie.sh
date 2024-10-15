#!/bin/bash

# 检查是否安装了ImageMagick，如果没有安装则提示用户安装
if ! command -v magick &> /dev/null; then
  echo "错误：未找到ImageMagick，请安装后再运行此脚本。"
  exit 1
else
  echo "ImageMagick 已经安装。"
fi

# 检查是否传递了参数
if [ -z "$1" ]; then
  echo "pinjie v1.0"
  echo "将目标目录中的所有图片按文件名排序后垂直拼接。"
  echo "用法: pinjie <目标目录> <宽度> (默认宽度为 750px)"
  exit 1
fi
# 设置默认宽度为750
width=750

# 检查是否提供了宽度参数
if [ ! -z "$2" ]; then
  width=$2
fi

# 获取文件夹路径、文件夹名称和输出路径
folder_path="$1"
folder_name=$(basename "$folder_path")
output_path="./${folder_name}.jpg"  # 输出图片的名称与文件夹名称相同

# 创建一个临时文件夹来存储调整大小后的图片
temp_folder=$(mktemp -d)

# 遍历文件夹中的所有图片并调整大小
for img in "$folder_path"/*.{jpg,jpeg,png,bmp,gif}; do
  if [[ -f "$img" ]]; then
    filename=$(basename "$img")
    magick "$img" -resize ${width}x "$temp_folder/$filename"
  fi
done

# 拼接所有调整大小后的图片
magick "$temp_folder"/* -append "$output_path"

# 删除临时文件夹
rm -rf "$temp_folder"
echo "拼接已完成"
echo "图片已保存至: $output_path"
