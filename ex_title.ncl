begin
  npts = 500
  y = 500.+.9* ispan(0,npts-1,1)*sin(0.031415926535898*ispan(0,npts-1,1))

  wks = gsn_open_wks("eps","title_ex")  

  res = True                          
  
  plot = gsn_csm_y(wks,y,res)
end