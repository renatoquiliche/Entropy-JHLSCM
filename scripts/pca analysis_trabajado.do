****************Tabla de variables y estadisticos descriptivos******************

clear all

global originales cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\originales"
global intermedias cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\intermedias"
global outputs cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"

$outputs
use base_depurada, clear
drop if missing(com)

***GLOBAL***
global indicador_buen_hogar casa_propia vivienda_casa pared_cemento grieta ///
desague_alcantarillado agua_acueducto sanitario_dentro techo_barro agua_tratada ///
reservorio_agua  techo_bueno cielo_r alumbrado_electricidad ///
pres_humo cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic ///
alm_residuos_adecuado disp_residuos_adecuado reusa_residuos ///
residuos_separados_fuente s_energia s_gas s_recoleccion s_telefono ///
s_alcantarillado s_acueducto almc_quimicos_adecuado almac_medicamentos_adecuado ///
cons_medicamentos_adecuado revisa_medicamentos_adecuado

**solucionar piso_madera_buena

global indicador_socializacion prips prcaseta_comunal priglesia prsitio_esparcimiento ///
 prmejoramiento prr_vecinos prg__tercera_edad ///
 prg__actividad_fisica prg__oracion prg__veeduria prg__ecologico prg__juvenil prg__otro
 
foreach var in $indicador_socializacion{
gen d_`var'=(`var'>0)
}
 
global indicador_atencion_medica prmedica prodontologica prpsicologica

foreach var in $indicador_atencion_medica{
gen d_`var'=(`var'>0)
}
 
global indicador_enfermedad_mayores proporcion_diabetes proporcion_hipertension ///
proporcion_dislipidemia proporcion_renal proporcion_epoc 

foreach var in $indicador_enfermedad_mayores{
gen d_`var'=(`var'>0)
}

global indicador_morbilidad infectado_eta infectado_ira infectado_eda ///
 infectado_tuberculosisolepra infectado_malaria infectado_diabetesmellitus ///
 infectado_cancermen18 infectado_chikungunya infectado_sintomresp ///
 infectado_otracual
 
***Resto de dummies
global covariables ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer riqueza1 riqueza2 riqueza3 riqueza4 riqueza5 riqueza6 n_miembros

**solucionar riqueza6
global otras discapacidad_miembro gestante ///
proporcion_desnutridos

foreach var in $otras{
gen d_`var'=(`var'>0)
}

global variables riesg_deslizamiento riesg_inundacion riesg_colapso $covariables $indicador_buen_hogar  ///
$indicador_socializacion $indicador_enfermedad_mayores $indicador_morbilidad  ///
 $indicador_enfermedad_mayores ///
****

*****Calculo de los indicadores*****
************************************
**SE HARA AHORA UN SOLO MODELO MCA

global dataset d_prips d_prcaseta_comunal d_priglesia d_prsitio_esparcimiento d_prmejoramiento ///
 d_prr_vecinos d_prg__tercera_edad d_prg__actividad_fisica d_prg__oracion d_prg__veeduria ///
 d_prg__ecologico d_prg__juvenil d_prg__otro ///
///
 d_prmedica d_prodontologica d_prpsicologica ///
///
 d_proporcion_diabetes d_proporcion_hipertension d_proporcion_dislipidemia ///
 d_proporcion_renal d_proporcion_epoc ///
 d_discapacidad_miembro d_gestante d_proporcion_desnutridos ///
$indicador_buen_hogar $indicador_morbilidad

**Socializacion
order d_prips d_prcaseta_comunal d_priglesia d_prsitio_esparcimiento d_prmejoramiento ///
 d_prr_vecinos d_prg__tercera_edad d_prg__actividad_fisica d_prg__oracion d_prg__veeduria ///
 d_prg__ecologico d_prg__juvenil d_prg__otro ///
///
 d_prmedica d_prodontologica d_prpsicologica ///
///
 d_proporcion_diabetes d_proporcion_hipertension d_proporcion_dislipidemia ///
 d_proporcion_renal d_proporcion_epoc ///
 d_discapacidad_miembro d_gestante d_proporcion_desnutridos ///
$indicador_buen_hogar ///
muerte* ocupado convcas mujer $indicador_morbilidad, first


*****************MODELO MCA*********************

mca d_prips-mujer $indicador_morbilidad, dim(5)  
*ne1-ne6 riqueza1-riqueza6 n_miembros
putexcel set mca_results, replace
putexcel B2=matrix(e(cGS)) B1="Overall" E1="D1" F1="sqcorr" H1="D2" I1="sqcorr" ///
K1="D3" L1="sqcorr" N1="D4" O1="sqcorr" Q1="D5" R1="sqcorr"


predict d1 d2 d3 d4 d5
foreach dim in d2 d3 d5{
replace `dim'=-1*`dim'
}
*logit riesg_deslizamiento d1-d5
*logit riesg_deslizamiento d1 d2 d3 d4 riesg_inundacion riesg_colaps $covariables
twoway (kdensity d1 if DOSQUEBRADAS==1, lcolor(blue) legend(label(1 "Dosquebradas"))) ///
 (kdensity d1 if DOSQUEBRADAS==0, lcolor(red) legend(label(2 "Pueblo Rico"))) ///
 (histogram d1 if DOSQUEBRADAS==1, color(blue%40) legend(label(1 "Dosquebradas"))) ///
 (histogram d1 if DOSQUEBRADAS==0, color(red%40) legend(label(2 "Pueblo Rico"))), ///
 legend(region(lcolor(white))) graphregion(color(white)) ytitle("Kernel Density") ///
 xtitle("Wealth: assets, household status, access to services") saving(d1, replace) scale(0.6) nodraw

 *d2 + negativo más enfermedad
