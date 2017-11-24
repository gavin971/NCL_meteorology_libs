load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
year=ispan(1979,2013,1)  ; 79/80 - 13/14

it_s=197912  ;起始年月
it_e=201411  ;结束年月

refmag = 3   ;参考箭头所表示的风速大小

;;;read data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;;  sst


   time   = f_sst->time              ; 读取其日期
       ; 转换成公历日期

          ; 截取指定时间段
          ;
    ;

   ;; h300 
   f_h300 = addfile("./data/h300-197901-201412.nc", "r")
   h300   = short2flt(f_h300->hgt(rec_s:rec_e,0,{-90:90},:))  

   ;; u850 
   f_u850 = addfile("./data/u850-197901-201412.nc", "r")
   u850   = short2flt(f_u850->uwnd(rec_s:rec_e,0,{-90:90},:))  ; 850 hPa    
   
   ;; v850 
   f_v850 = addfile("./data/v850-197901-201412.nc", "r")
   v850   = short2flt(f_v850->vwnd(rec_s:rec_e,0,{-90:90},:))  ; 850 hPa

   ;; air2m 
   f_air2m = addfile("./data/air2m-197901-201412.nc", "r")
   air2m   = short2flt(f_air2m->air(rec_s:rec_e,0,{-90:90},:))  ; T at 2m    

;;;DJF 平均 & 异常 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;JFM季节平均，实际是12/1/2月三个月平均，因为从1979年12月开始截取
  copy_VarMeta(sst(0,:,:),sst_DJF(0,:,:))
  sst_DJF!0 = "year"
  sst_DJF&year=year 
  
  sst_ano = dim_rmvmean_n_Wrap(sst_DJF,0)
   
  ;; h300
  h300_DJF = month_to_season(h300, "JFM") 
  copy_VarMeta(h300(0,:,:),h300_DJF(0,:,:))
  h300_DJF!0 = "year"
  h300_DJF&year=year 

  h300_ano = dim_rmvmean_n_Wrap(h300_DJF,0)

  ;; u850 与h300 同维  
  u850_DJF = month_to_season(u850, "JFM") 
  copy_VarMeta(h300_DJF,u850_DJF)

  u850_ano = dim_rmvmean_n_Wrap(u850_DJF,0)
  
  ;; v850 与h300 同维  
  v850_DJF = month_to_season(v850, "JFM") 
  copy_VarMeta(h300_DJF,v850_DJF)   

  v850_ano = dim_rmvmean_n_Wrap(v850_DJF,0)
    
  ;; air2m
  air2m_DJF = month_to_season(air2m, "JFM") 
  copy_VarMeta(air2m(0,:,:),air2m_DJF(0,:,:))
  air2m_DJF!0   ="year"
  air2m_DJF&year=year   
    
  air2m_ano = dim_rmvmean_n_Wrap(air2m_DJF,0)
    
;;;(3) enso index (5N-5S, 170-120W);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
     ; 0表示仅用非缺省的数值进行计算 
     ;1 表示标准化时除以的是[N] ; 而0表示除以[N-1]
  
  ;; 输出至netcdf文件
  path_out = "ENSO-index.nc"
  system("rm -f "+ path_out)      ; 若当前路径下有同名文件，则删除
  ncdf = addfile(path_out,"c")    ; "c" 表示创建 netCDF 文件
  ncdf->ensoi = ensoi
  
;;;(4) composite ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  nnumb = dimsizes(irec_positive) 
  
    
  h300_comp  = dim_avg_n_Wrap(h300_ano(irec_positive,:,:),0) 
  u850_comp  = dim_avg_n_Wrap(u850_ano(irec_positive,:,:),0)    
  v850_comp  = dim_avg_n_Wrap(v850_ano(irec_positive,:,:),0) 
  air2m_comp = dim_avg_n_Wrap(air2m_ano(irec_positive,:,:),0)  

