load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin
;---------------------------------------
;VARIAVEIS EDITAVEIS
;---------------------------------------
zero = 1
doze = 0
prev = (/"24","72"/);00,24,48,72,96,120,144,168
indi = "vies"
niv = "925"
var = "tvir"
title =""
mensal = 1
dmensal = new((/(zero + doze)*2,dimsizes(prev)/),float)
eixom = new(dimsizes(prev),float) ; utilizado apenas na media mensal
old = "old_2012_01.txt"
news = "new_2012_01.txt"
;---------------------------------------

;---------------------------------------
;VARIAVEIS
;---------------------------------------
mes=(/"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"/)
indices = new((dimsizes(prev)*(zero+doze))*2,integer)
contlinhas = 0
;eixox = new(62,float)
in = 0
id = 1
aux = 0
ax = 0
cz = 0 ;contador zero mensal old
czn = 0 ;contador zero mensal new
cd = 0 ;contador doze mensal old
cdn = 0 ;contador doze mensal new
indz = 0 ;indice zero old
indzn = 1 ;indice zero new
indd = 0 ;indice doze old
inddn = 1 ;indice doze new
dmensal = 0.0

;---------------------------------------

;---------------------------------------
;DEFINE O TÍTULO
;---------------------------------------
if(indi .eq. "rmse")then
  title = "RMSE"
end if
if(indi .eq. "vies")then
  title = "BIAS"
end if
if(var .eq. "zgeo")then
  title = title + " - Geopotencial "+ niv +" hPa"
end if
if(var .eq. "pnmm")then
  title = title + " - Pressão ao Nível Médio do Mar "+ niv +" hPa"
end if
if(var .eq. "umid")then
  title = title + " - Umidade Específica "+ niv +" hPa"
end if
if(var .eq. "wpre")then
  title = title + " - Água Precipitável "+ niv +" hPa"
end if
if(var .eq. "tvir")then
  title = title + " - Temperatura Virtual "+ niv +" hPa"
end if
if(var .eq. "uwin")then
  title = title + " - Vento Zonal "+ niv +" hPa"
end if
if(var .eq. "vwin")then
  title = title + " - Vento Meridional "+ niv +" hPa"
end if
if(var .eq. "wind")then
  title = title + " - Velocidade do Vento "+ niv +" hPa"
end if

;----------------------------------------
n = str_split(old,"_")
year = n(1)
na = str_split(n(2),".")
month = na(0)
d = asciiread(old,-1,"string")
dn = asciiread(news,-1,"string")
;d = asciiread("t.txt",-1,"string")
dados = new((/(dimsizes(prev)*(zero+doze))*2,62/),float)

if((zero + doze) .eq. 2) then
  indz = 0
  indzn = 1
  indd = 2
  inddn = 3
end if
if(mensal .eq. 1)then
  if((zero + doze) .eq. 2) then
      leg = (/"old00","old12","new00","new12"/)
  else
      if(zero .eq. 1) then
        leg = (/"old00","new00"/)
      end if
      if(doze .eq. 1) then
         leg = (/"old12","new12"/)
      end if
  end if
else
  leg = new((dimsizes(prev)*(zero+doze))*2,string)
end if
;print("Valor de d = " + dimsizes(d))
;print(d)


indices(:) = 0
;a=(/1,2,3,4/)
;b=(/3,2,3,2/)
;c= 0
;c= c + b
;c= new((/3,4/),float)
;c(0,:) = (/0.25,0.17,0.25,0.36/)
;c(1,:) = (/0.35,0.27,0.15,0.36/)
;c(2,:) = (/0.45,0.37,0.45,0.36/)


do i=1,dimsizes(d)-1,1
 m=str_split(d(i)," ")
 mn=str_split(dn(i)," ")
 do j=5,dimsizes(m)-1,1
  do p=0,dimsizes(prev) -1
   if((stringtofloat(m(j)) .ne. -999.9) .or. (stringtofloat(mn(j)) .ne. -999.9)) then
      if(aux .eq. 0) then
        if((zero .eq. 1) .and. (m(0) .eq. "00") .and. (indi .eq. m(1)) .and. (var .eq. m(2)) .and. (niv .eq. m(3)) .and. (prev(p).eq. m(4))) then
	   contlinhas = contlinhas + 1
	   aux = aux + 1
        end if
        if((doze .eq. 1) .and. (m(0) .eq. "12") .and. (indi .eq. m(1)) .and. (var .eq. m(2)) .and. (niv .eq. m(3)) .and. (prev(p).eq. m(4))) then
	   contlinhas = contlinhas + 1
	   aux = aux + 1
	end if
	if((zero .eq. 1) .and. (mn(0) .eq. "00") .and. (indi .eq. mn(1)) .and. (var .eq. mn(2)) .and. (niv .eq. mn(3)) .and. (prev(p).eq. mn(4))) then
	   contlinhas = contlinhas + 1
	   aux = aux + 1
        end if
        if((doze .eq. 1) .and. (mn(0) .eq. "12") .and. (indi .eq. mn(1)) .and. (var .eq. mn(2)) .and. (niv .eq. mn(3)) .and. (prev(p).eq. mn(4))) then
	   contlinhas = contlinhas + 1
	   aux = aux + 1
	end if
      end if
   end if
  end do
 end do
 aux = 0
