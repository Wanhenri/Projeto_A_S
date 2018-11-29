load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin
i=2011
f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TRMM3B43A/3B43.19980101.7A.nc","r")
prec = f1->pcp * 0
copy_VarCoords(f1->pcp,prec)
do while(i.le.2011)
f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TRMM3B43A/3B43.19980101.7A.nc","r")
f2 = addfile("/stornext/home/saulo.magnum/online8/dados/TRMM3B43A/3B43.19980101.7A.nc","r")
f3 = addfile("/stornext/home/saulo.magnum/online8/dados/TRMM3B43A/3B43.19980101.7A.nc","r")

prec = prec + ((f1->pcp + f2->pcp + f3->pcp)/3) * 24
copy_VarCoords(f1->pcp,prec)
i=i+1
end do

;f1 = addfile("/stornext/home/saulo.magnum/online8/dados/TRMM3B43/3B43.20130101.7.nc","r")
;prec = f1->pcp 
;copy_VarCoords(f1->pcp,prec)

wks = gsn_open_wks("png","ex09")
  
gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200");use the BlWhRe colormap (instead of default colormap)
res          = True

res@gsnDraw  = True                          ; don't draw
res@gsnFrame = True                          ; don't advance frame
res@cnInfoLabelOn = False                     ; turn off cn info label
res@cnFillOn =  True
res@lbLabelBarOn =  True
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
res@cnLevels=(/3,5,7,9,12,15,18,22,28/)	; set levels
res@cnFillColors = (/0,44,63,73,84,95,122,130,138,152,185/)	; set the colors to be used
;res@tiYAxisString = "24z"
res@tiYAxisAngleF = 0.0
res@tiYAxisOffsetXF = -0.05
;res@tiMainString = "PRECIPITACAO TRMM 3B43.7 (Media mensal JAN - 2013)"
res@tiMainString = "MEDIA PRECIPITACAO DEC/JAN/FEB 2013 TRMM 3B43.7"
res@tiMainFontHeightF =  0.025
res@mpFillPatternBackground = 10
res@gsnMajorLatSpacing = 10              ; change maj lat tm spacing

plot = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)
       


end