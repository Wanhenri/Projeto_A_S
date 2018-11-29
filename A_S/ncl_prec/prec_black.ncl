load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin

f1 = addfile("lsc_JAN2013.nc","r")
;f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TQ0299L064/morrison19_crdcld01_wgfs/2013010112/GPOSNMC20130101122013010118P.fct.TQ0299L064.grb","r")
;print(f1)
;teste = (/3,5,10/)
;av = dim_avg(teste)
;a = 2
;print(""+a)
prec = f1->prec
wks = gsn_open_wks("png","ex09")

gsn_define_colormap(wks,"wxpEnIR");use the BlWhRe colormap (instead of default colormap)
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
res@cnFillColors = (/ 0,70,71,72,74,82,83,84,85,86,87/)	; set the colors to be used
res@tiYAxisString = "24z"
res@tiYAxisAngleF = 0.0
res@tiYAxisOffsetXF = -0.05
res@cnLineThicknessF = 0.0
 

;plot = gsn_csm_contour_map_ce(wks,prec(0,:,:),False)
plot(0) = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)
res@tiYAxisString = "48z"
plot(1) = gsn_csm_contour_map_ce(wks,prec(1,:,:), res)
res@tiYAxisString = "72z"
plot(2) = gsn_csm_contour_map_ce(wks,prec(2,:,:), res)

resP = True
resP@txString = "Lsc grepar = 19 crdcld = 01 wgfs new (JAN - 2013)"
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