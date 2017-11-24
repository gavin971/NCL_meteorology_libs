begin
  ;;;;读取数据   
  f   = addfile("./data/h300-197901-201412.nc", "r")   
  var := short2flt(f->hgt(0,{300},:,:)) 
  
  wks  = gsn_open_wks("eps","plot-hgt-Satellite")
  gsn_define_colormap(wks,"amwg256")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = True          
  ;res@gsnMaximize  = True
  res@gsnLeftString = ""
  res@gsnRightString = ""  

   ; 投影类型
  res@mpCenterLonF       = 120.0       ; 图形中心经度及
  res@mpCenterLatF       = 50.         ;           纬度
    
 ; color continents
 ; 海洋                            
 ; 内陆湖泊
 ; 陆地
 ; turn on continental outlines
 ;"Geophysical" ; 边界线。其他较常用的为“National”或“AllBoundaries”
  
  ;; 设置等值线
  res@cnFillOn = False
  res@cnInfoLabelOn = False
  
  ; 低值中心用“L”标记
         ; turn on L labels
        ; change L font
  
  ; 高值中心用“H”标记
         ; turn on L labels
         ; change L font
  
  
  plot = gsn_csm_contour_map(wks,var,res)     
  
  draw(plot)  
  frame(wks)
end
