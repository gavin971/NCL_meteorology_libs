#! /bin/bash
path_in='./'       # 输入路径 此处为当前路径 
path_out='./'      # 输出路径，此处为当前路径  
infilename="preci-160-JJA-30yr.grd"
outfilename="preci_3times.grd" 
   
cd  ${path_in}  
rm  -f  ${infilename}

#通过参数传递变量


#调用fortran程序

exit 0