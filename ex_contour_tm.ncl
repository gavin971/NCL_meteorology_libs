begin
  z = generate_2d_array(15,15,-100.,110.,0,(/40,40/))

  wks = gsn_open_wks("eps","contour_tm_ex")
  gsn_define_colormap(wks,"GrayWhiteGray")
  
  res = True  
  res@gsnDraw   = False 
  res@gsnFrame  = False 

  res@cnFillOn             = True 
  
  res@cnLinesOn            = True 
  res@cnLineThicknessF     = 0.5
  
  
  res@tmXTOn = False
 
  plot = gsn_csm_contour(wks,z,res)

  draw(plot)
  frame(wks)
  
end