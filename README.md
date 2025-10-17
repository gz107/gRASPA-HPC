# gRASPA-HPC script
##  中文版本
### 第一步 先制作Framework_name & Unitcell_size
方法：用getunitcell.py计算
在计算之前需要设置cutoff值及CIF文件的目录，然后使用 * python getunitcell.py * ，后会获得自命名的###.xlsx，文件。
第一列则为CIF的名字，也即为Framework_name的第二列数据。
第二列、第三列、第四列数据则为Unitcell_size的值，只不过在gRASPA中还需要再加一列“0”。
### 第二步 制作simulation_ads
方法：用gRASPA中的Example中制作对应的文件。

这样输入文件就准备完成了！

# -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - #
然而，分子模拟计算需要力场及分子描述。所以再当前目录下上传CO.def，force_field.def，force_field_mixing_rules.def及pseudo_atoms.def后，及可调用sub.sh文件。
方法：bash sub.sh
值得注意的是，在sub.sh文件中需要更改cif文件的目录及任务的数量！


## English version
### The first step is to create Framework_name & Unitcell_size
Method: Calculate using getunitcell.py
Before the calculation, you need to set the cutoff value and the directory of the CIF file. Then, use * python getunitcell.py *, and you will obtain the self-named ###.xlsx file.
The first column is the name of CIF, which is the second column data of Framework_name.
The data in the second, third and fourth columns are the values of Unitcell_size, but in gRASPA, an additional column "0" needs to be added.
### The second step is to create simulation_ads
Method: Create the corresponding file using the Example in gRASPA.

The input file is now ready!

# -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - #
However, molecular simulation calculations require force fields and molecular descriptions. So after uploading CO.def, force_field.def, force_field_mixing_rules.def and pseudo_atoms to the current directory, the sub.sh file can be called.
Method: bash sub.sh
It is worth noting that in the sub.sh file, the directory of the cif file and the number of tasks need to be changed!
