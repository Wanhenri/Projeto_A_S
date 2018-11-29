load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin
d = asciiread("tbias2412.txt",-1,"string")
;d = asciiread("t.txt",-1,"string")

;print("Valor de d = " + dimsizes(d))
;print(d)

wks = gsn_open_wks( "png", "xyPlot")
opcoes = True
opcoes@tiMainString = "BIAS - GEOPOTENCIAL 500hPa (12)"
opcoes@tiXAxisString = "Janeiro - 2012  / Media Mensal"
opcoes@tiYAxisString = "[k]"
opcoes@gsnMaximize = True
opcoes@vpWidthF         = 1.3                      ; set width and height
opcoes@vpHeightF        = 0.3

;---------------------------------------
;VARIAVEIS
;---------------------------------------
dados = new((/dimsizes(d)-1,62/),float)
leg = new(dimsizes(d)-1,string)
indices = new(14,integer)
contlinhas = 0
eixox = new(62,float)
in = 0
iz = 0
id = 1
aux = 0
ax = 0
;---------------------------------------
indices(:) = 0
;a=(/1,2,3,4/)
;b=(/3,2,3,2/)
;c= new((/3,4/),float)
;c(0,:) = (/0.25,0.17,0.25,0.36/)
;c(1,:) = (/0.35,0.27,0.15,0.36/)
;c(2,:) = (/0.45,0.37,0.45,0.36/)

do i=1,dimsizes(d)-1,1
 m=str_split(d(i)," ")
 do j=5,dimsizes(m)-1,1
   if(stringtofloat(m(j)) .ne. -999.9) then
      if(aux .eq. 0) then
        contlinhas = contlinhas + 1
	aux = aux + 1
      end if
   end if
 end do
 aux = 0
end do


do i=0,dimsizes(d)-1,1
  if(i .eq. 0) then
    m=str_split(d(0)," ")
    ;eixox = m(5:dimsizes(m)-1)
    ;print(eixox)
    do j=5,dimsizes(m)-1,1
       eixox(aux) = stringtofloat(m(j))
       aux = aux + 31
       eixox(aux) = stringtofloat(m(j)) + 0.5
       aux = aux + -30
    end do
    aux = 0
    print(eixox)
  else
    m=str_split(d(i)," ")
    do j=5,dimsizes(m)-1,1
       if(stringtofloat(m(j)) .ne. -999.9) then
	  
	  ;print("Valor do dados = "+dados(1,j-5))
	  if(m(0) .eq. "12")then
	     if(aux .eq. 0)then
	       dados(aux,j-5) = stringtofloat(m(j))
	       indices(aux) = 1
  	       leg(aux) = "old"
	       ;iz = iz + 2
	     else
	       dados(aux,(j-5)+31) = stringtofloat(m(j))
	       indices(aux) = 1
  	       leg(aux) = "new"
	     end if
	     
	  else
	     dados(aux,j-4) = stringtofloat(m(j))
	     indices(aux) = 1
  	     ;leg(aux+1) = m(4) + m(0)   
	  end if
	  
	  ax = 1
	end if
	 
    end do
    if(ax .eq. 1)then
       aux = aux + 1
       ax = 0
       iz = 0
    end if
  end if
  
end do

;c(0,:) = stringtoint(eixox) + 5
;c(1,:) = stringtoint(eixox) + 1

;cfiltro = 1
;do i=0,dimsizes(d)-1,1
;  if(dados(i,:) .eq. -999.9)then
;    cfiltro = cfiltro + 1
;  end if
;end do

;---------------------------------------------------------------
; Altera a cor da linha e adiciona marcadores!!!
;---------------------------------------------------------------
;opcoes@xyMarkLineMode = "MarkLines"    ; Markers *and* lines
;opcoes@xyMarkers      = (/6,11,16/)    ; 3 different markers
;opcoes@xyMarkerColors = (/"blue","red","green"/)  ; 3 different colors
opcoes@xyLineColors      = (/"blue","red","green"/)          ; change line color

