begin  
  a   = addfile("./data/air2m-197901-201412.nc","r")
  t   = short2flt(a->air(:,0,:,:))    ;读取2m气温

   ;需输出pdf图

  res                 = True    
  res@gsnLeftString   = ""      
  res@gsnRightString  = ""

  ;最好设定同样的等值线，以便动画时进行比较    

  res@cnMinLevelValF       =  195.0
  res@cnMaxLevelValF       =  328.0
  res@cnLevelSpacingF      =  2.25

  res@cnFillOn             = True    ; 填色
  res@cnLinesOn            = False   ; 关闭等值线
  res@cnLineLabelsOn       = False   ; 及其数值标签

  do ii=0,30
   res@tiMainString      = "January Global Surface Temperature (K) - Day " + (ii + 1)
   plot = gsn_csm_contour_map(wks,t(ii,:,:),res)
  end do
end
