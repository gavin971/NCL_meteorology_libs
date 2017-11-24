begin
  ncdf = addfile("SLP-PC1-jan-34yr.nc","r")    
  AOI = ncdf->AOI
  
   ; 9表示9个点滑动平均，本例对应着是9年的滑动；0表示最前与最后4年将设为缺省
  
  ;;;;;;;;;plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  wks = gsn_open_wks("eps","plot-xy-AOI")
  gsn_define_colormap(wks,"rainbow")  
         
  res           = True              
  res@gsnDraw   = False ; 暂不画
  res@gsnFrame  = False ; 暂不翻页
  
  res2 = res
  
  res@vpHeightF = 0.35  ; 改变viewport的大小
  res@vpWidthF 	= 0.6   ; 

  res@trXMinF	  = 1979  ; 设定X轴坐标范围
  res@trXMaxF	  = 2012
  res@trYMaxF   = 3  ; 设定Y轴坐标范围
  res@trYMinF   = -3 

  ;设定大于与小于0时的填色
            ; 设定参考值。
            ; 大于该参考值所用的颜色
            ; 小于该参考值所用的颜色

  res@tiXAxisString	= "year"   ; 添加X轴名称   
  res@tiYAxisString	= "AOI"    ; 添加Y轴名称 
  
  plot = gsn_csm_xy(wks,AOI&year,AOI,res)       
  
  res2@xyLineColor = "black"
  res2@xyLineThicknessF = 4. 
  plot_mean = gsn_csm_xy(wks,AOI&year,AOI_mean,res2)
  overlay(plot,plot_mean)
    
  draw(plot) 
  frame(wks)  
end
