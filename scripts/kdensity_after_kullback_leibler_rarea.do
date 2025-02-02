global input	cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\outputs\Entropia cruzada"

global output 	cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\outputs\Entropia cruzada\kdensity"

$input
*LOOP PRINCIPAL: este loop unifica los datos en una sola base para hacer todos los calculos
foreach desastre in deslizamiento inundaciones colapsos{

forvalues i=1(1)24{

import excel	"results_`desastre'.xlsx", sheet("Sheet`i'") firstrow clear

rename KL KL`i'_`desastre'
save KL`i'_`desastre', replace
}

}

use KL1_deslizamiento, clear
forvalues i=2(1)24{
append using KL`i'_deslizamiento
}
egen kl_deslizamiento=rowtotal(KL1_deslizamiento-KL24_deslizamiento)
sum kl_deslizamiento


foreach desastre in inundaciones colapsos{
forvalues i=1(1)24{
append using KL`i'_`desastre'
}
}

****Test de medias para ver diferencias sistemáticas entre distritos
putexcel	set mean_test.xlsx, replace
foreach		disaster in deslizamiento inundacion colapso{
forvalues j=1(1)24{
forvalues i=1(1)24{
ttest KL`j'_`disaster'== KL`i'_`disaster', unpaired unequal
putexcel	set mean_test_`disaster'.xlsx, modify sheet(sheet`j')
sleep 100
putexcel	A`i'= `r(t)'
}
}
}

egen PR_deslizamiento=rowtotal(KL1_deslizamiento KL14_deslizamiento KL15_deslizamiento KL16_deslizamiento KL17_deslizamiento KL18_deslizamiento KL19_deslizamiento KL20_deslizamiento KL21_deslizamiento KL22_deslizamiento KL24_deslizamiento)
replace PR_deslizamiento=. if PR_deslizamiento==0


* PUEBLO RICO

*Se hara un grafico por cada distritio, de la distribucion de las divergencias 
*para los tres tipos de desastres

