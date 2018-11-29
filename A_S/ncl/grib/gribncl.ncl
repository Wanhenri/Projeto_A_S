
begin
;***********************************************
; get variable names from grib file
;***********************************************
  do i=0,1
    if(i .eq. 0)then
      grib_in  = addfile("/stornext/home/saulo.magnum/online8/dados/pos/dataout/TQ0299L064/2012010200/GPOSNMC20120102002012010900P.fct.TQ0299L064.grb","r")   
      names    = getfilevarnames(grib_in); extract all variable names 
    else
      grib_in  = addfile("/stornext/home/saulo.magnum/online8/dados/pos/dataout/TQ0299L064/2012010212/GPOSNMC20120102122012010912P.fct.TQ0299L064.grb","r")   
      names    = getfilevarnames(grib_in); extract all variable names 
    end if
    ;print (grib_in)
  end do 
   all_files_fct = systemfunc("ls /stornext/home/saulo.magnum/online8/dados/pos/dataout/TQ0299L064/*20120110*/GPOSNMC*2012011012*.fct.TQ0299L064.grb")
   grib_fct  = addfiles(all_files_fct,"r")   
   
   ListSetType(grib_fct,"cat")
   T= grib_fct[:]->T
   print(T)
;***********************************************
; create output netcdf file
;*********************************************** 
   ;system("rm out.nc") ; remove any pre-existing file
   ;ncdf_out = addfile("out.nc" ,"c")       ; create output netCDF file
;***********************************************
; loop through variables and output each to netcdf
;***********************************************
   ;t = grib_in->ZGEO_GDS4_ISBL(5,449,10:100)
   ;t = grib_in->ZGEO_GDS4_ISBL
   ;print(t)
   ;print (t)
   ;do i = 0, dimsizes(names)-1  
  ; print($names(i)$)
  ; print(grib_in)
   
   ;ncdf_out->$names(i)$ = grib_in->$names(i)$
   ;end do   
end 
