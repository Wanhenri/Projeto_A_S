load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
hours=48
months="FEB"
f1 = addfile("dataout/TQ0299L064/ano_novo/crd_humo00_crdcld01_grepartwo3_ent4_completo/GPOSPRECMEDIA"+hours+"Z2013"+months+"01.fct.TQ0299L064.nc","r")
f2 = addfile("dataout/TQ0299L064/gfs_completo/GPOSPRECMEDIA"+hours+"Z2013"+months+"01.fct.TQ0299L064.nc","r")
f3 = addfile("dataout/TQ0299L064/merge/merge_completo_"+months+"2013.nc","r")
f4 = addfile("dataout/TQ0299L064/ano_novo/crd_humo00_crdcld01_grepartwo3_ent4_completo/GPOSPRECMEDIA"+hours+"Z2013"+months+"01.fct.TQ0299L064.nc","r")
;f4 = addfile("/stornext/home/saulo.magnum/ncl_prec/dataout/ibis/GPOSPRECMEDIA24Z2013JAN02.fct.TQ0299L064.nc","r")


prec= new((/4,dimsizes(f1->prec&time)/),float)
rmse= new((/4,10/),float)

;lineone = mask(f1->prec,f1->lsmk,-1)
;linetwo = mask(f2->prec,f1->lsmk,-1)
;;linethree = doubletofloat(mask(f4->prec,f1->lsmk,-1))
;linethree = mask(f3->prec,f1->lsmk,-1)
;linefour = mask(f4->prec,f1->lsmk,-1)


lineone = f1->prec
linetwo = f2->prec
;linethree = doubletofloat(mask(f4->prec,f1->lsmk,-1))
linethree = f3->prec
linefour = f4->prec


copy_VarCoords(f1->lsmk,lineone)
copy_VarCoords(f1->lsmk,linetwo)
copy_VarCoords(f1->lsmk,linethree)
copy_VarCoords(f1->lsmk,linefour)

x = ispan(1,30,1)
wks = gsn_open_wks("png","ex09")
plot = new (10,graphic) ; numero de graficos

;prec =  wgt_areaave(mk(:,{-14:-2},{-75:-65}),1.0,1.0,0)
res          = True
res@gsnDraw  = False                          ; don't draw
res@gsnFrame = False                          ; don't advance frame
res@trYMinF  = 0
res@trYMaxF  = 35

;res@tmYLMode   = "Explicit"  			; explicitly set Y-axis labels
;res@tmYLValues = (/"5","10","20","30","35"/)
;res@tmYLLabels = (/"5","10","20","30","35"/)

res@gsnLeftString = "  "
res@gsnCenterString = "  "
res@gsnRightString = "  "
;res@tmBorderThicknessF = 4.0
res@xyLineThicknessF = 3.0 ; line
res@xyLineColors      = (/"blue","red","black","green"/)          ; change line color
;res@xyMonoDashPattern      = True       ; make all lines are solid

;res@xyDashPattern = 0               ; Make curves all solid
res@xyDashPatterns     = (/0,0,0,16/)



lon0 = -75.0
lon1 = -65.0
lat0 = -14.0
lat1 = -2.0
do i=0,9
    if(i .eq. 4)then
       lat0 = -20
    end if
    prec(0,:) =  wgt_areaave(lineone(:,{lat0:lat1},{lon0:lon1}),1.0,1.0,0)
    prec(1,:) =  wgt_areaave(linetwo(:,{lat0:lat1},{lon0:lon1}),1.0,1.0,0)
    prec(2,:) =  wgt_areaave(linethree(:,{lat0:lat1},{lon0:lon1}),1.0,1.0,0)
    prec(3,:) =  wgt_areaave(linefour(:,{lat0:lat1},{lon0:lon1}),1.0,1.0,0)
    plot(i)  = gsn_csm_xy (wks,x,prec,res) ; create plot
    
    rmse(0,i) = dim_rmsd_Wrap(prec(0,:),prec(2,:))
    rmse(1,i) = dim_rmsd_Wrap(prec(1,:),prec(2,:))
    rmse(2,i) = dim_rmsd_Wrap(prec(3,:),prec(2,:))
;    print(rmse(0,i))
    
    print("lon0="+lon0+" lon1="+lon1+" lat0 ="+lat0+" lat1="+lat1)
    if(i .eq. 4)then
       lat0 = -26
    end if
    lon0 = lon0 + 10
    lon1 = lon1 + 10
    if(i .eq. 3)then
       lon0 = -75.0
       lon1 = -65.0
       lat0 = lat0 - 12
       lat1 = lat1 - 12
    end if
    if(i .eq. 7)then
       lon0 = -67.5
       lon1 = -57.5
       lat0 = lat0 - 12
       lat1 = lat1 - 12
    end if
end do


