clear all

global originales cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\originales"
global intermedias cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\intermedias"
global outputs cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"


****estimaciones calculos finales

$outputs
use base_final, clear
tab com, gen(comuna) nol
tab com DOSQUEBRADAS
** > 0.25
**prr_vecinos
**prmedica
**prodontologica
**prpsicologia
**prg__veeduria
**prg__otro
pca prmedica prodontologica prpsicologica
predict indicador_atencion_salud, score

***determinar qué dimensiones no representa el indicador buen hogar
corr indicador_buen_hogar casa_propia vivienda_casa pared_cemento grieta ///
desague_alcantarillado agua_acueducto sanitario_dentro techo_barro agua_tratada ///
reservorio_agua piso_madera_buena techo_bueno cielo_r alumbrado_electricidad ///
pres_humo cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic ///
alm_residuos_adecuado disp_residuos_adecuado reusa_residuos ///
residuos_separados_fuente s_energia s_gas s_recoleccion s_telefono ///
s_alcantarillado s_acueducto almc_quimicos_adecuado almac_medicamentos_adecuado ///
cons_medicamentos_adecuado revisa_medicamentos_adecuado

**criterio correlacion mayor a 0.25
**casa_propia
**techo_barro
**alumbrado_electricidad
**cocina_aislada1 cocina_aislada2
**almc_alimentos_toxic
**reusa_residuos
**residuos_separados_fuente
**almc_quimicos_adecuado
**almac_medicamentos_adecuado
**cons_medicamentos_adecuado
**revisa_medicamentos_adecuado

corr indicador_socializacion prips prcaseta_comunal priglesia prsitio_esparcimiento ///
 prmejoramiento prr_vecinos prmedica prodontologica prpsicologica prg__tercera_edad ///
 prg__actividad_fisica prg__oracion prg__veeduria prg__ecologico prg__juvenil prg__otro
 

**QUEDAN
**prr_vecinos
**prg__veeduria
**prg__otro

corr indicador_vacunacion_menores proporcion_tbc proporcion_hepatitis ///
proporcion_polio proporcion_pentavalente proporcion_rotavirus ///
proporcion_neumococo proporcion_influenza proporcion_amarilla ///
proporcion_dtp proporcion_vph 

**QUEDAN
***proporcion_hepatitis

**MORTALIDAD
corr indicador_enfermedad_mayores proporcion_diabetes proporcion_hipertension ///
proporcion_dislipidemia proporcion_renal proporcion_epoc 
drop indicador_enfermedad_mayores
pca proporcion_diabetes proporcion_hipertension ///
proporcion_dislipidemia proporcion_renal proporcion_epoc 
predict indicador_enfermedad_mayores, score

***MORBILIDAD
corr indicador_morbilidad infectado_eta infectado_ira infectado_eda ///
 infectado_tuberculosisolepra infectado_malaria infectado_diabetesmellitus ///
 infectado_cancermen18 infectado_chikungunya infectado_sintomresp ///
 infectado_otracual
 
 **VARIOS
 **infectado_eta
 **infectado_tuberculosisolepra
 **infectado_diabetesmellitus
 **infectado_cancermen18
 **infectado_chikungunya 
 **infectado_sintomresp 
 **infectado_otracual 
 
 **DESCARTAR
 **infectado_violenciaintrafamiliar 
 **infectado_violenciasexual 
 **infectado_transtornomental


global resto_bh casa_propia techo_barro cocina_aislada1 cocina_aislada2 ///
almc_alimentos_toxic reusa_residuos residuos_separados_fuente almc_quimicos_adecuado ///
almac_medicamentos_adecuado cons_medicamentos_adecuado revisa_medicamentos_adecuado

global resto_socializacion prr_vecinos prg__veeduria prg__otro

global resto_vac_menores proporcion_hepatitis

global resto_infectados infectado_eta infectado_tuberculosisolepra ///
infectado_diabetesmellitus infectado_chikungunya ///
 infectado_sintomresp  infectado_otracual muerte_enfermedad muerte_incidental_delito
**infectado_cancermen18 predice fallo perfectamente
global covariables comuna1-comuna24 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer discapacidad_miembro gestante riqueza2 riqueza3 riqueza4 ///
n_miembros proporcion_desnutridos
**riqeuza 1 (base)
***riqueza 5
***riqueza 6
**predicen fallo perfectamente

