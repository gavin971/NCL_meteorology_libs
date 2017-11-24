; 首先自定义一个名为add_lc_labels的程序，用以添加经纬度标签
procedure add_lc_labels(wks,map,minlat,maxlat,minlon,maxlon,fontheight)
local lat_values, nlat, lat1_ndc, lat2_ndc, lon1_ndc, lon2_ndc,slope,txres, \
lon_values, PI, RAD_TO_DEG, dum_lft, dum_rgt, dum_bot
begin
  PI         = 3.14159
  RAD_TO_DEG = 180./PI

  ;挑出“较好”的纬度标签
  lat_values = ispan(toint(minlat),toint(maxlat),10) * 1.
  nlat      = dimsizes(lat_values)
  
  ;分别计算图形左、右线条的斜率（基于NDC坐标）
  lat1_ndc = new(1,float)
  lon1_ndc = new(1,float)
  lat2_ndc = new(1,float)
  lon2_ndc = new(1,float)
  datatondc(map,minlon,lat_values(0),lon1_ndc,lat1_ndc)
  datatondc(map,minlon,lat_values(nlat-1),lon2_ndc,lat2_ndc)
  slope_lft = (lat2_ndc-lat1_ndc)/(lon2_ndc-lon1_ndc)

  datatondc(map,maxlon,lat_values(0),lon1_ndc,lat1_ndc)
  datatondc(map,maxlon,lat_values(nlat-1),lon2_ndc,lat2_ndc)
  slope_rgt = (lat2_ndc-lat1_ndc)/(lon2_ndc-lon1_ndc)
  
  txres              = True
  txres@txFontHeightF = fontheight
  txres@txPosXF     = 0.1

  dum_lft = new(nlat,graphic)    ; 创建变量，用以绘制经纬度字符
  dum_rgt = new(nlat,graphic)    ; 
  do n=0,nlat-1
    ;添加适当空白
    lat_label_rgt = "          "  + lat_values(n) + "~S~o~N~"  ;见附录图A.5

    ;检查是否在北纬、南纬或赤道上 
    if(lat_values(n).lt.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~S          "  ;见附录图A.5
      lat_label_rgt = lat_label_rgt + "S"
    end if
    if(lat_values(n).gt.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~N          "  ;见附录图A.5
      lat_label_rgt = lat_label_rgt + "N"
    end if
    if(lat_values(n).eq.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~           "  ;见附录图A.5
    end if

    ;添加左边坐标标签
    txres@txAngleF = RAD_TO_DEG * atan(slope_lft) - 90 ; 适当旋转字体以更加美观
    dum_lft(n) = gsn_add_text(wks,map,lat_label_lft,minlon,lat_values(n),txres)

    ;添加右边坐标标签
    txres@txAngleF = RAD_TO_DEG * atan(slope_rgt) + 90
    dum_rgt(n) = gsn_add_text(wks,map,lat_label_rgt,maxlon,lat_values(n),txres)
  end do

;----------------------------------------------------------------------
  ; 添加经度标签
  delete(txres@txPosXF)
  txres@txPosYF = -5.0

  ;挑出“较好”的经度标签
  lon_values = ispan(toint(minlon+10),toint(maxlon-10),10) * 1.
  nlon     = dimsizes(lon_values)

  dum_bot = new(nlon,graphic)    

  do n=0,nlon-1
    ; 对于每个经度标签，计算其需旋转的角度，以使字体更加美观。
    datatondc(map,lon_values(n)-0.25,minlat,lon1_ndc,lat1_ndc)
    datatondc(map,lon_values(n)+0.25,minlat,lon2_ndc,lat2_ndc)
    slope_bot = (lat1_ndc-lat2_ndc)/(lon1_ndc-lon2_ndc)
    txres@txAngleF  = atan(slope_bot) * RAD_TO_DEG

    ;针对不同的东经、西经或0度绘制不同的字符
    lon_label_bot = "  ~C~  ~C~" + abs(lon_values(n)) + "~S~o~N~"  ;见附录图A.5
    if(lon_values(n).lt.0) then
      lon_label_bot = lon_label_bot + "W"
    end if
    if(lon_values(n).gt.0) then
      lon_label_bot = lon_label_bot + "E"
    end if

    dum_bot(n) = gsn_add_text(wks,map,lon_label_bot,lon_values(n),minlat,txres)
  end do
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

begin
  ; 绘制的空间范围
  minlat =  20.    
  maxlat =  70.    
  minlon =  60.    
  maxlon =  140.    
  fontheight = 0.012 ; 设置坐标标签字体大小
  
  ;;;;读取数据   
  f   = addfile("./data/h300-197901-201412.nc", "r")   
  var := short2flt(f->hgt(0,{300},{minlat:maxlat},{minlon:maxlon})) 
  
  wks  = gsn_open_wks("eps","plot-hgt-lambert")
  gsn_define_colormap(wks,"rainbow")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = False          

  res@gsnLeftString = ""
  res@gsnRightString = ""  

  
  
   ; 投影类型
  res@mpMinLatF      = minlat
  res@mpMaxLatF      = maxlat
  res@mpMinLonF      = minlon
  res@mpMaxLonF      = maxlon

  res@mpGridAndLimbOn         = True  
  res@mpGridLatSpacingF       = 10
  res@mpGridLonSpacingF       = 10
  res@mpGridLineDashPattern   = 1
  res@mpGridLineColor         = "white"
     
  ;; 设置等值线
  res@cnFillOn = True
  res@cnLineLabelsOn = True
  res@cnLineLabelFontHeightF = 0.015
  res@lbLabelFontHeightF     = 0.015
  
  ; 低值中心用“L”标记
  res@cnLowLabelsOn              = True     ; turn on L labels
  res@cnLowLabelFontColor        = "white"
    
  plot = gsn_csm_contour_map(wks,var,res)     
  
  draw(plot)  
  frame(wks)
end
