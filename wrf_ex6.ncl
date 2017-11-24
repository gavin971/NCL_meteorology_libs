begin
a = addfile("./data/wrfout_ex1_2014-12-31.nc","r")
Rain=(a->RAINC(5,:,:)+a->RAINNC(5,:,:))/1000.
HGT= wrf_user_getvar(a,"HGT",0)
wks = gsn_open_wks("eps" ,"wrf_ex6")
res                       = True             ; plot mods desired
res@gsnFrame              = False
res@gsnDraw               = False
res@cnFillOn              = True             ; color plot desired
res@cnFillPalette         = "gsltod"         ; Select grayscale colormap
res@cnLinesOn             = False            ; turn off contour lines
res@cnLineLabelsOn        = False            ; turn off contour labels
res@cnFillMode            = "RasterFill"
res@cnFillOpacityF        = 1.
res@lbLabelBarOn          = False
res@pmLabelBarHeightF     = 0.08
res@lbLabelFontHeightF    = 0.014
res@gsnRightString        =  ""
res@gsnLeftString         = ""  
res@mpGeophysicalLineThicknessF = 0.5       ; thickness of map outlines
res@mpGeophysicalLineColor = "black"

res@tfDoNDCOverlay        = True            ; necessary for correct overlay on map

res@pmTickMarkDisplayMode = "Always"         ; turn on nicer tickmarks
res@tmXBLabelFontHeightF  = 0.018
res@tmYLLabelFontHeightF  = 0.018
res@tmYLLabelStride       = 2                ; label every other tickmark
res@tmXBLabelStride       = 2
res@tmYRMajorOutwardLengthF = 0
res@tmYLMajorOutwardLengthF = 0
res@tmXBMajorOutwardLengthF = 0
res@tmXBMinorOutwardLengthF = 0
res@tmXTOn                  = True 
res@tmYROn                  = True 
res@tmYRLabelsOn            = False
res@tmXTLabelsOn            = False

res_rain                       = True
res_rain@gsnFrame              = False
res_rain@gsnDraw               = False

cmap     := read_colormap_file("rainbow")
cmap(0,:) = (/0,0,0,0/)      ; make first color fully transparent
res_rain@cnFillOn             = True
res_rain@cnFillMode           = "RasterFill"
res_rain@cnFillPalette        = cmap
res_rain@cnLinesOn            = False            ; turn off contour lines
res_rain@cnLineLabelsOn       = False            ; turn off contour labels
res_rain@cnFillOpacityF       = 1.               ; .85 
res_rain@tfDoNDCOverlay        = True            ; necessary for correct overlay on map
res_rain@cnLevelSelectionMode = "ManualLevels"
res_rain@cnMaxLevelValF       = 200.  
res_rain@cnMinLevelValF       = 40. 
res_rain@cnLevelSpacingF      = 15.  
res_rain@pmLabelBarHeightF    = 0.08        ; Make labelbar less thick
res_rain@lbLabelFontHeightF   = 0.014
res_rain@pmLabelBarOrthogonalPosF = -0.008
res_rain@cnInfoLabelOn        = False

res_rain@tiMainFont           = "Helvetica-bold"
res_rain@tiMainFontHeightF    = 0.018
;res_rain@gsnRightString       = "RAIN, mm" 
res_rain@gsnLeftString        =  ""
;res_rain@tiMainString = "Total Rainfall"

draw(plotrain)
frame(wks)
end
