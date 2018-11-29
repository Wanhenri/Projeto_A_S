load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin

f1 = addfile("crd_humo00_crdcld01_grepartwo3_new00_en0.25_DEC2012.nc","r")
f2 = addfile("crd_humo00_crdcld01_grepartwo3_new00_en0.25_JAN2013.nc","r")
f3 = addfile("crd_humo00_crdcld01_grepartwo3_new00_en0.25_FEB2013.nc","r")
;f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TQ0299L064/morrison19_crdcld01_wgfs/2013010112/GPOSNMC20130101122013010118P.fct.TQ0299L064.grb","r")
;print(f1)
;teste = (/3,5,10/)
;av = dim_avg(teste)
;a = 2
;print(""+a)
;prec = f1->prec 
prec = (f1->prec + f2->prec + f3->prec)/3
copy_VarCoords(f1->prec,prec)
wks = gsn_open_wks("png","ex09")

;gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200");use the BlWhRe colormap (instead of default colormap)
gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200");use the BlWhRe colormap (instead of default colormap)
plot = new (3,graphic) ; numero de graficos

res          = True
res@gsnDraw  = False                          ; don't draw
res@gsnFrame = False                          ; don't advance frame
res@cnInfoLabelOn = False                     ; turn off cn info label
res@cnFillOn =  True
res@lbLabelBarOn =  False
res@cnLineLabelsOn = False
res@cnLinesOn            = False              ; turn off contour lines
res@gsnLeftString = "   "
res@gsnCenterString = "   "
res@gsnRightString = "   "
res@mpMinLatF            =  -50. 
res@mpMaxLatF            =  50.
res@mpMinLonF            =  0. 
res@mpMaxLonF            =  360.
res@mpCenterLonF = (res@mpMinLonF + res@mpMaxLonF)/2
res@cnLevelSelectionMode = "ExplicitLevels" ; set explicit contour levels
;res@cnLevels=(/ 3,4,6,8,10,12,14,20,30/)	; set levels
res@cnLevels=(/3,5,7,9,12,15,18,22,28/)	; set levels
;res@cnFillColors = (/ 0,60,68,79,90,111,127,143,159,175,191/)	; set the colors to be used
res@cnFillColors = (/0,44,63,73,84,95,122,130,138,152,185/)	; set the colors to be used
;res@cnFillColors = (/0,44,63,84,95,122,135,144,152,185/)	; set the colors to be used
res@tiYAxisString = "24z"
res@tiYAxisAngleF = 0.0
res@tiYAxisOffsetXF = -0.05
res@tmYLMode   = "Explicit"  			; explicitly set Y-axis labels
;res@tmYLValues = (/"-50","-40","-30","-20","-10","0","10","20","30","40","50"/)
;res@tmYLLabels = (/"50S","40S","30S","20S","10S","0","10N","20N","30N","40N","50N"/)
res@gsnMajorLatSpacing = 10              ; change maj lat tm spacing
;res@gsnMajorLonSpacing = 50              ; change maj lon tm spacing

res@cnLineThicknessF = 0.0
setvalues NhlGetWorkspaceObjectId()
   "wsMaximumSize":10000000000
end setvalues 

;plot = gsn_csm_contour_map_ce(wks,prec(0,:,:),False)
plot(0) = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)
res@tiYAxisString = "48z"
plot(1) = gsn_csm_contour_map_ce(wks,prec(1,:,:), res)
res@tiYAxisString = "72z"
plot(2) = gsn_csm_contour_map_ce(wks,prec(2,:,:), res)

resP = True
;resP@txString = "HUMO grep=00,grep2=3,grep3=0.75,ent=4 crd=01 wgfs (FEB - 2013)"
;resP@txString = "GFS (JAN - 2013)"
resP@txString = "VERAO (DEC/JAN/FEB - 2013)"
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.007
;resP@gsnPanelFigureStrings = (/"a)","b)","c)","d)"/)
resP@gsnPanelFigureStringsBackgroundFillColor = 2
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust   = "TopLeft"




delete(res@cnInfoLabelOn)
;************************************************
; create panel
;************************************************
  
  gsn_panel(wks,plot,(/3,1/),resP)             ; now draw as one plot





end