#!/bin/bash
#==================================================
# Job submission script for gRASPA2k simulations
# Features:
# 1. Read second column from Framework_name
# 2. Automatic CIF file copy
# 3. Generate simulation.input
# 4. Run gRASPA in parallel with max_jobs
# 5. Author: Zheng
# 6. Date: 2025.10.18
#==================================================

set -e

#-------------------
# Input files and parameters
#-------------------
f_file="Framework_name"             # 每行是 FrameworkName + CIF 基础名
u_file="Unitcell_size"             # 每行是对应单元格尺寸
template="simulation_ads"          # 模板文件
gRASPA_exec="/home/dell/software/gRASPA-v-030925/src_clean/nvc_main.x"
cif_dir="/home/dell/software/zeolite/cif_test"  # CIF 文件所在目录

total_job=6
start_id=${1:-1}
end_id=$((start_id + total_job - 1))
max_jobs=6

#-------------------
# Check input files
#-------------------
for file in "$f_file" "$u_file" "$template"; do
  [ -f "$file" ] || { echo "❌ No $file, exit"; exit 1; }
done

f_line=$(wc -l < "$f_file")
u_line=$(wc -l < "$u_file")

if [ "$f_line" -ne "$u_line" ]; then
  echo "❌ ERROR: $f_file($f_line) != $u_file($u_line), exit"
  exit 1
fi

#-------------------
# Create and run jobs
#-------------------
echo "Creating and running $total_job jobs..."
echo

for ((i=start_id; i<=end_id; i++)); do
  job_dir="a$i"
  [ -d "$job_dir" ] || mkdir "$job_dir"

  # 读取 Framework_name 数据
  Framework_namee=$(sed -n "${i}p" "$f_file")

  # 读取 Unitcell 数据
  unitcell_size=$(sed -n "${i}p" "$u_file")

  # 生成 simulation.input
  sed "22s/.*/$Framework_namee/" "$template" | sed "23s/.*/$unitcell_size/" > "$job_dir/simulation.input"

  # 获取 Framework 基础名（第2列）
  cif_base=$(awk -v line="$i" 'NR==line {print $2}' "$f_file")
  cif_file="$cif_base.cif"

  # 复制脚本和 def 文件
  cp  *.def "$job_dir"

  # 复制 CIF 文件
  if [ ! -f "$job_dir/$cif_file" ]; then
    cp "$cif_dir/$cif_file" "$job_dir/" || {
        echo "❌ CIF file $cif_file not found in $cif_dir, exit"
        exit 1
    }
  fi

  # 并行任务控制
  while [ "$(jobs -rp | wc -l)" -ge "$max_jobs" ]; do sleep 5; done

  # 运行 gRASPA
  (
    cd "$job_dir"
    echo "🚀 Running job $job_dir..."
    "$gRASPA_exec" simulation.input > run.log 2>&1
  ) &
done

# 等待所有后台作业完成
wait

echo
echo "✅ All $total_job jobs completed."
echo "Check each a*/run.log for results."


