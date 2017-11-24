begin
  f=addfile("./data/hgt.sfc.nc","r")
  var = short2flt( f->hgt(0,:,:))
  
  wks = gsn_open_wks("eps","contourmap")     
  gsn_define_colormap(wks,"GMT_gray")
   
  res                 = True                   
  res@gsnLeftString   = "height"                   
  res@gsnRightString  = "m"                 
  res@gsnCenterString = "Terrian"
  res@gsnCenterStringFontHeightF = 0.05  
  
  res@pmTickMarkDisplayMode = "Always"
  
  ;; 绘制的地图区域
  res@mpMinLatF    = 10          
  res@mpMaxLatF    = 80
  res@mpMinLonF    = 30
  res@mpMaxLonF    = 130
  
  res@mpFillOn               = False         
  res@mpGridSpacingF         = 10.     ;

  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
  
  plot = gsn_csm_contour_map(wks,var,res)
end