end do

do i=0,dimsizes(d)-1,1
  if(i .eq. 0) then
    m=str_split(d(0)," ")
    ;eixox = m(5:dimsizes(m)-1)
    ;print(eixox)
    eixox = new(((dimsizes(m)-5)*2),float)
    ;print(dimsizes(m))
    do j=5,dimsizes(m)-1,1
       eixox(aux) = stringtofloat(m(j))
       aux = aux + (dimsizes(m) - 5) ;31
       eixox(aux) = stringtofloat(m(j)) + 0.5
       aux = aux  - (dimsizes(m) - 6) ;30
    end do
    aux = 0
  else
    m=str_split(d(i)," ")
    mn=str_split(dn(i)," ")
    do j=5,dimsizes(m)-1,1
      do p=0,dimsizes(prev) -1
       if((stringtofloat(m(j)) .ne. -999.9) .or. (stringtofloat(mn(j)) .ne. -999.9)) then
	  
	  ;print("Valor do dados = "+dados(1,j-5))
          if((m(0) .eq. "00") .and. (zero .eq. 1) .and. (indi .eq. m(1)) .and. (var .eq. m(2)) .and. (niv .eq. m(3)) .and. (prev(p) .eq. m(4)))then
	     dados(aux,j-5) = stringtofloat(m(j))
	     indices(aux) = 1
	     if(mensal .eq. 0)then
 	       leg(aux) ="old"+ m(4) + m(0)
	     else
	       dmensal(indz,cz) = dmensal(indz,cz) + stringtofloat(m(j))
	       print("Passou aqui old 00--->"+dmensal(indz,cz))
	     end if
	     ;print("Passou aqui---->LEG"+leg(aux))
	     ax = 1
	     
	  else
	    if((m(0) .eq. "12") .and. (doze .eq. 1) .and. (indi .eq. m(1)) .and. (var .eq. m(2)) .and. (niv .eq. m(3)) .and. (prev(p) .eq. m(4)))then
	     dados(aux,(j-5)+31) = stringtofloat(m(j))
             indices(aux) = 1
	     if(mensal .eq. 0)then
 	       leg(aux) = "old"+m(4) + m(0)
	     else
	       dmensal(indd,cd) = dmensal(indd,cd) + stringtofloat(m(j))
	       print("Passou aqui old 12--->"+dmensal(indd,cd))
	     end if
	     ;print("Passou aqui---->LEG"+leg(aux))
	     ax = 1
	    end if
	  end if
	  if((mn(0) .eq. "00") .and. (zero .eq. 1) .and. (indi .eq. mn(1)) .and. (var .eq. mn(2)) .and. (niv .eq. mn(3)) .and. (prev(p) .eq. mn(4)))then
	     dados(aux+(dimsizes(leg)/2),j-5) = stringtofloat(mn(j))
	     indices(aux+(dimsizes(leg)/2)) = 1
	     if(mensal .eq. 0)then
 	       leg(aux+(dimsizes(leg)/2)) ="new"+ mn(4) + mn(0)
	     else
	       dmensal(indzn,czn) = dmensal(indzn,czn) + stringtofloat(mn(j))
	       print("Passou aqui new 00--->"+dmensal(indzn,czn))
	     end if
	     ;print("Passou aqui---->LEG"+leg(aux))
	     ax = 1
	     
	  else
	    if((mn(0) .eq. "12") .and. (doze .eq. 1) .and. (indi .eq. mn(1)) .and. (var .eq. mn(2)) .and. (niv .eq. mn(3)) .and. (prev(p) .eq. mn(4)))then
	     dados(aux+(dimsizes(leg)/2),(j-5)+31) = stringtofloat(mn(j))
             indices(aux+(dimsizes(leg)/2)) = 1
	     if(mensal .eq. 0)then
 	       leg(aux + (dimsizes(leg)/2)) ="new"+ mn(4) + mn(0)
	     else
	       dmensal(inddn,cdn) = dmensal(inddn,cdn) + stringtofloat(mn(j))
	       print("Passou aqui new 12--->"+dmensal(inddn,cdn))
	     end if
	     ;print("Passou aqui---->LEG"+leg(aux))
	     ax = 1
	    end if
	  end if  
	end if
      end do 
    end do
    if(ax .eq. 1)then
       aux = aux + 1
       ax = 0
       if(mensal .eq. 1)then
          if(m(0) .eq. "00")then
	     cz = cz + 1
	  end if
	  if(m(0) .eq. "12")then
	     cd = cd + 1
	  end if
	  if(mn(0) .eq. "00")then
	     czn = czn + 1
	  end if
	  if(mn(0) .eq. "12")then
	     cdn = cdn + 1
	  end if
       end if
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