;----------------------------------------------------------------

;---------------------------------------------------------------
; LEGENDA 1
;---------------------------------------------------------------
opcoes@pmLegendDisplayMode    = "Always"         ; Turn on a legend
opcoes@pmLegendOrthogonalPosF = -0.9            ; Move legend inside plot
opcoes@pmLegendParallelPosF   =  0.88             ; Move legend to right
opcoes@pmLegendWidthF         = 0.13             ; Change width and height
opcoes@pmLegendHeightF        = 0.1
opcoes@xyLabelMode            = "Custom"
;opcoes@xyExplicitLabels       = (/"24","48","72","96"/)  ; explicit labels
opcoes@xyExplicitLabels       = leg              ; explicit labels
opcoes@xyLineLabelFontHeightF = 0.015            ; font height
opcoes@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
opcoes@lgPerimFillColor       = "white"          ; so it masks XY curves
;---------------------------------------------------------------

;---------------------------------------------------------------
; LEGENDA 2
;---------------------------------------------------------------
;opcoes@xyExplicitLegendLabels = (/"24","48","72"/)
;opcoes@pmLegendDisplayMode    = "Always"   ; Display a legend.
;opcoes@pmLegendWidthF         = 0.2        ; Make it smaller
;opcoes@pmLegendHeightF        = 0.1        ; Make it smaller
;opcoes@pmLegendOrthogonalPosF = -0.38      ; Move into to plot
;opcoes@pmLegendParallelPosF   =  0.88      ; Move to right
;opcoes@lgPerimOn              = False      ; No legend perimeter.
;opcoes@lgLabelFontHeightF     = 0.01
;---------------------------------------------------------------


;---------------------------------------------------------------
; LEGENDA 3
;---------------------------------------------------------------
;---------------------------------------------------------------




;---------------------------------------------------------------
; EIXO XY
;---------------------------------------------------------------
opcoes@trYMinF = -55.5		; set minimum Y-axis value
;opcoes@trYMaxF =  2.0		; set maximum Y-axis value
;opcoes@trXMinF = 0		; set minimum X-axis value
;opcoes@trXMaxF = eixox(60)      ; set maximum X-axis value

opcoes@tmXBMode = "Manual"
opcoes@tmXBTickStartF = 0;eixox(0) 
opcoes@tmXBTickEndF = 180;dimsizes(eixox)-1
opcoes@tmXBTickSpacingF = 12
;
;print("Valor do cont = "+contlinhas)

if(contlinhas .gt. 1) then
 a = new((/contlinhas,62/),float)
 print("Passou aqui dentro")
end if
;print(dados)
do i=0,contlinhas,1
 
 if(indices(i) .eq. 1) then
   print(" Passou aqui indices ="+indices(i))
   if(contlinhas .eq. 1) then
      a = dados(i,:)
      ;print("Passou aqui" + a)
      ;print("Passou aqui leg" + leg)
   else
      a(in,:) = dados(i,:)
      ;print(dados(i,:))
      in = in + 1
   end if
 end if  
   
end do
;a(1,1)=2.0
print("Valor de a =" + a)
;plotXY = gsn_csm_y( wks, stringtoint(eixox), opcoes )

val = new((/2,7/),float)
ex  = (/24,48,72,96,120,144,168/)
;old
val(0,:) = (/-5.1462030410766602,-10.280347824096680,-13.583732604980469,-13.262247085571289,-15.626482009887695,-18.076045989990234,-17.678554534912109/)
;new
val(1,:) = (/-2.2925753593444824,-10.641116142272949,-17.121377944946289,-16.242321014404297,-20.714155197143555,-24.479679107666016,-28.353160858154297/)
;plotXY = gsn_csm_xy( wks, eixox,a, opcoes )
plotXY = gsn_csm_xy( wks, ex,val, opcoes )



end
