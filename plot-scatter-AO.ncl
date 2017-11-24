begin
  
  itimes = 197901
  itimee = 201001

  siglvl = 0.01
    
  nyear = (itimee - itimes)/100+1

  xaxis = fspan(-2,2,nyear) ; x轴 与y轴的范围
  yaxis = xaxis
  
  ;;;;read air data   
  f   = addfile("./data/h300-197901-201412.nc", "r")   
  var := short2flt(f->hgt(:,0,{65:90},:))
  time  := f->time
  YYYYMM := cd_calendar(time,-1)

  ist = ind(itimes.eq.YYYYMM)
  ied = ind(itimee.eq.YYYYMM)  
  
  hgt = var(ist:ied:12,:,:)

  rad  =  3.1415926/180 ;4.0*atan(1.0)/180.0  
  lat  = hgt&lat
  clat = cos(lat*rad)

  vor = hgt(:,0,0)
  vor  = wgt_areaave(hgt(:,{65:90},:),clat,1.0,0) 
  vor  = dim_standardize(vor,0)

  ;;;;read AOI data   
  ncfile = addfile("SLP-PC1-jan-34yr.nc","r")
  eof_ts = ncfile->AOI
  AOI = eof_ts({1979:2010}) ; 截取部分时间段，以保证与air数据一致
    
  ;;直线拟合 


  ; y = mx+b 
  ; m is the slope:             returned from regline
  ; b is the y intercept: rc@yave attribute of rc returned from regline
  
  
  ;; 检验    
    
    
;;**plot**************************************
 wks  = gsn_open_wks("eps","plot-scatter-AO")              ; specifies a ps plot
 
 res                     = True                   ; plot mods desired
 res@gsnMaximize         = True                   ; maximize plot in frame
 res@gsnDraw             = False
 res@gsnFrame            = False
 
 if(prob.le.siglvl ) 
  
  else
   res@gsnCenterString  = "r is " + sprintf("%5.2f",m) + "(insig. @"+siglvl+")"   
 end if 
 
 res@trYMinF  = min(yaxis)
 res@trYMaxF  = max(yaxis)
 res@trXMinF  = min(xaxis)
 res@trXMaxF  = max(xaxis)
 
 res@tiXAxisString = "AO"
 res@tiYAxisString = "Vor."
 
 plot = gsn_csm_xy(wks,xaxis,data,res)        ; create plot
 
 pmres = True
 pmres@gsMarkerIndex    = 12
 pmres@gsMarkerSizeF    = 0.02
 pmres@gsMarkerColor    = "black"
 
 xl = eof_ts
 yl = vor 
 dum  = gsn_add_polymarker(wks,plot,xl,yl,pmres)  
 
 draw(plot)
 frame(wks)
end   