*
$output
forvalues i=1(1)24{
**HACEMOS EL GRAFICO
kdensity KL`i'_deslizamiento if KL`i'_deslizamiento<0.3, lcolor(brown) lpattern(dash) generate(x_`i'_deslizamiento d_`i'_deslizamiento) nodraw

kdensity KL`i'_inundaciones if KL`i'_inundaciones<0.3, lcolor(blue) lpattern(dash) generate(x_`i'_inundaciones d_`i'_inundaciones) nodraw

kdensity KL`i'_colapsos if KL`i'_colapsos<0.3, lcolor(mint) lpattern(dash) generate(x_`i'_colapsos d_`i'_colapsos) nodraw

}

*scale(1) ///
*xtitle("Kullback-Leibler Divergence (bits)") ///
*ytitle("Density (%)") ///
*title("KL`i'", size(medium)) ///
*graphregion(color(white)) ///
*legend(lab(1 "Landslides") lab(2 "Floods") lab(3 "Collapses") cols(3) rows(1)) ///
*xscale(range(0 0.3)) ///
*yscale(range(0 25)) ///
*saving(KL`i'.gph, replace)
**EXPORTAMOS EL GRAFICO
*graph export KL`i'.png,  replace
*}
gen zero=0



forvalues i=1(1)24{
twoway rarea d_`i'_deslizamiento zero x_`i'_deslizamiento, color("brown%50") ///
|| rarea d_`i'_inundaciones zero x_`i'_inundaciones, color("blue%50") ///
|| rarea d_`i'_colapsos zero x_`i'_colapsos, color("green%50") ///
legend(ring(0) pos(2) col(3) order(1 "Landlides" 2 "Floods" 3 "Collapses") region(lcolor(white)) size(small) ) ///
scale(1) graphregion(color(white) fcolor(white)) plotregion(color(white) fcolor(white)) ///
bgcolor(white) ///
xlab(0(0.06)0.3) ///
ylab(0(6)30, nogrid) ///
xtitle("Kullback-Leibler Divergence (bits)") ///
ytitle("Density (%)") ///
title("KL`i'", size(medium)) ///
saving(KL`i'.gph, replace) nodraw
}

forvalues i=2(1)2{
twoway rarea d_`i'_deslizamiento zero x_`i'_deslizamiento, color("brown%50") ///
|| rarea d_`i'_inundaciones zero x_`i'_inundaciones, color("blue%50") ///
|| rarea d_`i'_colapsos zero x_`i'_colapsos, color("green%50") ///
legend(ring(0) pos(2) col(3) order(1 "Landlides" 2 "Floods" 3 "Collapses") region(lcolor(white)) size(small) ) ///
scale(1) graphregion(color(white) fcolor(white)) plotregion(color(white) fcolor(white)) ///
bgcolor(white) ///
xlab(0(0.06)0.3) ///
ylab(0(12)50, nogrid) ///
xtitle("Kullback-Leibler Divergence (bits)") ///
ytitle("Density (%)") ///
title("KL`i'", size(medium)) ///
saving(KL`i'.gph, replace) nodraw
}



*
* PUEBLO RICO
grc1leg KL1.gph KL14.gph KL15.gph KL16.gph, scale(1) saving(g1.gph, replace) graphregion(color(white))

graph export g1.png, replace
grc1leg KL17.gph KL18.gph KL19.gph KL20.gph, scale(1) saving(g2.gph, replace) graphregion(color(white))
graph export g2.png, replace
grc1leg KL21.gph KL22.gph KL24.gph, scale(1) saving(g3.gph, replace) graphregion(color(white))
graph export g3.png, replace

* DOSQUEBRADAS
grc1leg KL2.gph KL3.gph KL4.gph KL5.gph, scale(1) saving(g4.gph, replace) graphregion(color(white))
graph export g4.png, replace
grc1leg KL6.gph KL7.gph KL8.gph KL9.gph, scale(1) saving(g5.gph, replace) graphregion(color(white))
graph export g5.png, replace
grc1leg KL10.gph KL11.gph KL12.gph KL13.gph KL23.gph, scale(1) saving(g6.gph, replace) graphregion(color(white))
graph export g6.png, replace



forvalues i=1(1)6{
erase g`i'.gph
}


*BORRAMOS LOS INSUMOS INTERMEDIOS PARA QUE LA CARPETA QUEDE LIMPIA
$input
foreach desastre in deslizamiento inundaciones colapsos{
forvalues i=1(1)24{
erase KL`i'_`desastre'.dta
}
}
*IMAGENES GPH
*forvalues i=1(1)24{
*erase KL`i'.png
*}
*
$output
forvalues i=1(1)24{
erase KL`i'.gph
}
*

foreach desastre in deslizamiento inundaciones colapsos{
forvalues i=1(1)24{

gen KL`i'_`desastre'_high=(KL`i'_`desastre'<=0.3)

}
}

foreach desastre in deslizamiento inundaciones colapsos{
forvalues i=1(1)24{
qui sum KL`i'_`desastre'_high
display r(mean)*100  
}
}

foreach desastre in deslizamiento inundaciones colapsos{
use KL1_`desastre', clear
forvalues i=2(1)24{
append using KL`i'_`desastre'
}
egen kl_`desastre'=rowtotal(KL1_`desastre'-KL24_`desastre')
sum kl_`desastre', detail
}


*** LISTA ALFABETICA DE LOS DISTRITOS
* PUEBLO RICO
*(kdensity KL1 if KL1<1) ///
*(kdensity KL14 if KL14<1) ///
*(kdensity KL15 if KL15<1) ///
*(kdensity KL16 if KL16<1) ///
*(kdensity KL17 if KL17<1) ///
*(kdensity KL18 if KL18<1) ///
*(kdensity KL19 if KL19<1) ///
*(kdensity KL20 if KL20<1) ///
*(kdensity KL21 if KL21<1) ///
*(kdensity KL22 if KL22<1) ///
*(kdensity KL24 if KL24<1)

* DOSQUEBRADAS
*twoway (kdensity KL2 if KL2<1) ///
*(kdensity KL3 if KL3<1) ///
*(kdensity KL4 if KL4<1) ///
*(kdensity KL5 if KL5<1) ///
*(kdensity KL6 if KL6<1) ///
*(kdensity KL7 if KL7<1) ///
*(kdensity KL8 if KL8<1) ///
*(kdensity KL9 if KL9<1) ///
*(kdensity KL10 if KL10<1) ///
*(kdensity KL11 if KL11<1) ///
*(kdensity KL12 if KL12<1) ///
*(kdensity KL13 if KL13<1) ///
*(kdensity KL23 if KL23<1) 

