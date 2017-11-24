begin

  ;;;;read SLP data   
  f     = addfile("./data/mslp.mon.mean.r2.nc", "r")  
  slp = short2flt(f->mslp(::12,{0:90},:))  ;读取每年的1月，北半球数据
  
  dims = dimsizes(slp)                    ; 返回各维的大小

  year = ispan(1979,1979+dims(0)-1,1)     ; 分析的各年份
  
  ;; 计算权重  
  w  = sqrt(cos(0.01745329*slp&lat) )     ; 权重系数                 
  wp = slp*conform(slp, w, 1)             ; wp
  copy_VarCoords(slp, wp)
  
  ;; EOF分解
  x    = wp({lat|20:90},lon|:,time|:)  ; 时间维放最右边
  neof = 2                             ; 保留前2模态，用于检验第1模态是否显著与其他模态相分离
  eof  = eofunc_Wrap(x, neof, False)   ; EOF分解

  ;; north 检验
  ntim = dims(0)               
  sig_pcv = eofunc_north(eof@pcvar, ntim, False)
    
  ;; 计算PC，并标准化
  eof_ts = eofunc_ts_Wrap (x, eof, False)
  eof_ts = dim_standardize_n(eof_ts,1,1)

  ;; 输出至netcdf文件

  ;; 回归SLP场 

  ;; t-test
   ; 创建新的变量
       ; 转变为 hPa
  
     
  
  
  
  ; 如下处理的目的是方便绘图（不是必须）
  confi_rc_slp = where(confi_rc_slp.eq.0,confi_rc_slp@_FillValue,confi_rc_slp)  
  confi_rc_slp = 1/confi_rc_slp
  confi_rc_slp = where(rc_slp.lt.0,-1*confi_rc_slp,confi_rc_slp)
  
  ;;;;;;;;;plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
  wks = gsn_open_wks("eps","plot-reg-SLP")
  gsn_define_colormap(wks,"rainbow")  
         
  res                   = True    
  
  res@gsnDraw           = False         
  res@gsnFrame          = False        
  res@gsnLeftString     = ""
  res@gsnRightString    = ""  

  res@gsnTickMarksOn = False ; 关闭经度标签。虽然默认是绘制经度标签，但由于其经度单位前没有“度”符号，即“o”，所以这里关闭了其经度标签。若需绘制标准的经度标签，可利用函数gsn_add_text（详见附录A.5节）以及文本函数符号“~”（附录图A.5）进行手动添加。
  
  resc = res          ;复制给resc,用以绘制回归场的等值线          
    
          ;北半球的极射赤面投影    
  
  res@mpFillOn        = False       
           ; 地图的最南纬度
  res@mpMaxLatF       = 90          ; 最北纬度
           ; 中心经度
  
  res@cnLevelSelectionMode  = "ExplicitLevels"
  res@cnLevels              = (/-20,20/) ; -20与20均对应着0.05置信度，但前者对应负值异常，后者对应正值异常
  res@cnFillColors          = (/"gray","white","gray"/)
  res@cnFillOn              = True 
  res@lbLabelBarOn          = False   ; 由于绘制的是显著性（只有几个值），一般不需要绘制以下几项           
  res@cnLinesOn             = False   ;  
  res@cnInfoLabelOn         = False   ; 
  res@cnLineLabelsOn        = False   ; 
   
 

  ;; 回归场等值线的设置
  resc@cnLevelSelectionMode  = "ExplicitLevels"
  resc@cnLevels              =  1.*ispan(-10,10,1)    
  resc@cnFillOn              = False    
  resc@cnInfoLabelOn         = False
  resc@gsnContourZeroLineThicknessF = 0.
  resc@cnLineThicknessF             = 2.
  resc@cnLineLabelsOn               = False
  plot = gsn_csm_contour(wks,rc_slp,resc) 
  plot = ColorNegDashZeroPosContour(plot,"black","black","black")
  
   ; 图层叠加

  ;; 添加格外的等值线
  resc2 = resc
  resc2@cnLevels           := (/-4,2/)  
  resc2@cnLineThicknessF   = 7.  
  resc2@cnMonoLineDashPattern = False
  resc2@cnLineDashPatterns    = (/1,0/) ; 两根线用不同的线型； 也可通过ColorNegDashZeroPosContour实现
  resc2@cnLineDashSegLenF     = 0.25    ; 虚线上每个线段的长度，会自动控制其之间的间隔
  plot2 = gsn_csm_contour(wks,rc_slp,resc2) 
   
  overlay(base,plot2)
  
  draw(base)
  frame(wks)

end
