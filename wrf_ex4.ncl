begin
  f = addfile("./data/wrfout_ex1_2014-12-31.nc","r")
  uvm10 = wrf_user_getvar(f,"uvmet10",-1) 
  u10 = uvm10(0,:,:,:)
  v10 = uvm10(1,:,:,:)

  mx = loc(0) - 1
  ny = loc(1) - 1
  lat1  = f->XLAT(0,ny,mx)
  lon1  = f->XLONG(0,ny,mx)
  res               = True
  ;res@tiMainString  = "WRF: All Times: grid point ["+sprintf("%5.2f",lat1)+" , "+sprintf("%5.2f",lon1) +"]"

  wspd1= ndtooned(sqrt(u10(:,ny,mx)^2 + v10(:,ny,mx)^2))
  wdir1= ndtooned(atan2(u10(:,ny,mx),v10(:,ny,mx))/0.01745329 +180.)
  numPetals =  16  
  circFr    = 8. 
  spdBounds         = (/ 1., 3.,5.,10./)
  colorBounds       = (/ "blue", "green", "yellow", "red" /)
  wks = gsn_open_wks("png","wrf_ex4")
end
