begin
  f = addfile("./data/air.mon.mean.nc","r")
  var = short2flt(f->air(0,:,:,:))  ; [time | 753] x [level | 17] x [lat | 73] x [lon | 144]
  
  wks = gsn_open_wks("eps","color")              
  
  res = True
  res@gsnAddCyclic   = True
  res@cnFillOn       = True
  res@pmTickMarkDisplayMode = "Always"

  res@gsnLeftString = ""
  res@gsnRightString= ""
      
  ;;; 指定要绘制的等值线及填充的颜色
        
  
  plot = gsn_csm_contour_map_ce(wks,var({700},:,:),res)                         
end

