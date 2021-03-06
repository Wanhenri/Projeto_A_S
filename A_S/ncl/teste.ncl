; ***********************************************
; xy_1.ncl
;
; Concepts illustrated:
;   - Drawing a black-and-white XY plot
;
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
;************************************************
; read in data
;************************************************
; f     = addfile ("$NCARG_ROOT/lib/ncarg/data/cdf/uv300.nc","r")
; u     = f->U                                    ; get u data
;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("ps","xy")                ; open workstation

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Basic XY plot"          ; add title

 plot  = gsn_csm_xy (wks,u&lat,u(0,:,{82}),res) ; create plot
end
