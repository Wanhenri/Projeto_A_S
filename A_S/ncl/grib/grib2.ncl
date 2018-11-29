begin 
;***************************************************
; Open GRIB file and get variable names
;***************************************************
   grib_in= addfile("/stornext/home/saulo.magnum/online8/dados/pos/dataout/TQ0299L064/2012010212/GPOSNMC20120102122012010912P.fct.TQ0299L064.grb","r")
   names  = getfilevarnames(grib_in)   ; extract ALL variable names
;***************************************************
; open output netcdf file
;***************************************************
   system("/stornext/home/saulo.magnum/rm select.nc") ; remove any pre-exist file 
   netcdf_out = addfile("/stornext/home/saulo.magnum/select.nc","c")   
;***************************************************
; specify desired GRIB variables 
;***************************************************
   ;grib_names = (/ "gridlat_6", "gridlon_6", "PRES_6_SFC","PRMSL_6_MSL",\
   ;"HGT_6_SFC", "TMP_6_TRO","TMP_6_ISBL"/)
  
   ;ncl_names  = (/ "lat6", "lon6", "PS","SLP","HSFC","TTRO","T"/)
   grib_names = (/ "ZGEO_GDS4_ISBL","TEMP_GDS4_ISBL"/)
   ncl_names  = (/ "zgeo", "temp"/)
   
;***************************************************
; loop over selected variables and rename on output
;***************************************************
   do i=0, dimsizes(ncl_names)-1  
    print(ncl_names(i))
    print(grib_in)
   ;ncdf_out->$ncl_names(i)$ = grib_in->$grib_names(i)$ 
   end do   
end 
