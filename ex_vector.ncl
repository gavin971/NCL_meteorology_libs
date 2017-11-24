begin
  fu = addfile("./data/u850-197901-201412.nc","r")
  fv = addfile("./data/v850-197901-201412.nc","r")

  u = short2flt(fu->uwnd(0,{850},:,:)) ; ����ȡ��0��ʱ��      
  v = short2flt(fv->vwnd(0,{850},:,:))

  wks = gsn_open_wks("eps","vector_ex") 

  res                      = True          ; Plot options desired.
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  
  res@pmTickMarkDisplayMode = "Always" 
  
  res@vcGlyphStyle         = "FillArrow" ;  "CurlyVector" , "WindBarb"   

  ;; ��ͷͷ����Сһ�¡���Ҫ����ͷ����С��һ�¼�ͷ�ɲο���4��ʾ����
  res@vcFillArrowMinFracWidthF = 1.0 
  res@vcFillArrowHeadMinFracXF = 1.0  
  res@vcFillArrowHeadMinFracYF = 1.0 
  
  ;; �ο���ͷ
  res@vcRefAnnoOn               = True  
  res@vcRefMagnitudeF           = 20      ;��׼���ȼ�ͷ����ʾ�Ĵ�С
  res@vcRefLengthF              = 0.04   ;��׼���ȼ�ͷ��ͼ���еĳ���
  res@vcRefAnnoBackgroundColor  = "white" ;������ɫ     
  res@vcRefAnnoPerimOn          = False   ;�رձ߿�   
  res@vcRefAnnoFontHeightF      = 0.015   ;�ο���ͷ��ǩ�����С      
  res@vcRefAnnoString1On        = False   ;�趨�ο���ͷ�ϡ�        
  res@vcRefAnnoString2On        = True    ;        �µ��ַ�
  res@vcRefAnnoString2          = "20 m/s"  
  
  plot  = gsn_csm_vector_map(wks,u,v,res)
end