begin 
  irec = 33 -1 ; 对应北京站在160站中位置，具体可查看station-name.txt

  ntime = 30   ; 共30年时间
  nstat = 160  ; 共160站
    
  ;读取全部数据，注意数据存放的路径，该例中存放在./data 下
  preci = fbindirread("./data/preci-160-JJA-30yr.grd",0,(/ntime,nstat/),"float") 
  
  ;手动添加meta data
  preci!0="year" 
  preci!1="station"
  preci&year = ispan(1979,2008,1)
  preci&station = ispan(1,160,1)
  
  ; 挑出北京站的数据,并计算各年的异常，保留meta data

   
;***************************************************** 
; create plot
;***************************************************** 
  wks = gsn_open_wks("eps","plot-bar-1station")  ;生成eps图            
 
  res           = True              
  res@gsnDraw   = False ; 暂不画
  res@gsnFrame  = False ; 暂不翻页

  res@vpHeightF = 0.35  ; 改变viewport的大小
  res@vpWidthF 	= 0.6   ; 

  res@trXMinF	  = 1979  ; 设定X轴坐标范围
  res@trXMaxF	  = 2008
  res@trYMaxF   = 450  ; 设定Y轴坐标范围
  res@trYMinF   = -300 

  
   ;           ; 设定bar的宽度

  ;设定bar。
  res@gsnYRefLine           = 0.              ; 设定参考值。
  res@gsnAboveYRefLineColor = "black"           ; 大于该参考值所用的颜色
  res@gsnBelowYRefLineColor = "gray"          ; 小于该参考值所用的颜色

  ;res@gsnXYBarChartColors = (/"black"/)   ;如果不设定参考值,则可通过该resources来设定	颜色 
   
  res@tiXAxisString	= "year"             ; 添加X轴名称   
  res@tiYAxisString	= "precipitation (units: mm)"    ; 添加Y轴名称 
  
  top_plot = gsn_csm_xy(wks,preci_st&year,preci_st,res)       ; 绘图
    
  draw(top_plot) ; 绘图
  frame(wks)     ; 翻页
end