twoway (kdensity d2 if DOSQUEBRADAS==1, lcolor(blue) legend(label(1 "Dosquebradas"))) ///
 (kdensity d2 if DOSQUEBRADAS==0, lcolor(red) legend(label(2 "Pueblo Rico"))) ///
 (histogram d2 if DOSQUEBRADAS==1, color(blue%40) legend(label(1 "Dosquebradas"))) ///
 (histogram d2 if DOSQUEBRADAS==0, color(red%40) legend(label(2 "Pueblo Rico"))), ///
 legend(region(lcolor(white))) graphregion(color(white)) ytitle("Kernel Density") ///
 xtitle("Chronic illness, social support groups, and medical care") saving(d2, replace) scale(0.6) nodraw
 
 *d3 + negativo significa mayor pertenencia a los grupos juvenil eco y veeduria
 **(menor almacena y revisa medicamentos adecuados)
twoway (kdensity d3 if DOSQUEBRADAS==1, lcolor(blue) legend(label(1 "Dosquebradas"))) ///
 (kdensity d3 if DOSQUEBRADAS==0, lcolor(red) legend(label(2 "Pueblo Rico"))) ///
 (histogram d3 if DOSQUEBRADAS==1, color(blue%40) legend(label(1 "Dosquebradas"))) ///
 (histogram d3 if DOSQUEBRADAS==0, color(red%40) legend(label(2 "Pueblo Rico"))), ///
 legend(region(lcolor(white))) graphregion(color(white)) ytitle("Kernel Density") ///
 xtitle("Youth, ecological and monitoring social groups") saving(d3, replace) scale(0.6) nodraw
 
 *d4 mientras mayor, más atención médica
twoway (kdensity d4 if DOSQUEBRADAS==1, lcolor(blue) legend(label(1 "Dosquebradas"))) ///
 (kdensity d4 if DOSQUEBRADAS==0, lcolor(red) legend(label(2 "Pueblo Rico"))) ///
 (histogram d4 if DOSQUEBRADAS==1, color(blue%40) legend(label(1 "Dosquebradas"))) ///
 (histogram d4 if DOSQUEBRADAS==0, color(red%40) legend(label(2 "Pueblo Rico"))), ///
 legend(region(lcolor(white))) graphregion(color(white)) ytitle("Kernel Density") ///
 xtitle("Medical care in psychology and dentistry") saving(d4, replace) scale(0.6) nodraw
 
 *d5 negativa significa mejores prácticas
twoway (kdensity d5 if DOSQUEBRADAS==1, lcolor(blue) legend(label(1 "Dosquebradas"))) ///
 (kdensity d5 if DOSQUEBRADAS==0, lcolor(red) legend(label(2 "Pueblo Rico"))) ///
 (histogram d5 if DOSQUEBRADAS==1, color(blue%40) legend(label(1 "Dosquebradas"))) ///
 (histogram d5 if DOSQUEBRADAS==0, color(red%40) legend(label(2 "Pueblo Rico"))), ///
 legend(region(lcolor(white))) graphregion(color(white)) ytitle("Kernel Density") ///
 xtitle("Good cooking practices and storage of waste, chemicals and food") saving(d5, replace) scale(0.6) nodraw

graph combine d1.gph d2.gph d3.gph d4.gph d5.gph

forvalues i=1/5{
qui pwcorr d`i' $indicador_buen_hogar d_prips-d_prg__otro ///
d_proporcion_diabetes-d_proporcion_epoc $indicador_morbilidad ///
d_prmedica d_prodontologica d_prpsicologica muerte_enfermedad muerte_incidental_delito ///
ocupado convcas mujer ///
d_discapacidad_miembro d_gestante d_proporcion_desnutridos, sig

**coef
matrix D`i'=r(C)
matrix D`i'=D`i'[2..72,1]

*sig
matrix S`i'=r(sig)
matrix S`i'=S`i'[2..72,1]
}
*coef
matrix D1_5=D1,D2,D3,D4,D5
matrix list D1_5
*sig
matrix S1_5=S1,S2,S3,S4,S5

putexcel set MCA_correlation_results, replace sheet("coef")

order $indicador_buen_hogar d_prips-d_prg__otro ///
d_proporcion_diabetes-d_proporcion_epoc $indicador_morbilidad ///
d_prmedica d_prodontologica d_prpsicologica muerte_enfermedad muerte_incidental_delito ///
ocupado convcas mujer ///
d_discapacidad_miembro d_gestante d_proporcion_desnutridos, first

putexcel B2=matrix(D1_5) B1="Wealth: assets, household status, access to services" ///
C1="Chronic illness and related social support groups" ////
D1="Belonging to Social groups" ///
E1="Medical care" ///
F1="Good cooking practices, storage of waste, chemicals and food"
forvalues i=1/71{
putexcel G`i'=`i'-1
}

putexcel set MCA_correlation_results, modify sheet("sig")

putexcel B2=matrix(S1_5) B1="Wealth: assets, household status, access to services" ///
C1="Chronic illness and related social support groups" ////
D1="Belonging to Social groups" ///
E1="Medical care" ///
F1="Good cooking practices, storage of waste, chemicals and food"

save base_estimaciones, replace


*****Table 3: Summary of Risks and Results of PCA and MCA analysis
tabstat d1-d5, by(DOSQUEBRADAS) stats(mean) col(stat) nototal
