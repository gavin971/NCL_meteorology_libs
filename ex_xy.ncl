begin
  y = sin(0.0628*ispan(0,100,1))     
  
  wks = gsn_open_wks("eps","xy_ex")  

  res = True                                     
  
  plot = gsn_csm_y(wks,y,res)                                              
end