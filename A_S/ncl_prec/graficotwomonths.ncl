load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
f1 = addfile("dataout/TQ0299L064/natal/natal_final_completo/GPOSPRECMEDIA24Z2013JAN01.fct.TQ0299L064.nc","r")
f2 = addfile("dataout/TQ0299L064/natal/natal_final_completo/GPOSPRECMEDIA24Z2013FEB01.fct.TQ0299L064.nc","r")
f3 = addfile("dataout/TQ0299L064/merge_completo/merge_24z_JAN2013.nc","r")
f4 = addfile("dataout/TQ0299L064/merge_completo/merge_24z_FEB2013.nc","r")
f5 = addfile("dataout/TQ0299L064/gfs_completo/GPOSPRECMEDIA24Z2013JAN01.fct.TQ0299L064.nc","r")
f6 = addfile("dataout/TQ0299L064/gfs_completo/GPOSPRECMEDIA24Z2013FEB01.fct.TQ0299L064.nc","r")

;prec= new((/4,dimsizes(f1->prec&time)/),float)
;grafico = new((/2,5/),float)


lineone = mask(f1->prec,f1->lsmk,-1)
linetwo = mask(f2->prec,f2->lsmk,-1)
linethree = mask(f3->prec,f1->lsmk,-1)
linefour = mask(f4->prec,f2->lsmk,-1)
linefive = mask(f5->prec,f1->lsmk,-1)
linesix = mask(f6->prec,f2->lsmk,-1)

copy_VarCoords(f1->lsmk,lineone)
copy_VarCoords(f2->lsmk,linetwo)
copy_VarCoords(f1->lsmk,linethree)
copy_VarCoords(f2->lsmk,linefour)
copy_VarCoords(f1->lsmk,linefive)
copy_VarCoords(f2->lsmk,linesix)

grafico = new((/3,dimsizes(f1->prec&time)+dimsizes(f2->prec&time)/),float)
prec = wgt_areaave(lineone(:,{-14:-2},{-45:-35}),1.0,1.0,0)
prectwo = wgt_areaave(linetwo(:,{-14:-2},{-45:-35}),1.0,1.0,0)
precthree = wgt_areaave(linethree(:,{-14:-2},{-45:-35}),1.0,1.0,0)
precfour = wgt_areaave(linefour(:,{-14:-2},{-45:-35}),1.0,1.0,0)
precfive = wgt_areaave(linefive(:,{-14:-2},{-45:-35}),1.0,1.0,0)
precsix = wgt_areaave(linesix(:,{-14:-2},{-45:-35}),1.0,1.0,0)
;printVarSummary(grafico)
wks = gsn_open_wks("png","ex09")
j=dimsizes(f1->prec&time)
if(dimsizes(f1->prec&time) .lt. dimsizes(f2->prec&time))then
   maxx = dimsizes(f2->prec&time);
else
   maxx = dimsizes(f1->prec&time)
end if
x = ispan(1,(dimsizes(f1->prec&time)+dimsizes(f2->prec&time))+1,1)
;x = ispan(1,60,1)
do i=0,maxx - 1
  if(i .le. dimsizes(f1->prec&time) - 1) then
     grafico(0,i) = prec(i)
     grafico(1,i) = precthree(i)
     grafico(2,i) = precfive(i)
     print("i =" +i)
     ;print(prec(i))
  end if
 
  if(j .le. (dimsizes(f1->prec&time)+dimsizes(f2->prec&time)) - 1)then
     grafico(0,j) = prectwo(i)
     grafico(1,j) = precfour(i)
     grafico(2,j) = precsix(i)
     ;print(prectwo(i))
     print("j =" +j)
     j = j + 1
  end if
end do

;do i=0,dimsizes(f1->prec&time) - 1
; grafico(i) = prec(i)
;end do
;j=dimsizes(f1->prec&time)
;do i=0,dimsizes(f2->prec&time) - 1
; grafico(j) = prectwo(i)
; j=j+1
;end do
print(grafico)
res          = True
res@gsnDraw  = True                          ; don't draw
res@gsnFrame = True                          ; don't advance frame
res@trYMinF  = 0
res@trYMaxF  = 35
res@tmXBMode     = "Explicit"  			; explicitly set Y-axis labels
res@tmXBValues   = (/0,10,20,30,40,50,60/)
res@tmXBLabels   = (/"31DEZ","10JAN","20JAN","30JAN","09FEB","19FEB","01MAR"/)
res@tmXBMinorValues = ispan(1,61,1)
res@tmXBLabelFontHeightF = 0.01
res@vpHeightF= 0.3                    ; change aspect ratio of plot
res@vpWidthF = 0.9  
res@vpXF            = 0.05	; set left hand side start point of plot
res@vpYF             = 0.7
;res@tmXBMajorOutwardLengthF = 0.021	; set tickmarks 
;res@tmXBMinorOutwardLengthF = 0.015
res@xyLineColors      = (/"blue","black","red","green"/)
res@xyDashPatterns     = (/0,0,0,16/)



plot = gsn_csm_xy (wks,x,grafico,res)
end