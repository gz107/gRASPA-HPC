#-----------------------------#
#Function: get unitcell in molecular simulation from cif file.
#Author: Zheng
#Data:2023.3.2
#-----------------------------$
import os
from pandas import read_excel
from pandas import DataFrame
import pandas as pd
import math

def get_unit_cell(cif_location, cutoff):
    
    with open(cif_location, 'rb') as f:
        text = f.readlines()
    for i in text:
        if (i.startswith(bytes('_cell_length_a', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            a = float(i.split()[-1].strip().split('(')[0])
        elif (i.startswith(bytes('_cell_length_b', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            b = float(i.split()[-1].strip().split('(')[0])
        elif (i.startswith(bytes('_cell_length_c', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            c = float(i.split()[-1].strip().split('(')[0])
        elif (i.startswith(bytes('_cell_angle_alpha', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            alpha = float(i.split()[-1].strip().split('(')[0])
        elif (i.startswith(bytes('_cell_angle_beta', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            beta = float(i.split()[-1].strip().split('(')[0])
        elif (i.startswith(bytes('_cell_angle_gamma', encoding="utf8"))):
            i = str(i, encoding="utf-8")
            gamma = float(i.split()[-1].strip().split('(')[0])
            break
    pi = 3.1415926

    a_length = a * math.sin(beta / 180 * pi)
    b_length = b * math.sin(gamma / 180 * pi)
    c_length = c * math.sin(alpha / 180 * pi)

    a_unitcell = int(2 * cutoff / a_length + 1)
    b_unitcell = int(2 * cutoff / b_length + 1)
    c_unitcell = int(2 * cutoff / c_length + 1)

    return [a_unitcell,b_unitcell,c_unitcell]
cutoff = 13.0   #define cutoff value
dir_location= 'C:\\Users\\gzxus\\Desktop\\ZeoliteCIFs-mepomml-charge\\order'   #cif file location
cif_list=os.listdir(dir_location)
tot_name=["Filename","a_unitcell","b_unitcell","c_unitcell"]
OUT = [];
for i in cif_list:
    cif_location=dir_location+'\\'+i
    uuu =get_unit_cell(cif_location,cutoff);
    n0 = len(uuu);
    uu = [i];
    for j in uuu:
        uu.append(j);
    OUT.append (uu)
    
zaa = pd.DataFrame(OUT,columns=tot_name)
zaa.to_excel('ZeoliteCIFs-mepomml-charge-order.xlsx',index = False)
print('finished')
