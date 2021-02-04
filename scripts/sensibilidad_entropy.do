cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"

***Analisis de Sensibilidad**
global indicador_morbilidad infectado_eta infectado_ira infectado_eda ///
 infectado_tuberculosisolepra infectado_malaria infectado_diabetesmellitus ///
 infectado_cancermen18 infectado_chikungunya infectado_sintomresp ///
 infectado_otracual
global indicador_buen_hogar casa_propia vivienda_casa pared_cemento grieta ///
desague_alcantarillado agua_acueducto sanitario_dentro techo_barro agua_tratada ///
reservorio_agua  techo_bueno cielo_r alumbrado_electricidad ///
pres_humo cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic ///
alm_residuos_adecuado disp_residuos_adecuado reusa_residuos ///
residuos_separados_fuente s_energia s_gas s_recoleccion s_telefono ///
s_alcantarillado s_acueducto almc_quimicos_adecuado almac_medicamentos_adecuado ///
cons_medicamentos_adecuado revisa_medicamentos_adecuado
 
 
use base_sensibilidad, clear

recode edad_jefe (14/30=1) (31/60=2) (61/115=3), gen(gedad)

global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 gedad ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros

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

**Deslizamientos
*****************MODELO SIN OTROS REGRESORES, SOLO D MCA*********************

mca d_prips-mujer $indicador_morbilidad $covariables, dim(5) points(gedad)
drop d1-d5
predict d1 d2 d3 d4 d5

logit riesg_deslizamiento d1-d5 ///
riesg_inundacion riesg_colapso, cluster(com)
estimates store A1
predict pr_deslizamiento_A1

global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 edad_jefe ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros


***************MODELO ACTUAL SELECCIONADO B*************************************
qui mca d_prips-mujer $indicador_morbilidad , dim(5)
drop d1-d5
predict d1 d2 d3 d4 d5

logit riesg_deslizamiento d1-d5 ///
$covariables riesg_inundacion riesg_colapso, cluster(com)
estimates store B1

***************MODELO SIN MCA*************************************
drop d1-d5

logit riesg_deslizamiento d_prips-mujer $indicador_morbilidad ///
$covariables riesg_inundacion riesg_colapso, cluster(com)
estimates store C1
predict pr_deslizamiento_C1


********************************************************************************
**Inundaciones
*****************MODELO SIN OTROS REGRESORES, SOLO D MCA*********************
global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 gedad ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros

mca d_prips-mujer $indicador_morbilidad $covariables, dim(5) points(gedad)
predict d1 d2 d3 d4 d5

logit riesg_inundacion d1-d5 ///
riesg_deslizamiento riesg_colapso, cluster(com)
estimates store A2
predict pr_inundacion_A2

global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 edad_jefe ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros


***************MODELO ACTUAL SELECCIONADO B*************************************
qui mca d_prips-mujer $indicador_morbilidad , dim(5)
drop d1-d5
predict d1 d2 d3 d4 d5

logit riesg_inundacion d1-d5 ///
$covariables riesg_deslizamiento riesg_colapso, cluster(com)
estimates store B2

***************MODELO SIN MCA*************************************
drop d1-d5

logit riesg_inundacion d_prips-mujer $indicador_morbilidad ///
$covariables riesg_deslizamiento riesg_colapso, cluster(com)
estimates store C2

predict pr_inundacion_C2


********************************************************************************
**Colapsos
*****************MODELO SIN OTROS REGRESORES, SOLO D MCA*********************
global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 gedad ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros

mca d_prips-mujer $indicador_morbilidad $covariables, dim(5) points(gedad)
predict d1 d2 d3 d4 d5

logit riesg_colapso d1-d5 ///
riesg_inundacion riesg_deslizamiento, cluster(com)
estimates store A3
predict pr_colapso_A3 

global covariables comuna1-comuna23 ne2 ne3 ne4 ne5_6 edad_jefe ///
riqueza2 riqueza3 riqueza4_6 ///
n_miembros


***************MODELO ACTUAL SELECCIONADO B*************************************
qui mca d_prips-mujer $indicador_morbilidad , dim(5)
drop d1-d5
predict d1 d2 d3 d4 d5

logit riesg_colapso d1-d5 ///
$covariables riesg_inundacion riesg_deslizamiento, cluster(com)
estimates store B3

***************MODELO SIN MCA*************************************
drop d1-d5

logit riesg_colapso d_prips-mujer $indicador_morbilidad ///
$covariables riesg_inundacion riesg_deslizamiento, cluster(com)
estimates store C3
predict pr_colapso_C3


***CALCULO ENTROPÍA LOCAL Y TABLAS FINALES
preserve 


gen hogares=1 if !missing(pr_deslizamiento_A1)
foreach desastre in deslizamiento_A1 inundacion_A2 colapso_A3{
gen entropy_`desastre'=-pr_`desastre'*(ln(pr_`desastre')/ln(2))
}

foreach desastre in deslizamiento inundacion colapso{
egen max_entropy_`desastre'=max(entropy_`desastre')
}
collapse (sum) entropy_* hogares max_entropy_* (mean) pr_*, by(com DOSQUEBRADAS)
foreach desastre in deslizamiento inundacion colapso{
gen ies_`desastre'=entropy_`desastre'/max_entropy_`desastre'
}
keep DOSQUEBRADAS com pr_* ies_* hogares
sort DOSQUEBRADAS com
order DOSQUEBRADAS com ies_deslizamiento pr_deslizamiento_A1 ies_inundacion pr_inundacion_A2 ies_colapso pr_colapso_A3 hogares
****TABLA DE ENTROPIA Y PROBABILIDADES
export excel using "G:\Unidades compartidas\Entropía - Colombia\5. Results and discussion\resultados_tablas_1.xlsx", firstrow(variables) replace
restore


********************************************************************************
preserve 
gen hogares=1 if !missing(pr_deslizamiento_A1)
***CALCULO ENTROPÍA LOCAL Y TABLAS FINALES
foreach desastre in deslizamiento_C1 inundacion_C2 colapso_C3{
gen entropy_`desastre'=-pr_`desastre'*(ln(pr_`desastre')/ln(2))
}

foreach desastre in deslizamiento_C1 inundacion_C2 colapso_C3{
egen max_entropy_`desastre'=max(entropy_`desastre')
}
collapse (sum) entropy_* hogares max_entropy_* (mean) pr_*, by(com DOSQUEBRADAS)
foreach desastre in deslizamiento inundacion colapso{
gen ies_`desastre'=entropy_`desastre'/max_entropy_`desastre'
}
keep DOSQUEBRADAS com pr_* ies_* hogares
sort DOSQUEBRADAS com
order DOSQUEBRADAS com ies_deslizamiento pr_deslizamiento_C1 ies_inundacion pr_inundacion_C2 ies_colapso pr_colapso_C3 hogares
****TABLA DE ENTROPIA Y PROBABILIDADES
export excel using "G:\Unidades compartidas\Entropía - Colombia\5. Results and discussion\resultados_tablas_3.xlsx", firstrow(variables) replace

restore
