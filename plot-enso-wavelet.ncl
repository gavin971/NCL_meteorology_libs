load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

  f      = addfile("./data/ENSO-index.nc", "r") 
  ensoi  = f->ensoi
  
  time = ensoi&year
  
  N  = dimsizes(ensoi)
  
  ;; 小波计算
  mother  = 0       ; 母小波类型，通常为0，即'Morlet'小波。其余两中被分别为1，'Paul'小波和2，'DOG' (derivative of Gaussian)小波
  dt      = 1       ; 数组中数值之间的时间间隔，通常为1。本例中表示间隔1年。
  param   = -1      ; 母小波参数。 如果param < 0，则使用默认数值，即采用'Morlet'小波时为6；Paul'小波为4;'DOG'小波为2
  s0      = dt      ; 'Morlet'小波s0 = dt ; 'Paul'小波s0 = dt/4  
  dj      = 0.25    ; 常用设定
  jtot    = 1+floattointeger(((log10(N*dt/s0))/dj)/log10(2.)) ; 常用设定
  npad    = N       ; 常用设定
  nadof   = 0       ; 常用设定
  noise   = 1       ; 常用设定,h红噪声检验
  siglvl  = .05     ; 置信度水平
  isigtest= 0       ; 采用chi-square 检验；若为1则是对全部波谱进行时间平均检验


  ;************************************
  power            = onedtond(w@power,(/jtot,N/))  ; 功率谱
  power!0          = "period"                      ; Y axis
  power&period     = w@period                     

  power!1          = "time"                        ; X axis
  power&time       = time

  power@long_name  = "Power Spectrum"
  power@units      = "1/unit-freq"

  ;计算显著性 ( >= 1 则显著)
  SIG              = power                         ; 复制元数据
  SIG              = power/conform (power,w@signif,0)
  SIG@long_name    = "Significance"
  SIG@units        = " "

 ;*************************************************
  wks = gsn_open_wks("eps","plot-enso-wavelet")             
  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")   
 
  YLValues = (/1,2,4,8,16/)
  YLLabels = (/"1","2","4","8","16"/)
  
  res                     = True                  
  res@gsnDraw             = False              
  res@gsnFrame            = False                 
  res@gsnRightString      = " "
  res@gsnLeftString       = " "

  res@trYReverse = True                  ; 倒置 y-axis
  res@tmYLMode   = "Explicit"
  res@tmYLValues = YLValues
  res@tmYLLabels = YLLabels
  res@tmLabelAutoStride   = True

  res@trYMaxF        = max(YLValues)
  ;res@trYMinF        = min(YLValues)

  res@cnLinesOn      = False               
  res@cnLineLabelsOn = False
  res@cnInfoLabelOn  = False
    
  res2 = res
 
  res@tiYAxisString       = "Years"  

  res@cnFillOn            = True                 
  res@cnFillMode          = "RasterFill"          
  res@cnRasterSmoothingOn = True                  
  
  ;;;;;;;;;;;;;
  res2@cnLevelSelectionMode = "ManualLevels" 
  res2@cnMinLevelValF       = 0.00        
  res2@cnMaxLevelValF       = 2.00        
          
  res2@cnFillScaleF         = 0.5     ; 增加形状填充的密度（通过下面调用ShadeGtContour实现形状填充）

  plot = gsn_csm_contour(wks,power,res)
  iplot = gsn_csm_contour(wks,SIG,res2)

   ; 形状填充
  overlay(plot,iplot)				; 在原图上添加显著性

   ;将有边界效应的区域用网格表示
  
  ;;添加各频率的功率 
  gws = w@gws
  resl = True
  resl@gsnFrame      = False
  resl@gsnDraw       = False
  resl@trYAxisType   = "LogAxis"
  resl@trYReverse    = True                  ; reverse y-axis
  resl@tmYLMode      = "Explicit"
  resl@tmYLValues    = YLValues
  resl@tmYLLabels    = YLLabels
  resl@trYMaxF       = max(YLValues)
  resl@trYMinF       = min(YLValues) 
  resl@tiXAxisString = "Global Wavelet Power"

  plotg = gsn_csm_xy(wks,gws,power&period,resl) 
  
  ;; 将plotg添加至plot的右侧
   

 draw(plot)
 frame(wks)
end

