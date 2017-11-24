begin
  name = (/"Beijing","Shanghai","Lijiang","Wulumuqi"/)  
  irec = (/33,56,115,160/) -1 ; 对应北京、上海、丽江及乌鲁木齐四个站在160站中位置，具体可查看station-name.txt

  ntime = 30   ; 共30年时间
  nstat = 160  ; 共160站
    
  ;读取全部数据，注意数据存放的路径，该例中存放在./data 下

  
  ;手动添加meta data
  preci!0="year" 
  preci!1="station"
  preci&year = ispan(1979,2008,1)
  preci&station = ispan(1,160,1)
  
  ; 挑出这四个站的数据

   
;***************************************************** 
; create plot
;***************************************************** 
  wks = gsn_open_wks("eps","plot-preci-4stations")  ;生成eps图            
 
  res           = True              

  res@vpHeightF = 0.35  ; 改变viewport的大小
  res@vpWidthF 	= 0.6   ; 

  res@trXMinF	  = 1979  ; 设定X轴坐标范围
  res@trXMaxF	  = 2008
  res@trYMaxF   = 1400   ; 设定Y轴坐标范围
  res@trYMinF   = 0 

                ; 对xy lines使用多种颜色
  res@xyLineThicknesses	= (/3., 1.,1.,1./)      ; 设定不同的粗细，3为3倍粗，4个值对应4个站
  res@xyDashPattern	    = 0                     ; 设定全部xy line为实线
  res@xyMarkLineModes   = (/"MarkLines","MarkLines","MarkLines","MarkLines"/) ; 设定xy line 的类型,如果都是“Markers”，则为散点图。
  res@xyMarkers         = (/9,7,5,3/)   ; 设定xy line上marker 的类型
  res@xyMarkerSizeF     = 0.01          ; 设定xy line上marker的大小
  res@xyLineColors      = (/"black","red","blue","brown"/)  ; 设定xy line的颜色

  res@tiXAxisString	= "year"             ; 添加X轴名称   
  res@tiYAxisString	= "precipitation (units: mm)"    ; 添加Y轴名称 
   
  res@pmLegendDisplayMode    = "Always"  ; 打开图例 
  res@pmLegendSide           =  "top"    ; 改变图例的位置，默认"bottom" 
  res@pmLegendParallelPosF   = 0.18      ; 正值向右移动
  res@pmLegendOrthogonalPosF = -0.32     ; 负值向下移动
  res@pmLegendWidthF         = 0.2       ; 改变图例的长短与高度
  res@pmLegendHeightF        = 0.1       ;   
  
        ; 改变图例标签字体的大小
        ; 图例上不要绘制边框

        ; 指定图例标签的文字内容

        ; 绘制垂直于X轴的参考线
        ; 其线型
        ; 及粗细
  
        ; 绘制垂直于Y轴的参考线
        ; 其线型
        ; 及粗细

  top_plot = gsn_csm_xy(wks,preci_st&year,preci_st(station|:,year|:),res)       ; 绘图
  
end