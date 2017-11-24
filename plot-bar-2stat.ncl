begin

  name = (/"Beijing","Shanghai"/)  
  irec = (/33,56/) -1    ; 指定要分析的台站
  fp  = (/6,17/)         ; 指定后面绘图时用哪种图形类型填充两个台站的直方图
  co  = (/"black","gray"/) ; 指定填充的颜色
  
  syear = ispan(1980,2000,10) ; 指定要分析的年份，也可直接赋值(/1980,1990,2000/)
  nyear = dimsizes(syear)

  ntime = 30   ; 共30年时间
  nstat = 160  ; 共160站
    
  ;读取全部数据，注意数据存放的路径，该例中存放在./data 下
  preci = fbindirread("./data/preci-160-JJA-30yr.grd",0,(/ntime,nstat/),"float") 
  
  ;手动添加meta data
  preci!0="year" 
  preci!1="station"
  preci&year = ispan(1979,2008,1)
  preci&station = ispan(1,160,1)
  
  ; 挑出这两个站在特定年份的数据，这里利用了named dimension 对行列顺序进行了转置
  preci_st = preci(station|irec,{year|syear}) 
  ndim = dimsizes(preci_st)
  
;***************************************************** 
  wks = gsn_open_wks("eps","plot-bar-2stat")                 ; create plot
    
  res                    = True              ; plot mods desired
  res@gsnDraw            = False             ; don't draw yet
  res@gsnFrame           = False             ; don't advance frame yet

  res@vpWidthF  = 0.7
  res@vpHeightF = 0.5

  res@trXMinF = 0.5
  res@trXMaxF = 3.5
  res@trYMinF = 0
  res@trYMaxF = 900
  
  res@tmXBMode     = "Explicit"         ; 指定坐标标签 
  res@tmXBValues   = ispan(1,nyear,1)   ;
  res@tmXBLabels   = ispan(1980,2000,10); 

  res@tiXAxisString	= "year"             ; 添加X轴名称   
  res@tiYAxisString	= "precipitation (units: mm)"    ; 添加Y轴名称 
     
  bw = 0.2
  res@gsnXYBarChart         = True  
  res@gsnXYBarChartBarWidth = bw ;           ; 设定bar的宽度
  res@gsnXYBarChartPatterns = fp(0)
  res@gsnXYBarChartColors   = co(0)	
  res@gsnXYBarChartOutlineThicknessF = 1
  plot1 = gsn_csm_xy(wks,ispan(1,nyear,1)-bw/2,preci_st(0,:),res)		; 每一个台站都要单独画一次
  
  res@gsnXYBarChartPatterns = fp(1)
  res@gsnXYBarChartColors   = co(1)				 ; 用不同颜色
  plot2 = gsn_csm_xy(wks,ispan(1,nyear,1)+bw/2,preci_st(1,:),res)		;
 
 ;在直方图上添加数字，表明对应的降水量
 txres               = True                            
 txres@txFontHeightF = 0.015    ; 设定字体大小

 label_value = ndtooned(preci_st)    
 label = floattointeger(label_value) ; 虽有warning出现，但不影响出图。
 
 ;; 如果用户需画多个台站，则需自行对如下数组及参数进行修改
    ; 新建一个与preci_st一样大小的数组
 
 
 
         ; 往上挪动           
 
 
 ; 在空白处手动添加图例
 lbres                    = True          
 lbres@vpWidthF           = 0.3           ; viewport的宽度
 lbres@vpHeightF          = 0.1           ; viewport的宽高度
 lbres@lbBoxMajorExtentF  = 0.36          ; 缩小图例，使其中间有些空白

 lbres@lbMonoFillPattern  = True          ; Solid fill pattern
 lbres@lbLabelFontHeightF = 0.015          ; 标签字体大小
 lbres@lbPerimOn          = False         ; 周围是否加上方框
 ;lbres@lgPerimColor 	    = "black"       ; 方框的颜色
 
 lbres@lbFillPattern   = fp(1)  
 lbres@lbFillColors    = co(1)  
  	;第2个参数表示只画1个laberbar box
 
 lbres@lbFillPattern   = fp(0)
 lbres@lbFillColors    = co(0)   
  	; 绘制左边直方图的labelbar 

 draw(plot1)
 draw(plot2)                                   
                                      
 frame(wks)         
 
end