#!/bin/bash

# gen-verible-project.sh
# 用于生成 Verible LSP 所需的 verible.filelist 文件
# 解决多目录跳转和 UVM 源码索引问题

OUTPUT_FILE="verible.filelist"

echo "🔍 Generating $OUTPUT_FILE for project at $(pwd)..."

# 1. 清空/新建文件
echo "" > "$OUTPUT_FILE"

# 2. [关键] 添加 Include 路径
#    递归查找当前目录下所有的子目录，并添加为 +incdir+
#    这确保了 `include "uvm_macros.svh"` 能被找到
echo "   -> Adding include directories..."
find . -type d -not -path '*/.*' -not -path './.git*' | while read -r dir; do
    echo "+incdir+${dir}" >> "$OUTPUT_FILE"
done

# 3. [可选] 如果设置了 UVM_HOME 环境变量，也加入进去
if [ -n "$UVM_HOME" ]; then
    echo "   -> Found UVM_HOME: $UVM_HOME"
    echo "+incdir+$UVM_HOME/src" >> "$OUTPUT_FILE"
fi

# 4. 添加所有源文件 (.sv, .v, .svh)
echo "   -> Adding source files..."
find . -type f \( -name "*.sv" -o -name "*.v" -o -name "*.svh" \) -not -path '*/.*' >> "$OUTPUT_FILE"

# 5. 统计
COUNT=$(wc -l < "$OUTPUT_FILE")
echo "✅ Done! Generated $OUTPUT_FILE with $COUNT lines."
echo "👉 Now run 'M-x lsp-workspace-restart' in Emacs to reload the project."
