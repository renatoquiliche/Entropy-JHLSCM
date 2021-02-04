
global originales_pr cd "G:\Mi unidad\Entropía\Bases de datos\PUEBLO RICO"
global intermedias_pr cd "G:\Mi unidad\Entropía\Bases de datos\intermedias_pr"
global outputs cd "G:\Mi unidad\Entropía\Bases de datos\outputs"

***Calculos a nivel de vereda
$outputs
use bd_pueblo_rico, clear

recode edad (1/15=1) (16/30=2) (31/40=3) ///
(41/50=4) (51/60=5) (61/70=6) (71/80=7) ///
(81/100=8)
gen maletotal=(mujer==0)
gen femtotal=(mujer==1)
collapse (sum) maletotal femtotal, by(edad)
drop if missing(edad)
rename edad agegrp
replace maletotal = -maletotal
gen zero = 0
#delimit ;
twoway bar maletotal agegrp, horizontal bfc(gs7) blc(gs7) ||
bar femtotal agegrp, horizontal bfc(gs11) blc(gs11) ||
scatter agegrp zero, mlabel(agegrp) mlabcolor(black) msymbol(none)
title("US Male and Female Population by Age, Year 2000")
note("Source: US Census Bureau, Census 2000, Tables 1, 2 and 3", span)
xtitle("Population in Millions") ytitle("Age Group Number")
ytitle("") yscale(noline) ylabel(none)
legend(off) text(15 -8 "Male") text(15 8 "Female");
#delimit cr

sysuse pop2000, clear


foreach var in riesgo infectado_ira{
entropy `var', by(barrio_o_vereda) gen
drop `var'_renyi `var'_hill `var'_hct
}
pca casa_propia pared_cemento grieta desague_alcantarillado agua_acueducto ///
agua_tratada piso_madera_buena techo_bueno s_energia s_gas s_recoleccion s_telefono cielo_r
predict buen_hogar, score

logit riesgo casa_propia pared_cemento grieta desague_alcantarillado agua_acueducto ///
agua_tratada piso_madera_buena techo_bueno s_energia s_gas s_recoleccion s_telefono cielo_r
