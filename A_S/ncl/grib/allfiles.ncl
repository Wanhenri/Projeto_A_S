;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
begin                           
 fils = systemfunc ("ls /stornext/home/saulo.magnum/online8/dados/pos/dataout/TQ0299L064/*20120110*/GPOSNMC*2012011012*.fct.TQ0299L064.grb")
 f    = addfiles (fils, "r")              ; note the "s" of addfile
 ;T    = addfiles_GetVar (f, fils, "T")
 T = f[:]->T
 printVarSummary(T)
end 
