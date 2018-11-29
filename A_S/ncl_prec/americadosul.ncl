load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
f1 = addfile("old_amersul.nc","r")
prec = f1->prec
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
res@mpMinLatF            =  -50.2 
res@mpMaxLatF            =  12.2
res@mpMinLonF            =  277.2
res@mpMaxLonF            =  326.
res@gsnAddCyclic = False 
res@cnLevelSelectionMode = "ExplicitLevels" ; set explicit contour levels
res@cnLevels=(/2,3,5,7,9,12,15,20,25,30,50,70,90/)	; set levels
res@cnFillColors = (/0,36,40,44,63,68,73,77,84,95,122,130,138,152,185/)	; set the colors to be used
res@tiMainString = "OLD 12Z 08/11/2013 PREVISAO"
plot = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)


end
