begin
a = addfile("./data/wrfout_ex1_2014-12-31.nc","r")
wks = gsn_open_wks("eps","wrf_ex4")
gsn_define_colormap(wks,"gsltod")

res = True
res@MainTitle = "WRF_EX3"
res@Footer = False
pltres = True
pltres@NoTitles = True
times  = wrf_user_getvar(a,"times",-1) 
ntimes = dimsizes(times)         
FirstTime = True
mdims = getfilevardimsizes(a,"P") 
nd = dimsizes(mdims)

it = 1   ; 0,ntimes-1,2               
  print("Working on time: " + times(it) )
  res@TimeLabel = times(it)        
  tc = wrf_user_getvar(a,"tc",it)  
  rh = wrf_user_getvar(a,"rh",it)  
  z  = wrf_user_getvar(a, "z",it)  
  if ( FirstTime ) then            
    zmin = 0.
    zmax = max(z)/1000.
    nz   = floattoint(zmax/2 + 1)
    FirstTime = False
  end if
 angle = 0
  plane = new(2,float)
  plane = (/ mdims(nd-1)/2, mdims(nd-2)/2 /) 
  opts = False  

  dim = dimsizes(rh_plane) 
  zspan = dim(0)
  opts_xy        = res
  opts_xy@tiYAxisString    = "Height (km)"
  opts_xy@cnMissingValPerimOn  = True
  opts_xy@cnMissingValFillColor   = 0
  opts_xy@cnMissingValFillPattern = 11
  opts_xy@tmYLMode   = "Explicit"
  opts_xy@tmYLValues   = fspan(0,zspan,nz)        
  opts_xy@tmYLLabels    = sprintf("%.1f",fspan(zmin,zmax,nz)) 
  opts_xy@tiXAxisFontHeightF   = 0.020
  opts_xy@tiYAxisFontHeightF  = 0.020
  opts_xy@tmXBMajorLengthF        = 0.02
  opts_xy@tmYLMajorLengthF        = 0.02
  opts_xy@tmYLLabelFontHeightF    = 0.015
  opts_xy@PlotOrientation         = tc_plane@Orientation
  opts_xy@tiMainOn  = False
  opts_xy@lbTitleOn = False
  opts_rh = opts_xy
  opts_rh@ContourParameters       = (/ 10., 90., 10. /)
  opts_rh@pmLabelBarOrthogonalPosF = -0.07
  opts_rh@cnFillOn                = True
  opts_rh@cnFillColors            = (/0,0,0,0,5,10,15,20,25,30/);小于40用白色，之后全用灰色

  opts_tc = opts_xy
  opts_tc@cnInfoLabelOrthogonalPosF = 0.00
  opts_tc@ContourParameters  = (/ 10. /)

;end do       
end
