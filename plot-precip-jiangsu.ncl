load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl" ; 如需将台站资料插值至格点资料，则必须加载该ncl文件

begin
  
  regrid_On = True  ; 是否需要插值。
  ;!! 注意，本文所用台站资料分辨率较低，直接用该资料进行绘图，则会在江苏省边界处出现些空白。因此，为达到较好的图形效果，首先将降水资料插值到0.1度均匀经纬度网格点上。但请读者务必注意，这种由低分辨率插值到高分辨率的结果可能存在较大误差。因此该例仅供示例讲解用。
   
  preci = fbindirread("./data/preci-160-JJA-30yr.grd",0,(/30,160/),"float")
  preci!0 = "year"
  preci!1 = "stations"
  preci&year = ispan(1979,2008,1)
  preci&stations = ispan(1,160,1)
  
  var = dim_avg_n_Wrap(preci,0) ; 取气候平均
  
  ;; 读取各个台站的经纬度坐标
  path_station = "./data/160stations.txt"
  station = asciiread(path_station,(/160,2/),"float") 
  lat = station(:,0)
  lon = station(:,1)
  
  ;是否进行差值
  if(regrid_On)
    minlat = min(lat)
    maxlat = max(lat)
    minlon = min(lon)
    maxlon = max(lon)
      
    Opt                 = True
    Opt@SrcGridLat      = lat
    Opt@SrcGridLon      = lon
    Opt@DstLLCorner     = (/floor(minlat)-0.1,floor(minlon)+0.1/)
    Opt@DstURCorner     = (/ceil(maxlat)-0.1, ceil(maxlon)+0.1/)
    Opt@DstGridType     = "0.1deg"   ; 插值后，数据的分辨率
    Opt@ForceOverwrite  = True
    Opt@Debug           = True
    
    Opt@InterpMethod    = "patch" ; 或者 "bilinear"
    var := ESMF_regrid(var,Opt) ; 由于插值后数组维数大小与原var不一致，所以需在"="前加上“:” 
  end if
 
  wks  = gsn_open_wks("eps","plot-preci-jiangsu")
  gsn_define_colormap(wks,"gsltod")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = False          
  res@gsnMaximize  = True
  
  ;; 若不插值，则直接用台站资料绘制
  if(.not.regrid_On)
   res@sfXArray    = lon
   res@sfYArray    = lat
  end if
  
  ;; 设置经纬线   
  res@mpGridAndLimbOn       = True 
  res@mpGridLineColor       = "red"
  res@mpGridLatSpacingF     = 1
  res@mpGridLonSpacingF     = 1
  res@mpGridLineDashPattern = 16
  res@mpGridLineThicknessF  = 0.2
 
  res@mpMaxLatF = 36  
  res@mpMinLatF = 30
  res@mpMaxLonF = 123
  res@mpMinLonF = 116  

     ; 中等分辨率             
                         
                
     
  
                               
    
  

   
          
  
  
  ;;设置坐标标签及字体大小
  res@pmTickMarkDisplayMode  = "Always"
  res@tmXBLabelFontHeightF   = 0.018    ; YL标签字体大小会同步变化，所以不用设置
  
  ;;设置等值线
  res@cnFillOn         = True     
  res@cnLineColor      = "white"
  res@cnLineThicknessF = 0.5
  res@lbOrientation    = "Vertical" ; 垂直摆放

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = 500     
  res@cnMaxLevelValF       = 560
  res@cnLevelSpacingF      = 5
    
   
   

  plot = gsn_csm_contour_map(wks,var,res)    

  draw(plot)  
  frame(wks)
end
