begin
a = addfile("./data/wrfout_ex1_2014-12-31.nc","r")
type = "ps"
wks = gsn_open_wks(type,"wrf_ex5")
  res = True
  res@NoHeaderFooter           = True          
  res@pmLabelBarOrthogonalPosF = -0.1
  res@lbTitleOn = False
  pltres = True
  pltres@PanelPlot = True   
  mpres = True
  mpres3 = True
  times = wrf_user_getvar(a,"times",-1) 
  ntimes = dimsizes(times)        
  plots = new ( 4, graphic )
  it = 1 
    print("Working on time: " + times(it) )
    res@TimeLabel = times(it)  
    slp = wrf_user_getvar(a,"slp",it)    
    wrf_smooth_2d( slp, 3 )          
    if ( it .eq. 0 ) then                
      tc = wrf_user_getvar(a,"tc",it)   
      td = wrf_user_getvar(a,"td",it)    
      u  = wrf_user_getvar(a,"ua",it)   
      v  = wrf_user_getvar(a,"va",it)  
      tc2 = tc(0,:,:)    
      td2 = td(0,:,:) 
      u10 = u(0,:,:)
      v10 = v(0,:,:)
    else
      tc2 = wrf_user_getvar(a,"T2",it)   
         tc2 = tc2-273.16          
      td2 =  wrf_user_getvar(a,"td2",it) 
      u10 = wrf_user_getvar(a,"U10",it) 
      v10 = wrf_user_getvar(a,"V10",it)  
    end if
    tf2 = 1.8*tc2+32.  
      ;tf2@description = "Surface Temperature"
      ;tf2@units = "F"
    td_f = 1.8*td2+32.  
      ;td_f@description = "Surface Dew Point Temp" 
      ;td_f@units = "F"
    u10 = u10*1.94386 
    v10 = v10*1.94386
      ;u10@units = "kts"
      ;v10@units = "kts"             
      opts = res         
      opts@cnFillOn = True
 
      opts@ContourParameters = (/ -20., 90., 5./)
      opts@gsnSpreadColorEnd = -3 
      contour_tc = wrf_contour(a,wks,tf2,opts)
      contour_tc2 = wrf_contour(a,wks,tf2,opts)
      delete(opts)
      opts = res         
      opts@cnFillOn = True 
      opts@cnLinesOn = True
      opts@cnLineLabelsOn = True
      opts@ContourParameters = (/ -30., 120., 15./) 
      opts@cnLineLabelBackgroundColor = 0
      opts@gsnSpreadColorEnd = -3  
      contour_td = wrf_contour(a,wks,td_f,opts)
      delete(opts)
      opts = res         
      opts@cnFillOn = True 
      contour_psl2 = wrf_contour(a,wks,slp,opts)
      opts@ContourParameters = (/ 986, 1042., 8. /)
      opts@cnFillOn = False 
      opts@cnInfoLabelOrthogonalPosF = -0.115
      opts@cnLineColor = "NavyBlue"
      opts@cnHighLabelsOn = True
      opts@cnLowLabelsOn = True
      opts@cnLineLabelBackgroundColor = 0
      opts@gsnContourLineThicknessesScale = 2.0
      contour_psl = wrf_contour(a,wks,slp,opts)
      delete(opts)  
      
      pltres@NoTitles = True
                  
      opts = res         
      ;opts@FieldTitle = "Wind"     
      opts@NumVectors = 20    
      vector = wrf_vector(a,wks,u10,v10,opts)
      delete(opts)

  pnlres                            = True
  ;pnlres@txString                   = "PLOTS for : " + times(it)
  pnlres@gsnPanelYWhiteSpacePercent = 1  
  pnlres@gsnPanelScalePlotIndex = 1
  pnlres@gsnPanelFigureStrings= (/"a)","b)","c)","d)"/)
  pnlres@amJust            = "topLeft

   
end
