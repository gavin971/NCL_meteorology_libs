begin
  npts = 500
  x    = fspan(-100,100,npts)   ; 500 values from -100 to 100.
  
  y = new((/4,500/),"float")
  y(0,:) = sin(0.0628*x)     
  y(1,:) = cos(0.0628*x) 
  y(2,:) = cos(0.0628*x)*sin(0.0628*x)  
  y(3,:) = cos(0.0628*x)+sin(0.0628*x)  
    
  wks = gsn_open_wks("eps","xy_legend_ex") 

  res = True                         
  
  res@trXMinF           = min(x)             
  res@trXMaxF           = max(x)
  res@trYMinF           = min(y)-0.2   ;留出适当的空白，绘制legend
  res@trYMaxF           = max(y)+0.6   ;
      
  plot = gsn_csm_xy(wks,x,y,res)  
end