global variables riesg_deslizamiento $covariables indicador_buen_hogar $resto_bh ///
indicador_socializacion $resto_socializacion indicador_morbilidad $resto_infectados ///
indicador_atencion_salud indicador_enfermedad_mayores ///
riesg_inundacion riesg_colapso 
foreach var in $variables{
drop if missing(`var')
}

drop indicador_buen_hogar
qui pca casa_propia vivienda_casa pared_cemento grieta ///
desague_alcantarillado agua_acueducto sanitario_dentro techo_barro agua_tratada ///
reservorio_agua piso_madera_buena techo_bueno cielo_r alumbrado_electricidad ///
pres_humo cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic ///
alm_residuos_adecuado disp_residuos_adecuado reusa_residuos ///
residuos_separados_fuente s_energia s_gas s_recoleccion s_telefono ///
s_alcantarillado s_acueducto almc_quimicos_adecuado almac_medicamentos_adecuado ///
cons_medicamentos_adecuado revisa_medicamentos_adecuado
qui predict indicador_buen_hogar, score
tabstat indicador_buen_hogar, by(estrato)
 
 ///MODELO CON TODA LA INFORMACIÓN POSIBLE
logit riesg_deslizamiento $covariables indicador_buen_hogar $resto_bh ///
indicador_socializacion $resto_socializacion indicador_morbilidad $resto_infectados ///
indicador_atencion_salud indicador_enfermedad_mayores ///
riesg_inundacion riesg_colapso
estat clas
predict pr_deslizamiento
*margins, dydx(*) atmeans post
outreg2 using resultados, dec(3) excel replace ctitle("Deslizamiento")

 ///MODELO CON TODA LA INFORMACIÓN POSIBLE
logit riesg_inundacion $covariables indicador_buen_hogar $resto_bh ///
indicador_socializacion $resto_socializacion indicador_morbilidad $resto_infectados ///
indicador_atencion_salud indicador_enfermedad_mayores ///
riesg_deslizamiento riesg_colapso
estat clas
predict pr_inundacion
*margins, dydx(*) atmeans post
outreg2 using resultados, dec(3) excel append ctitle("Inundación")

 ///MODELO CON TODA LA INFORMACIÓN POSIBLE
logit riesg_colapso $covariables indicador_buen_hogar $resto_bh ///
indicador_socializacion $resto_socializacion indicador_morbilidad $resto_infectados ///
indicador_atencion_salud indicador_enfermedad_mayores ///
riesg_inundacion riesg_deslizamiento
estat clas
predict pr_colapso
*margins, dydx(*) atmeans post
outreg2 using resultados, dec(3) excel append ctitle("Colapso")

*** quedar solo con las obs a usar
global covariables comuna1-comuna24 ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer discapacidad_miembro gestante riqueza2 riqueza3 riqueza4 ///
n_miembros proporcion_desnutridos

sum $variables
sum riqueza1-riqueza6
preserve
***FORMATO
label define a 0 "Pueblo Rico" 1 "Dosquebradas"
label values DOSQUEBRADAS a
keep $variables DOSQUEBRADAS
rename ($variables) _=
gen long obs_no = _n
reshape long _, i(obs_no) j(variable) string
table variable DOSQUEBRADAS, col c(mean _)
restore

 
**twoway (kdensity pr_deslizamiento if com==16) (kdensity pr_deslizamiento if com==5 & pr_deslizamiento>0.01)
gen hogares=1 if !missing(pr_deslizamiento)
foreach desastre in deslizamiento inundacion colapso{
gen entropy_`desastre'=-pr_`desastre'*(ln(pr_`desastre')/ln(2))
}
***GRAFICOS
foreach desastre in deslizamiento inundacion colapso{
twoway (scatter entropy_`desastre' pr_`desastre', msize(vsmall) mfcolor(black) mlcolor(black)), ///
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
foreach desastre in deslizamiento inundacion colapso{
tab riesg_`desastre' clas_`desastre', cell
}


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
export excel using "resultados_tablas.xlsx", firstrow(variables) replace

**qui run "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\scripts\calculos_final.do"
