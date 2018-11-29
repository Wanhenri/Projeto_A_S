;*************************************************
; text_add_1.ncl
;
; Concepts illustrated:
;   - Adding text to a plot using plot data coordinates
;   - Decreasing the font size of text
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
;************************************************
; read in netCDF file
;************************************************
  a = addfile("saida.nc","r")
  u = a->prec(0,:,:)
;************************************************
; create plot
;************************************************
  wks = gsn_open_wks("x11","text")   

  res                 = True                     ; plot mods desired
  res@gsnFrame        = False                    ; don't advance frame yet
  res@gsnDraw         = False                    ; don't draw plot

  plot=gsn_csm_xy(wks,u&lat,u,res)               ; Create xy plot.

;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.03                     ; font smaller. default big

  dum = gsn_add_text(wks,plot,"Text in Plot Coordinates",50,50.0,txres) 
  draw(plot)
  frame(wks)                                     ; now advance frame

end