;******************************
;Table
;******************************
 ncr3  = (/4,11/)              ; 16 rows, 3 columns
 x3    = (/0.52,0.995/)       ; Start and end X
 y3    = (/0.16,0.320/)       ; Start and end Y
 text3 = (/ (/"  ","A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10"/), \
         (/"GFS", ""+sprintf("%5.2f", rmse(1,0)), ""+sprintf("%5.2f", rmse(1,1)),""+sprintf("%5.2f", rmse(1,2)), ""+sprintf("%5.2f", rmse(1,3)),""+sprintf("%5.2f",rmse(1,4)),""+sprintf("%5.2f",rmse(1,5)),""+sprintf("%5.2f",rmse(1,6)),""+sprintf("%5.2f", rmse(1,7)),""+sprintf("%5.2f", rmse(1,8)),""+sprintf("%5.2f", rmse(1,9))/), \
	 (/"M1", ""+sprintf("%5.2f", rmse(0,0)), ""+sprintf("%5.2f", rmse(0,1)),""+sprintf("%5.2f", rmse(0,2)), ""+sprintf("%5.2f", rmse(0,3)),""+sprintf("%5.2f", rmse(0,4)),""+sprintf("%5.2f",rmse(0,5)),""+sprintf("%5.2f",rmse(0,6)),""+sprintf("%5.2f", rmse(0,7)),""+sprintf("%5.2f", rmse(0,8)),""+sprintf("%5.2f", rmse(0,9))/), \
         (/"M2", ""+sprintf("%5.2f", rmse(2,0)), ""+sprintf("%5.2f", rmse(2,1)),""+sprintf("%5.2f", rmse(2,2)), ""+sprintf("%5.2f", rmse(2,3)),""+sprintf("%5.2f",rmse(2,4)),""+sprintf("%5.2f",rmse(2,5)),""+sprintf("%5.2f",rmse(2,6)),""+sprintf("%5.2f", rmse(2,7)),""+sprintf("%5.2f", rmse(2,8)),""+sprintf("%5.2f", rmse(2,9))/)/)

 table = True             ; Set up resource list

;  table@gsnDebug = True     ; Useful to print NDC row,col values used.

  table@txFontHeightF = 0.008

;  table@gsFillColor = (/ (/"gray","transparent","palegreen"/), \
;                       (/"gray","transparent","hotpink"/)/)	

  table@txFontColor = (/ (/"","black", "black", "black", "black", "black", "black", "black", "black", "black", "black"/), \
     	              (/"red", "red", "red", "red", "red", "red", "red", "red", "red", "red", "red"/),\
		      (/"blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue"/), \
                      (/"green", "green","green", "green", "green", "green", "green", "green", "green", "green", "green"/)/)		       

gsn_table(wks,ncr3,x3,y3,text3,table)		       

;******************************
;End Table
;******************************

;******************************
; legend resources
;******************************
  lgres                    = True
;  lgres@lgLineColors     = (/"foreground","blue"/)
  lgres@lgLineColors     = "black"
  lgres@lgLineThicknessF   = 3.0  ; legend line thickness = contour line thickness
  lgres@lgItemType         = "Lines"        ; show lines only (default)
  lgres@lgLabelFontHeightF = 0.08            ; set the legend label font thickness
  lgres@vpWidthF           = 0.14           ; width of legend (NDC)
  lgres@vpHeightF          = 0.01            ; height of legend (NDC)
  lgres@lgPerimColor       = "orange"       ; draw the box perimeter in orange
  lgres@lgPerimThicknessF  = 1.0            ; thicken the box perimeter


  
  lgres@lgPerimOn          = False
  
;  gsn_legend_ndc(wks,2,(/"time=0","time=4"/),0.6,0.15,lgres)
  gsn_legend_ndc(wks,1,"MER",0.0,0.08,lgres)
  lgres@lgLineColors     = "red"
  gsn_legend_ndc(wks,1,"GFS",0.2,0.08,lgres)
  lgres@lgLineColors     = "blue"
  gsn_legend_ndc(wks,1,"M1",0.42,0.08,lgres)
  lgres@lgMonoDashIndex= True
  lgres@lgDashIndex  = 16
  lgres@lgLineColors     = "green"
  gsn_legend_ndc(wks,1,"M2",0.64,0.08,lgres)



;******************************
;end legend
;******************************

;******************************
; TEXT
;******************************
 txres               = True
 txres@txFontHeightF = 0.010
 txres@txFontColor = 1
 gsn_text_ndc(wks,"RMSE",0.73,0.33,txres) 
 txres@txFontColor = 1
 txres@txAngleF = 90.0
 gsn_text_ndc(wks,"MODELO",0.51,0.25,txres) 
  txres@txAngleF = 0.0
 gsn_text_ndc(wks,"",0.5,0.02,txres) 
 
;******************************
;End Text
;******************************

;******************************
;Panel
;******************************
resP = True
;resP@txString = "MORRISON grepar = 19 crdcld = 06 wgfs ("+months+" - 2013)"
resP@txString = "HUMO 72Z ("+months+" - 2013)"
resP@lbLabelFontHeightF = 1.007
resP@gsnPanelFigureStrings = (/"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10"/)
resP@gsnPanelFigureStringsBackgroundFillColor = 0
resP@gsnPanelFigureStringsPerimOn = False
resP@amJust   = "TopLeft"
;resP@gsnPanelTop = 1.0
;resP@gsnPanelBottom = 0.2
;resP@gsnPanelLeft = 0.01
;resP@gsnPanelRight = 0.5
resP@gsnPanelCenter  = False

gsn_panel(wks,plot,(/3,4/),resP)             ; now draw as one plot

;******************************
;End Panel
;******************************

;plot = gsn_csm_contour_map_ce(wks,prec(0,:,:), res)
;plot  = gsn_csm_xy (wks,x,prec,res) ; create plot


end
