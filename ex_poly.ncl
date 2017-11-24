begin
  ;南京经纬度
  lat_nj = 32.03  
  lon_nj = 118.46              

  ;假定一低压系统中心在某5天中的经纬度位置 
  lat_line = (/20,21,22,24,27,29/)
  lon_line = (/124,122.5,120,119,120,121/)
    
  ;假定该低压系统在后4天中的影响范围如下
  center_lat = 25     
  center_lon = 120   
  maxlat_region = center_lat+5
  minlat_region = center_lat-5
  maxlon_region = center_lon+3  
  minlon_region = center_lon-3 
  
  wks = gsn_open_wks("eps","poly_ex")

  res           = True                        ; plot mods desired
  res@gsnFrame    = False
  res@gsnDraw     = False                     ; don't draw plot yet

  res@mpMinLatF   = 15                      ; zoom in on a subregion
  res@mpMaxLatF   = 40
  res@mpMinLonF   = 110
  res@mpMaxLonF   = 130
  
  res@pmTickMarkDisplayMode = "Always"
  
  map = gsn_csm_map(wks,res)    

  ;;添加多边形。注意，要使图形闭合，需最后一个点的位置需与第一个点重合
  boxlat = (/ maxlat_region,  maxlat_region, minlat_region,  minlat_region, maxlat_region/)
  boxlon = (/minlon_region, maxlon_region,maxlon_region, minlon_region,minlon_region/)   

  gonres                  = True             
  
  ;;添加任意折线(即低压中心的移动路径) 
  lnres                   = True                      

  ;;添加marker（即低压中心位置）
  mkres                  = True             

    
  ;;添加marker(南京位置)          


  ;;添加文字

  
  draw(map)
  frame(wks)
    
end