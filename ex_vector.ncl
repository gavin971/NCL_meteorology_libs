begin
  fu = addfile("./data/u850-197901-201412.nc","r")
  fv = addfile("./data/v850-197901-201412.nc","r")

  u = short2flt(fu->uwnd(0,{850},:,:)) ; 仅挑取第0个时次      
  v = short2flt(fv->vwnd(0,{850},:,:))

  wks = gsn_open_wks("eps","vector_ex") 

  res                      = True          ; Plot options desired.
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  
  res@pmTickMarkDisplayMode = "Always" 
  
  res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   

  ;; 箭头头部大小一致。若要绘制头部大小不一致箭头可参考第4章示例。
  res@vcFillArrowMinFracWidthF = 1.0 
  res@vcFillArrowHeadMinFracXF = 1.0  
  res@vcFillArrowHeadMinFracYF = 1.0 
  
  ;; 参考箭头
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 20      ;标准长度箭头所表示的大小
  res@vcRefLengthF              = 0.04   ;标准长度箭头在图形中的长度
  res@vcRefAnnoBackgroundColor  = "white" ;背景颜色     
  res@vcRefAnnoPerimOn          = False   ;关闭边框   
  res@vcRefAnnoFontHeightF      = 0.015   ;参考箭头标签字体大小      
  res@vcRefAnnoString1On        = False   ;设定参考箭头上、        
  res@vcRefAnnoString2On        = True    ;        下的字符
  res@vcRefAnnoString2          = "20 m/s"  
  
  plot  = gsn_csm_vector_map(wks,u,v,res)
end