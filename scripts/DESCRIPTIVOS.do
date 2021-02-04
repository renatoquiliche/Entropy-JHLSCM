****************Tabla de variables y estadisticos descriptivos******************

clear all

global originales cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\originales"
global intermedias cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\intermedias"
global outputs cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"


$outputs
use base_final, clear

global indicador_buen_hogar casa_propia vivienda_casa pared_cemento grieta ///
desague_alcantarillado agua_acueducto sanitario_dentro techo_barro agua_tratada ///
reservorio_agua piso_madera_buena techo_bueno cielo_r alumbrado_electricidad ///
pres_humo cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic ///
alm_residuos_adecuado disp_residuos_adecuado reusa_residuos ///
residuos_separados_fuente s_energia s_gas s_recoleccion s_telefono ///
s_alcantarillado s_acueducto almc_quimicos_adecuado almac_medicamentos_adecuado ///
cons_medicamentos_adecuado revisa_medicamentos_adecuado

global indicador_socializacion prips prcaseta_comunal priglesia prsitio_esparcimiento ///
 prmejoramiento prr_vecinos prg__tercera_edad ///
 prg__actividad_fisica prg__oracion prg__veeduria prg__ecologico prg__juvenil prg__otro
 
global indicador_atencion_medica prmedica prodontologica prpsicologica
 
global indicador_enfermedad_mayores proporcion_diabetes proporcion_hipertension ///
proporcion_dislipidemia proporcion_renal proporcion_epoc 

global indicador_morbilidad infectado_eta infectado_ira infectado_eda ///
 infectado_tuberculosisolepra infectado_malaria infectado_diabetesmellitus ///
 infectado_cancermen18 infectado_chikungunya infectado_sintomresp ///
 infectado_otracual
 
global covariables ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer riqueza1 riqueza2 riqueza3 riqueza4 riqueza5  discapacidad_miembro gestante ///
 proporcion_desnutridos n_miembros

**riqueza6 si borro esto me borra todo DOSQUEBRADAS XD
global variables $indicador_buen_hogar $indicador_socializacion $indicador_atencion_medica ///
$indicador_enfermedad_mayores $indicador_morbilidad $covariables

tab com, gen(comuna) nol
tab com DOSQUEBRADAS
**dropeo los missing
foreach var in $variables{
drop if missing(`var')
}


******************EN ESTE PUNTO LA BASE ESTA DEPURADA***************************
save base_depurada, replace

**ESTADISTICOS DESCRPITIVOS***
tabstat $indicador_buen_hogar, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat)


tabstat $indicador_socializacion, by(DOSQUEBRADAS) stats(mean) nototal col(stat)

tabstat $indicador_enfermedad_mayores, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat) 
tabstat $indicador_morbilidad, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat)

tabstat $indicador_atencion_medica, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat)


tabstat muerte_enfermedad muerte_incidental_delito, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat)


tabstat $covariables, by(DOSQUEBRADAS) stats(mean sd) nototal col(stat) 


****Dummies nuevas variables
**Dumies en estos loops
foreach var in $indicador_socializacion{
gen d_`var'=(`var'>0)
}
foreach var in $indicador_atencion_medica{
gen d_`var'=(`var'>0)
}
foreach var in $indicador_enfermedad_mayores{
gen d_`var'=(`var'>0)
}
**solucionar riqueza6
global otras discapacidad_miembro gestante ///
proporcion_desnutridos

foreach var in $otras{
gen d_`var'=(`var'>0)
}

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
muerte* ocupado convcas mujer, first

tabstat d_prips-d_prg__otro, by(DOSQUEBRADAS) stats(mean) nototal col(stat)

tabstat d_proporcion_diabetes-d_proporcion_epoc, by(DOSQUEBRADAS) stats(mean) nototal col(stat)

tabstat d_prmedica d_prodontologica d_prpsicologica ///
muerte_enfermedad muerte_incidental_delito, by(DOSQUEBRADAS) stats(mean) nototal col(stat)

tabstat d_discapacidad_miembro d_gestante d_proporcion_desnutridos, by(DOSQUEBRADAS) stats(mean) nototal col(stat)
