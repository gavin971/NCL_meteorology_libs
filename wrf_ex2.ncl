begin
a = addfile("./data/geo_em.d01.nc","r")
type = "png" 
wks = gsn_open_wks(type,"wrf_ex2")
gsn_define_colormap(wks,"MPL_gist_yarg")

opts = True
opts@MainTitle = ""
opts@InitTime = False
opts@Footer = False
opts@tiMainOn  = False
opts@lbTitleOn = False
opts@FieldTitle =""

res = opts
res@cnFillOn = True
res@gsnSpreadColors = True

contour = wrf_contour(a,wks,hgt,res)

pltres = True
pltres@NoTitles = True
mpres = True
mpres@mpGeophysicalLineColor      = "Black" 
mpres@mpGridLineColor             = "Black"

end
