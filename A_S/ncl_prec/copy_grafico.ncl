load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
f1 = addfile("dataout/operacional/GPOSPRECMEDIA24Z2013JAN02.fct.TQ0299L064.nc","r")
f2 = addfile("dataout/operacional/GPOSPRECMEDIA24Z2013JAN02.fct.TQ0299L064.nc","r")

data      = new((/2,dimsizes(f1->prec&time)/),float)




mk = mask(f1->prec,f1->lsmk,-1)
copy_VarCoords(f1->lsmk,mk)

x = ispan(1,30,1)
wks = gsn_open_wks("png","ex09")
plot = new (10,graphic) ; numero de graficos
;prec = dim_avg_n(mk,(/1,2/))

;prec =  wgt_areaave(mk(:,{-14:-2},{-75:-65}),1.0,1.0,0)
res          = True
res@gsnDraw  = False                          ; don't draw
res@gsnFrame = False                          ; don't advance frame
res@trYMaxF  = 35

res@gsnLeftString = "  "
res@gsnCenterString = "  "
res@gsnRightString = "  "
;res@tmBorderThicknessF = 4.0
;res@xyLineThicknessF = 3.0 ; line



do i=0,9
    prec =  wgt_areaave(mk(:,{-14:-2},{-75:-65}),1.0,1.0,0) 
    plot(i)  = gsn_csm_xy (wks,x,prec,res) ; create plot
end do

resP = True
resP@txString = "UKM grepar = 19 crdcld = 01 wgfs new (JAN - 2013)"
resP@lbLabelFontHeightF = 1.007
;resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
resP@gsnPanelFigureStringsBackgroundFillColor = 2
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust   = "TopLeft"
;resP@gsnPanelTop = 1.0
;resP@gsnPanelBottom = 0.2
;resP@gsnPanelLeft = 0.01
;resP@gsnPanelRight = 0.5
resP@gsnPanelCenter  = False


;delete(res@cnInfoLabelOn)
;***********************************************
; legend resources
;***********************************************
  lgres                    = True
  lgres@lgLineColors     = (/"foreground","blue"/)
  lgres@lgLineThicknessF   = 1.0  ; legend line thickness = contour line thickness
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = .08            ; set the legend label font thickness
  lgres@vpWidthF           = 0.15           ; width of legend (NDC)
  lgres@vpHeightF          = 0.1            ; height of legend (NDC)
  lgres@lgPerimColor       = "orange"       ; draw the box perimeter in orange
  lgres@lgPerimThicknessF  = 5.0            ; thicken the box perimeter


  gsn_legend_ndc(wks,2,(/"time=0","time=4"/),0.6,0.15,lgres)


txres               = True
txres@txFontHeightF = 0.010
txres@txFontColor = 2
gsn_text_ndc(wks,"Testeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",0.3,0.06,txres) 
txres@txFontColor = 3
gsn_text_ndc(wks,"Teste",0.1,0.04,txres) 
gsn_text_ndc(wks,"Teste3",0.5,0.02,txres) 

  gsn_panel(wks,plot,(/3,4/),resP)             ; now draw as one plot



;plot = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)
;plot  = gsn_csm_xy (wks,x,prec,res) ; create plot


end
