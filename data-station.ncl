begin 
  nstat = 160 ; 160站
  year_s = 1951 
  year_e = 2011 
  nyear  = year_e - year_s + 1
  
  ; (1) 读入6/7/8三个月的降水
  path6 = "./data/r1606.TXT"
  path7 = "./data/r1607.TXT"  
  path8 = "./data/r1608.TXT" 

  
  ; 设定meta data
  m6!0 = "year"
  m6!1 = "stations"
  m6&year = ispan(year_s,year_e,1)
  m6&stations = ispan(1,nstat,1)
  
  m7 = m6  ; 创建新的变量
  m8 = m6  


  
  ;(2) 仅计算1979年至2008年逐年的JJA平均
  mm = m6({1979:2008},:) ; 创建新的变量
  mm = m6({1979:2008},:) + m7({1979:2008},:) + m8({1979:2008},:)
  
  ;(3) 输出为无格式二进制文件
  
  ;(4) 输出为ASCII文件

  
end 
 
 