wks = gsn_open_wks( "x11", "xyPlot")
opcoes = True
opcoes@tiMainString = title;"Grafico exemplo!"
opcoes@tiXAxisString = mes(stringtoint(month)-1)+" - "+year ;"eixo X - indice do vetor"
opcoes@tiYAxisString = "[k]"
opcoes@gsnMaximize = True
opcoes@vpWidthF         = 1.0                      ; set width and height
opcoes@vpHeightF        = 1.0

;---------------------------------------------------------------
; Altera a cor da linha e adiciona marcadores!!!
;---------------------------------------------------------------
;opcoes@xyMarkLineMode = "MarkLines"    ; Markers *and* lines
;opcoes@xyMarkers      = (/6,11,16/)    ; 3 different markers
;opcoes@xyMarkerColors = (/"blue","red","green","orange","yellow","grey","Aquamarine"/)  ; 3 different colors
opcoes@xyLineColors      = (/"blue","red","green","orange","yellow","grey","Aquamarine"/); change line color

;----------------------------------------------------------------

;---------------------------------------------------------------
; LEGENDA 1
;---------------------------------------------------------------
opcoes@pmLegendDisplayMode    = "Always"         ; Turn on a legend
opcoes@pmLegendOrthogonalPosF = -1.17            ; Move legend inside plot
opcoes@pmLegendParallelPosF   =  1.15             ; Move legend to right
opcoes@pmLegendWidthF         = 0.23             ; Change width and height
opcoes@pmLegendHeightF        = 0.2
opcoes@xyLabelMode            = "Custom"
;opcoes@xyExplicitLabels       = (/"24","48","72","96"/)  ; explicit labels
opcoes@xyExplicitLabels       = leg              ; explicit labels
opcoes@xyLineLabelFontHeightF = 0.015            ; font height
opcoes@lgPerimFill            = "SolidFill"      ; Fill legend box w/white
;opcoes@lgPerimFillColor       = "white"          ; so it masks XY curves
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
; EIXO XY
;---------------------------------------------------------------
;opcoes@trYMinF = 1.2		; set minimum Y-axis value
;opcoes@trYMaxF =  2.2		; set maximum Y-axis value
opcoes@trXMinF = 0		; set minimum X-axis value
opcoes@trXMaxF = eixox(dimsizes(eixox)-1) + 1 ; set maximum X-axis value

;opcoes@tmXBMode = "Manual"
;opcoes@tmXBTickStartF = eixox(0) 
;opcoes@tmXBTickEndF = dimsizes(eixox)-1
;opcoes@tmXBTickSpacingF = 1
;

if(mensal .eq. 0) then
 if(contlinhas .gt. 1) then
   a = new((/contlinhas,62/),float)
 end if
;print(dados)
print("contlinhas =" + contlinhas)
 do i=0,contlinhas-1,1
  if(indices(i) .eq. 1) then
    if(contlinhas .eq. 1) then
       a = dados(i,:)
    else
       a(in,:) = dados(i,:)
      ;print(dados(i,:))
       in = in + 1
    end if
  end if  
   
  end do
end if

if(mensal .eq. 1)then
 do i = 0, dimsizes(prev)-1
    eixom(i) = stringtofloat(prev(i))
 end do
end if

;a(1,1)=2.0
;print("Valor de a =" + a)
;print("eixox = "+ eixox)
;plotXY = gsn_csm_y( wks, stringtoint(eixox), opcoes )

if(mensal .eq. 1) then
  opcoes@trXMaxF = eixom(dimsizes(eixom)-1) + 12
  opcoes@xyMarkLineMode = "MarkLines"    ; Markers *and* lines
  ;print(eixox)
  ;print("Resultado eixox-------->"+)
  ;print("Resultado-------->"+eixox(dimsizes(eixox)-1))
  dmensal = dmensal/eixox((dimsizes(eixox)/2)-1)
  plotXY = gsn_csm_xy( wks, eixom, dmensal, opcoes )
else
  plotXY = gsn_csm_xy( wks, eixox, a, opcoes )
end if

end