;;; (5) t-test ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; sst


  ;; h300
  h300_std = dim_variance_n_Wrap(h300_ano(irec_positive,:,:),0)
  h300_std = sqrt(h300_std/nnumb)
  t_h300   = h300_comp/h300_std       
  confi_h300 = h300_comp
  confi_h300 = student_t(t_h300, nnumb-1)   

  ;; air2m
  air2m_std = dim_variance_n_Wrap(air2m_ano(irec_positive,:,:),0)
  air2m_std = sqrt(air2m_std/nnumb)
  t_air2m   = air2m_comp/air2m_std       
  confi_air2m = air2m_comp
  confi_air2m = student_t(t_air2m, nnumb-1) 
    
;;; (5) plot
  wks = gsn_open_wks("eps","plot-comp-enso")
  gsn_define_colormap(wks,"rainbow+gray")  ; 调用rainbow+gray色板,，其它色板名称请查阅http://www.ncl.ucar.edu/Document/Graphics/color_table_gallery.shtml
  
  base = new(3,"graphic")
  plot = new(3,"graphic")  
        
  res                   = True   ; 调整地图及显著性等值线, 每个子图均需该res
  res@gsnAddCyclic      = True   ; 添加循环点，否则会在0度经线左侧出现一根白条
  res@gsnDraw           = False        
  res@gsnFrame          = False        
  res@gsnLeftString     = ""
  res@gsnRightString    = ""
  
  resc = res  ;拷贝
  resv = res  ;
  rest = res  ;
  
  res@mpFillOn             = False        ; 不填色地图
  res@mpCenterLonF         = 180          ; 地图的中心经度 
  res@mpGeophysicalLineThicknessF = 0.5   ; 地图边界的粗细
  res@pmTickMarkDisplayMode= "Always"     ; 坐标上标签上添加度符号
  res@mpGridAndLimbOn      = True         ; 绘制经纬度线
             ; 经纬度线间隔
             ;
              ; 经纬度线线型取为类型为2的虚线。共17种线型供选择。
            ; 其粗细
              
  res@cnFillOn             = True         ; 填色等值线
  res@cnLinesOn            = True         ; 绘制等值线
  res@cnLineColor          = "white"      ; 颜色
  res@cnLineThicknessF     = 0.3          ; 粗细
  res@cnLineLabelsOn       = False        ; 关闭标签

  
  
    ; 用GMT_gray 进行填色。即调用了第2种色板
    ; -1 为透明 
  res@cnInfoLabelOn         = False       ; 关闭图右下方的等值线信息标签
  res@lbLabelBarOn          = False       ; 关闭labelbar
 
  resc@cnLevelSelectionMode  = "ExplicitLevels"                ; 指定每根需绘制的等值线
  resc@cnLevels              = (/-0.75,-0.25,0.25,0.75,1.25/)  ;   
  resc@cnFillOn              = False     ; 关闭等值线填色 
  resc@cnLineThicknessF      = 2.        ; 等值线粗细  
  resc@gsnContourZeroLineThicknessF = 0. ; 设置0值线粗细。0则不画
  resc@cnLineLabelsOn        = False     ; 关闭标签
  resc@cnLineDashPattern     = 16        ; 线型为16的虚线
  resc@cnInfoLabelOn         = True      ; 打开图右下方的等值线信息标签
  resc@cnInfoLabelOrthogonalPosF = 0.05  ; 移动等值线信息标签的位置

  resv@vcPositionMode            = "ArrowTail"  ;箭头尾部对应着格点的位置
  resv@vcGlyphStyle              = "Fillarrow"  ;其余三种选项为“LineArrow”、“WindBarb” 、“CurlyVector”
  resv@vcFillArrowEdgeThicknessF = 2         ; 箭头边界粗细
  resv@vcFillArrowEdgeColor      = "white"   ; 及颜色
  resv@vcFillArrowFillColor      = "black"  ; 箭头内部填充颜色
  resv@vcFillArrowWidthF         = 0.1       ; 箭头宽度
  resv@vcFillArrowHeadXF         = 0.6       ; 请参考附录中Fillarrow箭头示意图
  resv@vcFillArrowHeadYF         = 0.2       ;
  resv@vcFillArrowHeadInteriorXF = 0.25      ; 
           
  resv@vcMinDistanceF            = 0.03    ; 箭头之间的最小距离（在单位平方中）
  resv@vcMinMagnitudeF           = 1.0     ; 要绘制箭头所表示的最小数值，即小于该数值则不绘制

  resv@vcFillArrowMinFracWidthF =1.0 
  resv@vcFillArrowHeadMinFracXF =1.0  
  resv@vcFillArrowHeadMinFracYF =1.0 
  
    ;****设定参考箭头****
    resv@vcRefAnnoOn               = True  
    resv@vcRefMagnitudeF           = refmag  ;标准长度箭头所表示的大小
    resv@vcRefLengthF              = 0.045   ;标准长度箭头在单位平方中的大小
    resv@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
    resv@vcRefAnnoPerimOn          = False   ;关闭边框    
                                        
    resv@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
    
    resv@vcRefAnnoString1On     = False   ;设定参考箭头上、下的字符        
    resv@vcRefAnnoString2On     = True    ; 这里仅设定其下方的字符
    resv@vcRefAnnoString2       = refmag+" m/s"  
           
    resv@vcRefAnnoSide            = "Top" ; 参考箭头放至图形上方
    resv@vcRefAnnoOrthogonalPosF  = -0.12 ; 调整其位置
    resv@vcRefAnnoParallelPosF    = 0.95 
    

  res@gsnCenterString            = "sst" ;子图的主标题 
  res@gsnCenterStringFontHeightF = 0.03  ; 标题字体的大小。由于后面没有修改该值，则每幅图的主标题字体均是此大小
    ; 只有底图可有地图（map）  
        ; 调用的绘图函数不可带“map”
  plot(0) = ColorNegDashZeroPosContour(plot(0),"blue","white","red") ; 负值用蓝色虚线表示，0线用白色实线，正值红色实线
       ; 带地图的图必须放在最下图层

  ; 绘制多边形及折线以标明nino 3.4区 
  plres                  = True
  plres@gsLineColor      = "black"
  plres@gsLineThicknessF = 1.0
  
  gres                   = True
  gres@gsFillColor       = "yellow"
  gres@gsFillOpacityF    = 0.5
  gres@gsLineColor       = "black"
   
  latx = (/-5,    5,  5, -5, -5/)    ; nino3.4区的坐标位置
  lonx = (/190, 190,240, 240, 190/)  ;
  dum1 = gsn_add_polyline(wks, base(0),lonx,latx,plres)   
  dum2 = gsn_add_polygon(wks,base(0),lonx,latx,gres)
  
  res@gsnCenterString = "h300&V850"  
  resc@cnLevelSelectionMode  = "AutomaticLevels" 
  resc@cnLevelSpacingF = 15.
  base(1) = gsn_csm_contour_map(wks,confi_h300,res)  
  plot(1) = gsn_csm_contour(wks,h300_comp,resc) 
  plot(1) = ColorNegDashZeroPosContour(plot(1),"blue","white","red")
  overlay(base(1),plot(1))
  
  plotv   = gsn_csm_vector(wks,u850_comp,v850_comp,resv) 
  overlay(base(1),plotv)  ; 也可用gsn_csm_vector_map(wks,h300_comp,u850,v850,res_new)

  res@gsnCenterString       = "air2m"  
  resc@cnLevelSelectionMode = "ManualLevels" 
  resc@cnMaxLevelValF       = 2
  resc@cnMinLevelValF       = -2 
  resc@cnLevelSpacingF      = 0.5    
  base(2) = gsn_csm_contour_map(wks,confi_air2m,res)  
  plot(2) = gsn_csm_contour(wks,air2m_comp,resc) 
  plot(2) = ColorNegDashZeroPosContour(plot(2),"blue","black","red")
  overlay(base(2),plot(2))  
  
  resP = True                        ; 绘制panel图
  resP@txString       = "El nino"    ; 添加主标题
  resP@txFontHeightF  = 0.03         ; 修改其大小  

 ; resP@gsnPanelFigureStrings= (/"a)","b)","c)"/)  ;各个子图的标号
  resP@gsnPanelFigureStringsFontHeightF = 0.015   ;字体的大小 
  resP@amJust = "TopLeft"                         ;摆放的位置，默认是“BottomRight”
  
          ; 指定每行绘制的子图的个数
          ; 第1行绘制1幅，第2行绘制2幅
end
