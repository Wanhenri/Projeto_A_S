load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin

f1 = addfile("JAN2012.nc","r")
f2 = addfile("FEB2012.nc","r")
f3 = addfile("JAN2013.nc","r")
f4 = addfile("FEB2013.nc","r")
;f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TQ0299L064/morrison19_crdcld01_wgfs/2013010112/GPOSNMC20130101122013010118P.fct.TQ0299L064.grb","r")
;print(f1)
;teste = (/3,5,10/)
;av = dim_avg(teste)
;a = 2
;print(""+a)
precOne = f1->prec
precTwo = f2->prec
precThree = f3->prec
precFour = f4->prec
soma = (precOne + precTwo + precThree + precFour)/4
copy_VarCoords(precOne,soma)
wks = gsn_open_wks("png","ex09")

gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200");use the BlWhRe colormap (instead of default colormap)
plot = new (3,graphic) ; numero de graficos

res          = True
res@gsnDraw  = False                          ; don't draw
res@gsnFrame = False                          ; don't advance frame
res@cnInfoLabelOn = False                     ; turn off cn info label
res@cnFillOn =  True
res@lbLabelBarOn =  False
res@cnLineLabelsOn = False
res@gsnLeftString = "   "
res@gsnCenterString = "   "
res@gsnRightString = "   "
res@mpMinLatF            =  -60. 
res@mpMaxLatF            =  60.
res@mpMinLonF            =  0. 
res@mpMaxLonF            =  360.
res@mpCenterLonF = (res@mpMinLonF + res@mpMaxLonF)/2
res@cnLevelSelectionMode = "ExplicitLevels" ; set explicit contour levels
res@cnLevels=(/ 3,4,6,8,10,12,14,20,30/)	; set levels
res@cnFillColors = (/ 0,60,68,79,90,111,127,143,159,175,191/)	; set the colors to be used
res@tiYAxisString = "24z"
res@tiYAxisAngleF = 0.0
res@tiYAxisOffsetXF = -0.05
res@cnLineThicknessF = 0.0
 

;plot = gsn_csm_contour_map_ce(wks,prec(0,:,:),False)

plot(0) = gsn_csm_contour_map_ce(wks,soma(0,:,:), res)
res@tiYAxisString = "48z"
plot(1) = gsn_csm_contour_map_ce(wks,soma(1,:,:), res)
res@tiYAxisString = "72z"
plot(2) = gsn_csm_contour_map_ce(wks,soma(2,:,:), res)


resP = True
resP@txString = "Media Verao 2012/2013"
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
