****************Estimacion modelo logit y entropia******************

clear all

global originales cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\originales"
global intermedias cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\intermedias"
global outputs cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"

$outputs
use base_estimaciones, clear

gen ne5_6=(ne5==1 | ne6==1)
gen riqueza4_6=(riqueza4==1 | riqueza5==1 | riqueza6==1)

save base_sensibilidad, replace
global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 edad_jefe ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros

***RIQUEZA 5 Y 6 PREDICEN FALLO COMPLETAMENTE

logit riesg_deslizamiento d1-d5 ///
$covariables riesg_inundacion riesg_colapso, cluster(com)
estimates store deslizamiento
outreg2 using results_logit, excel dec(3) replace ctitle("Deslizamientos")
predict pr_deslizamiento

logit riesg_inundacion d1-d5 ///
$covariables riesg_deslizamiento riesg_colapso, cluster(com)
estimates store inundacion
outreg2 using results_logit, excel dec(3) append ctitle("Inundaciones")
predict pr_inundacion

logit riesg_colapso d1-d5 ///
$covariables riesg_inundacion riesg_deslizamiento, cluster(com)
estimates store colapso
outreg2 using results_logit, excel dec(3) append ctitle("Colapsos")
predict pr_colapso

****Calculo de la entropia aporte individual de cada hogar y primera clasificacion
**twoway (kdensity pr_deslizamiento if com==16) (kdensity pr_deslizamiento if com==5 & pr_deslizamiento>0.01)
gen hogares=1 if !missing(pr_deslizamiento)
foreach desastre in deslizamiento inundacion colapso{
gen entropy_`desastre'=-pr_`desastre'*(ln(pr_`desastre')/ln(2))
}
***GRAFICOS
foreach desastre in deslizamiento inundacion colapso{
twoway (scatter entropy_`desastre' pr_`desastre', msize(vsmall) mfcolor(black) mlcolor(red%70)), ///
graphregion(color(white)) ytitle("Entropía (`desastre')") xtitle("Pr(riesgo=1)") scale(0.9) ///
xline(0.085 0.758) saving(scatter_`desastre', replace) nodraw
}
foreach desastre in deslizamiento inundacion colapso{
graph use scatter_`desastre'
graph export scatter_`desastre'.png, replace
}
foreach desastre in deslizamiento inundacion colapso{
erase scatter_`desastre'.gph
}
***TABLAS RESUMEN
foreach desastre in deslizamiento inundacion colapso{
recode pr_`desastre' (0/0.085=1) (0.085/0.758=2) (0.758/1=3), gen(clas_`desastre')
}
tab clas_deslizamiento
tab clas_inundacion
tab clas_colapso

***CALCULO ENTROPÍA LOCAL Y TABLAS FINALES
foreach desastre in deslizamiento inundacion colapso{
egen max_entropy_`desastre'=max(entropy_`desastre')
}
collapse (sum) entropy_* hogares max_entropy_* (mean) pr_*, by(com DOSQUEBRADAS)
foreach desastre in deslizamiento inundacion colapso{
gen ies_`desastre'=entropy_`desastre'/max_entropy_`desastre'
}
keep DOSQUEBRADAS com pr_* ies_* hogares
sort DOSQUEBRADAS com
order DOSQUEBRADAS com ies_deslizamiento pr_deslizamiento ies_inundacion pr_inundacion ies_colapso pr_colapso hogares
****TABLA DE ENTROPIA Y PROBABILIDADES
export excel using "G:\Unidades compartidas\Entropía - Colombia\5. Results and discussion\resultados_tablas.xlsx", firstrow(variables) replace
