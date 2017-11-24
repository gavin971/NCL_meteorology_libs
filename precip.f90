program precip
   implicit none
   integer,parameter::  numb=160,nyear=30
   character*60  inpath,outpath
   real     preci_new(numb,nyear) 
   real     preci(numb,nyear) 

!****从屏幕上读取输入及输出路径*************
   read(*,'(A60)') inpath
   read(*,'(A60)') outpath
     
!input
  open(10,file=inpath,form='binary')
  read(10)  preci
  close(10)

  preci_new = preci*3

!output
  open(2,file=outpath,form='binary')
  write(2) preci_new
  close(2)

end


