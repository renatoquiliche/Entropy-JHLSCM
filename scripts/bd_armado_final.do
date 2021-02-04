



global originales cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\originales"
global intermedias cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\intermedias"
global outputs cd "G:\Unidades compartidas\Entropía - Colombia\Bases de datos\datos\outputs"

***VARIABLES DEL JEFE DE HOGAR Y LOCALIZACION DEL HOGAR
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'1, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen jefe=(parentescos_id=="1 - Jefe")
**nos quedamos con el jefe de hogar para obtener sus estadisticas
sort nivel_ed
drop in 1/1
tab nivel_educativo if nivel_educativo!=" ", gen(ne) 
gen ocupado=(ocupacion!="0 - Sin actividad")
gen convcas=(estado_civil_id=="1 - Union libre" | estado_civil_id=="2 - Casado")
gen edad_jefe=edad
gen mujer=(sexo=="F")
gen rural=(area=="R")
gen urbano=(area=="C" | area=="U")

****SIN CAMBIAR EL ORDEN DE LOS DATOS
$intermedias
preserve
bys idh: egen max_edad=max(edad)
bys idh: egen max_jefe=max(jefe)
bys idh: egen suma=sum(jefe)
replace jefe=1 if max_edad==edad & max_jefe==0
**aqui lleno los hogares que no tienen jefe
replace jefe=0 if suma>1 & max_edad!=edad
**corrigo duplicados1
keep if jefe==1
save a, replace
restore
**ESTE COMANDO ARREGLA EL PROBLEMA CON LOS DUPLICADOS
**como gestante y discapacitado tienen pocas obs para el jefe de hogar se armara
**indicadores de los miembros para estas variables
keep id idh jefe ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer urbano rural
merge 1:1 id idh using a, nogen
tab jefe
keep if jefe==1
drop if edad<14
keep id idh jefe ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer urbano rural comuna barrio
erase a.dta
$intermedias
save hogar1_`ciudad', replace
*****DISCAPACITADOS
$originales
use `ciudad'1, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
replace tipo_discapacidad="0 - Ninguna" if tipo_discapacidad==" "
gen discapacidad_miembro=(tipo_discapacidad!="0 - Ninguna")
**porcentaje de miembros con discapacidad
**pendiente probar la dummie
collapse (mean) discapacidad_miembro, by(idh)
$intermedias
save discapacidad_`ciudad', replace
*****GESTANTES
$originales
use `ciudad'1, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
replace gestante_="100" if gestante_nro_meses=="NO"
destring gestante, replace
recode gestante_ (1/9=1) (100/999=0), gen(gestante)
replace gestante=0 if missing(gestante)
collapse (mean) gestante, by(idh)
**porcentaje de miembros gestantes
**pendiente probar la dummie
$intermedias
save gestante_`ciudad', replace
}

use hogar1_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using hogar1_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
drop if comuna=="PRUEBAS" | comuna=="prueba"
encode comuna, gen(com)
drop comuna_o_corregimiento id urbano
duplicates drop idh, force
save hogar1, replace

use discapacidad_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using discapacidad_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
save discapacidad, replace

use gestante_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using gestante_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
save gestante, replace


********************************************************************************
****VARIABLES DEL HOGAR
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'2, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen riesgo=(riesgo_deslizamiento=="1 - Si" | riesgo_inundacion=="1 - Si" | ///
 riesgo_colapso=="1 - Si")
 gen riesg_deslizamiento=(riesgo_deslizamiento=="1 - Si")
 gen riesg_inundacion=(riesgo_inundacion=="1 - Si")
 gen riesg_colapso=(riesgo_colapso=="1 - Si")
 egen riesgo_ordenada=rowtotal(riesg_*)
destring personas_hab, replace
drop if estrato==" "
tab estrato, gen(riqueza) //Esta a nivel de hogar
gen casa_propia=(tipo_tenencia=="3 - Propia pagada")
gen vivienda_casa=(tipo_vivienda=="1 - Casa o apartamento")
gen pared_cemento=(tipo_pared=="1 - Bloque, ladrillo")
gen grieta=(grietas=="1 - Si")
**ver como relacionar carac de miembros con carac de hogar, facil por jefe de
**hogar o se hacen indicadores promedio

**PARA LOS MIEMBROS

**acceso a agua y desague por red
gen desague_alcantarillado=(tipo_servicio_=="1 - Inodoro con conexion a alcantarillado")
gen agua_acueducto=(tipo_origen_agua=="1 - Acueducto")
gen sanitario_dentro=(ubicacion_sanitario=="1 - Dentro")
gen techo_barro=(tipo_techo=="3 - Teja de barro, zinc, plastico, plancha")
**agua tratada
gen agua_tratada=(tipo_tratamiento_agua!="1 - Sin Tratamiento")
destring reservorios, replace
replace reservorios=0 if missing(reservorios)
gen reservorio_agua=(reservorios!=0)

**piso
gen piso_madera_buena=(tipo_piso== ///
"2 - Marmol, parque, madera pulida, baldosa, vinilo ,mineral, tableta o ladrillo")

*techo
gen techo_bueno=(estado_techo=="1 - Bueno")

gen cielo_r=(cielo_raso=="1 - Si")
gen alumbrado_electricidad=(tipo_alumbrado=="1 - Electricidad")
***
gen pres_humo=(presencia_humo=="1 - Si")
gen cocina_aislada1=(cocina_aislada_dormitorio=="1 - Si")
gen cocina_aislada2=(cocina_aislada_sanitario=="1 - Si")
gen nevera=(tiene_nevera=="1 - Si")
gen almc_alimentos_toxic=(alimentos_sustancias_toxicas=="1 - Si")
**
gen alm_residuos_adecuado=(residuos_tipo_almacenamiento=="3 - Canecas con tapa" ///
| residuos_tipo_almacenamiento=="1 - Bolsas plasticas")
gen disp_residuos_adecuado=(residuos_tipo_disposicion=="1 - La recogen los servicios de aseo")
gen reusa_residuos=(residuos_tipo_aprovechamiento=="4 - No aprovecha" | ///
residuos_tipo_aprovechamiento==" ")
recode reusa_residuos (1=0) (0=1)
gen residuos_separados_fuente=(residuos_separado_fuente=="1 - Si")

gen s_energia=(servicio_energia=="SI")
gen s_gas=(servicio_gas=="SI")
gen s_recoleccion=(servicio_recoleccion=="SI")
gen s_telefono=(servicio_telefono=="SI")

**otros servicios
gen s_alcantarillado=(servicio_alcantarillado=="SI")
gen s_acueducto=(servicio_acueducto=="SI")

**
gen almc_quimicos_adecuado=(almacena_quimicos_adecuado=="1 - Si")
**
gen almac_medicamentos_adecuado=(almacena_medicamentos=="1 - Si")
gen cons_medicamentos_adecuado=(consume_medicamentos=="1 - Si")
gen revisa_medicamentos_adecuado=(revisa_fecha_medicamentos=="1 - Si")

keep id-revisa_medicamentos_adecuado estrato
$intermedias
save hogar2_`ciudad', replace
}

****Unir las bases de DOSQUEBRADAS Y PBLORICO para hacer un indicador de la riqueza
$intermedias
use hogar2_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using hogar2_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
global riqueza casa_propia vivienda_casa pared_cemento grieta desague_alcantarillado ///
 agua_acueducto sanitario_dentro techo_barro agua_tratada reservorio_agua ///
 piso_madera_buena techo_bueno cielo_r alumbrado_electricidad pres_humo ///
 cocina_aislada1 cocina_aislada2 nevera almc_alimentos_toxic alm_residuos_adecuado ///
 disp_residuos_adecuado reusa_residuos residuos_separados_fuente s_energia s_gas ///
 s_recoleccion s_telefono s_alcantarillado s_acueducto almc_quimicos_adecuado ///
 almac_medicamentos_adecuado cons_medicamentos_adecuado revisa_medicamentos_adecuado

pca $riqueza, components(3) blanks(.1)
predict indicador_buen_hogar, score
$intermedias
save hogar2, replace

*******////MIEMBROS
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'1, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
**NRO DE MENORES DE EDAD por hogar
gen n_miembros=1
collapse (sum) n_miembros, by(idh)
$intermedias
save n_miembros_`ciudad', replace
}


**ASOCIATIVIDAD
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'3, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
**infraestructura del barrio
gen ips=(uso_ips=="SI")
gen caseta_comunal=(uso_caseta_comunal=="SI")
gen iglesia=(uso_iglesia=="SI")
gen sitio_esparcimiento=(uso_sitio_esparcimiento=="SI")
**
gen mejoramiento=(mejoramiento_barrio=="1 - Si")
gen r_vecinos=(relacion_vecinos=="1 - Si")
**
gen medica=(consulta_medica_ultimo_mes=="1 - Si")
gen odontologica=(consulta_odontologica_ultimo_mes=="1 - Si")
gen psicologica=(consulta_odontologica_ultimo_mes=="1 - Si")
**
foreach var in _tercera_edad _actividad_fisica ///
 _oracion _veeduria _ecologico _juvenil ///
 _otro{
 gen g_`var'=(grupo`var'=="SI")
 }
***

gen apoyo_social=(red_apoyo=="1 - Si")
gen programa=(pertenece_programa!="5 - Ninguno")
gen esp_comunitarios=(relacion_vecinos=="1 - Si")

collapse (sum) ips caseta_comunal iglesia sitio_esparcimiento mejoramiento ///
r_vecinos medica odontologica psicologica g__tercera_edad ///
g__actividad_fisica g__oracion g__veeduria g__ecologico ///
g__juvenil g__otro apoyo_social programa, by(idh)
$intermedias
merge 1:1 idh using n_miembros_`ciudad', nogen keep(3)
foreach var in ips caseta_comunal iglesia sitio_esparcimiento mejoramiento ///
r_vecinos medica odontologica psicologica g__tercera_edad g__actividad_fisica ///
g__oracion g__veeduria g__ecologico g__juvenil g__otro apoyo_social programa{
gen pr`var'=`var'/n_miembros
}
drop if prmejoramiento>1
drop if prr_vecinos>1

$intermedias
save hogar3_`ciudad', replace
}
use hogar3_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using hogar3_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
***INDICADORES DE SOCIALIZACION Y DE ATENCION MEDICA
pca prips prcaseta_comunal priglesia prsitio_esparcimiento prmejoramiento ///
prr_vecinos prg__tercera_edad prg__actividad_fisica prg__oracion ///
prg__veeduria prg__ecologico prg__juvenil prg__otro, comp(3)
predict indicador_socializacion, score notable
keep idh n_miembros prips prcaseta_comunal priglesia prsitio_esparcimiento ///
prmejoramiento prr_vecinos prmedica prodontologica prpsicologica ///
prg__tercera_edad prg__actividad_fisica prg__oracion prg__veeduria ///
prg__ecologico prg__juvenil prg__otro DOSQUEBRADAS ind prapoyo_social prprograma
save hogar3, replace


******DESNUTRICION/*********************************************************
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'4, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido1=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido1_`ciudad', replace
**vacunas na 5 años
$originales
use `ciudad'5, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido2=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido2_`ciudad', replace
**vacunas 6 a 10 años
$originales
use `ciudad'6, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido3=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido3_`ciudad', replace
**11 a 17
$originales
use `ciudad'7, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido4=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido4_`ciudad', replace
**18 a 44
$originales
use `ciudad'8, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido5=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido5_`ciudad', replace
**44 a mas
$originales
use `ciudad'9, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido6=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias
save desnutrido6_`ciudad', replace
**
$intermedias_pr
use desnutrido1_`ciudad', clear
merge 1:1 idh using desnutrido2_`ciudad', nogen
merge 1:1 idh using desnutrido3_`ciudad', nogen
merge 1:1 idh using desnutrido4_`ciudad', nogen
merge 1:1 idh using desnutrido5_`ciudad', nogen
merge 1:1 idh using desnutrido6_`ciudad', nogen
egen n_desnutridos=rowtotal(desnutrido*)
merge 1:1 idh using n_miembros_`ciudad', nogen
gen proporcion_desnutridos=n_desnutridos/n_miembros
drop if proporcion_desnutridos>1
save desnutridos_`ciudad', replace 
**Base final
}
use desnutridos_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using desnutridos_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
save desnutridos, replace

//VACUNAS\\********************************************************************
**numero de niños vacunados o porcentaje sobre el total de niños
**por cada tipo
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'1, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
keep if edad<=17
**NRO DE MENORES DE EDAD por hogar
gen n_menores=1
collapse (sum) n_menores, by(idh)
$intermedias
save n_menores_`ciudad', replace

$originales
use `ciudad'4, replace
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen tbc=(bcg=="1 - Si")
gen hepatitis=(antihepatitis_rn=="1 - Si")
gen polio=(antipolio_1_dosis=="1 - Si" & antipolio_2_dosis=="1 - Si" & antipolio_3_dosis=="1 - Si")
gen pentavalente=(pentavalente_1_dosis=="1 - Si" & pentavalente_2_dosis=="1 - Si" & pentavalente_3_dosis=="1 - Si")
gen rotavirus=(rotavirus_1_dosis=="1 - Si" & rotavirus_2_dosis=="1 - Si")
gen neumococo=(neumococo_1_dosis=="1 - Si" & neumococo_2_dosis=="1 - Si" & neumococo_3_dosis=="1 - Si")
gen influenza=(influenza_1_dosis=="1 - Si" & influenza_2_dosis=="1 - Si" & influenza_3_dosis=="1 - Si")
gen todas_v=(tbc==1 & hepatitis==1 & polio==1 & pentavalente==1 & rotavirus==1 ///
 & neumococo==1 & influenza==1)
collapse (sum) tbc hepatitis polio pentavalente rotavirus ///
neumococo influenza todas_v, by(idh)
 foreach var in tbc hepatitis polio pentavalente rotavirus ///
neumococo influenza todas_v{
 rename `var' `var'1
 }
$intermedias
save vacunas1_`ciudad', replace
**numero de niños vacunados con todas las vacunas*********************************
$originales
use `ciudad'5, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen tbc=(bcg=="1 - Si")
gen hepatitis=(antihepatitis_rn=="1 - Si")
gen polio=(antipolio_2=="1 - Si" & antipolio_4=="1 - Si" & antipolio_6=="1 - Si" & antipolio_r1=="1 - Si")
gen pentavalente=(pentavalente_2=="1 - Si" & pentavalente_4=="1 - Si" & pentavalente_6=="1 - Si")
gen rotavirus=(rotavirus_2=="1 - Si" & rotavirus_4=="1 - Si")
gen neumococo=(neumococo_2=="1 - Si" & neumococo_4=="1 - Si" & neumococo_anio=="1 - Si")
gen influenza=(influenza_6=="1 - Si" & influenza_23=="1 - Si")
gen tripleviral=(tripleviral_12=="1 - Si" & tripleviral_5=="1 - Si")
gen amarilla=(amarilla_12=="1 - Si")
gen dtp=(dtp_1=="1 - Si" & dtp_2=="1 - Si" & dtp_r1=="1 - Si")
gen hepatitis_a=(hepatitis_1=="1 - Si" & hepatitis_2=="1 - Si")
gen todas_v=(tbc==1 & hepatitis==1 & polio==1 & pentavalente==1 & rotavirus==1 ///
& neumococo==1 & influenza==1 & tripleviral==1 & amarilla==1 & dtp==1 ///
 & hepatitis_a==1)
 collapse (sum) tbc hepatitis polio pentavalente rotavirus ///
 tripleviral amarilla dtp neumococo influenza hepatitis_a todas_v, by(idh)
 foreach var in tbc hepatitis polio pentavalente rotavirus ///
 tripleviral amarilla dtp neumococo influenza hepatitis_a todas_v{
 rename `var' `var'2
 }
 $intermedias
 save vacunas2_`ciudad', replace
 *******************************************************************************
$originales
use `ciudad'6, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen tripleviral=(triple_viral=="1 - Si")
gen vph=(vph_1_dosis=="1 - Si")
gen todas_v=(tripleviral==1 & vph==1)
collapse (sum) tripleviral vph todas_v, by(idh)
 foreach var in tripleviral vph todas_v{
 rename `var' `var'3
 }
 $intermedias
save vacunas3_`ciudad', replace
*******************************************************************************
$originales
use `ciudad'7, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen vph=(vph_1_dosis=="1 - Si")
gen todas_v=(vph)
collapse (sum) vph todas_v, by(idh)
 foreach var in vph todas_v{
 rename `var' `var'4
 }
 $intermedias
save vacunas4_`ciudad', replace
*************************MERGE********************************************
use vacunas1_`ciudad', clear
merge 1:1 idh using vacunas2_`ciudad', nogen
merge 1:1 idh using vacunas3_`ciudad', nogen
merge 1:1 idh using vacunas4_`ciudad', nogen
egen todas_v=rowtotal(todas_v*)
egen tbc=rowtotal(tbc*)
egen hepatitis=rowtotal(hepatitis*)
egen polio=rowtotal(polio*)
egen pentavalente=rowtotal(pentavalente*)
egen rotavirus=rowtotal(rotavirus*)
egen neumococo=rowtotal(neumococo*)
egen influenza=rowtotal(influenza*)
egen amarilla=rowtotal(amarilla*)
egen dtp=rowtotal(dtp*)
egen vph=rowtotal(vph*)
keep todas_v tbc hepatitis polio pentavalente rotavirus neumococo influenza ///
amarilla dtp vph idh
merge 1:1 idh using n_menores_`ciudad', nogen
foreach var in tbc hepatitis polio pentavalente rotavirus neumococo influenza ///
amarilla dtp vph{
gen proporcion_`var'=`var'/n_menores
}
drop if proporcion_tbc>1
drop if proporcion_polio>1
save vacunas_`ciudad', replace
}

use vacunas_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using vacunas_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
pca proporcion*
predict indicador_vacunacion_menores, score notable
save vacunas, replace

******////MAYORES
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'1, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
keep if edad>18
**NRO DE MENORES DE EDAD por hogar
gen n_mayores=1
collapse (sum) n_mayores, by(idh)
$intermedias
save n_mayores_`ciudad', replace
}

*********************ENFERMEDADES DE LOS MAYORES********************************
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'8, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
**enfermos por hogar
gen diabetes1=(diabetes=="1 - Si con control" | diabetes=="2 - Si sin control")
gen hipertension1=(hipertension=="1 - Si con control" | hipertension=="2 - Si sin control")
gen dislipidemia1=(dislipidemia=="1 - Si con control" | dislipidemia=="2 - Si sin control")
gen renal1=(renal=="1 - Si con control" | renal=="2 - Si sin control")
gen epoc1=(epoc=="1 - Si con control" | epoc=="2 - Si sin control")
//gen cancer1=(cancer=="1 - Si con control" | cancer=="2 - Si sin control") NO PUEDE USARSE, DATA INCOMPLETA
collapse (sum) diabetes1 hipertension1 dislipidemia1 renal1 epoc1, by(idh)
$intermedias
save enfermedades1_`ciudad', replace
********************************************************************************
$originales
use `ciudad'9, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen diabetes2=(diabetes=="1 - Si con control" | diabetes=="2 - Si sin control")
gen hipertension2=(hipertension=="1 - Si con control" | hipertension=="2 - Si sin control")
gen dislipidemia2=(dislipidemia=="1 - Si con control" | dislipidemia=="2 - Si sin control")
gen renal2=(renal=="1 - Si con control" | renal=="2 - Si sin control")
gen epoc2=(epoc=="1 - Si con control" | epoc=="2 - Si sin control")
collapse (sum) diabetes2 hipertension2 dislipidemia2 renal2 epoc2, by(idh)
$intermedias
save enfermedades2_`ciudad', replace
********************************************************************************
use enfermedades1_`ciudad', clear
merge 1:1 idh using enfermedades2_`ciudad', nogen
egen diabetes=rowtotal(diabetes*)
egen hipertension=rowtotal(hipertension*)
egen dislipidemia=rowtotal(dislipidemia*)
egen renal=rowtotal(renal*)
egen epoc=rowtotal(epoc*)
keep idh diabetes hipertension dislipidemia renal epoc
$intermedias
merge 1:1 idh using n_mayores_`ciudad', nogen
foreach var in diabetes hipertension dislipidemia renal epoc{
gen proporcion_`var'=`var'/n_mayores
}
drop if proporcion_hipertension>1
save enfermedades_`ciudad', replace
}

use enfermedades_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using enfermedades_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
merge 1:1 idh DOSQUEBRADAS using hogar3, nogen
pca proporcion* prmedica prodontologica prpsicologica
predict indicador_enfermedad_mayores, score notable
save enfermedades, replace

**MORTALIDAD
foreach ciudad in "PBLO_RICO" "DOSQUEBRADAS"{
$originales
use `ciudad'10, clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen muerte_enfermedad=(enfermedadcoronaria=="Si" | enfermedadrespiratoria=="Si" | cancer=="Si" ///
| vih=="Si" | tuberculosisolepra=="Si" | enfermedadprofesional=="Si" | otra=="Si")
gen muerte_incidental_delito=(homicidio=="Si" | suicidio=="Si" | accidentedetransito=="Si" ///
| accidentelaboral=="Si")
collapse (sum) muerte_enfermedad muerte_incidental_delito, by(idh)
$intermedias
save muerte_`ciudad', replace
**

**MORBILIDAD
$originales
use `ciudad'11, clear
**porcentaje de hogares con algun miembro infectado
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
rename cancerenmenoresde18años cancermen18
rename sintomáticorespiratorio sintomresp
rename trastornomentalyodelcomportamien transtornomental
foreach var in eta ira eda tuberculosisolepra malaria diabetesmellitus cancermen18 ///
chikungunya sintomresp otracual ///
transtornomental{
gen infectado_`var'=(`var'=="Si")
}
keep idh infectado*
$intermedias
save morbilidad_`ciudad', replace
}

$intermedias
use muerte_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using muerte_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
save muerte, replace

use morbilidad_DOSQUEBRADAS, clear
gen DOSQUEBRADAS=1
append using morbilidad_PBLO_RICO
replace DOSQUEBRADAS=0 if missing(DOSQUEBRADAS)
$intermedias
pca infectado*
predict indicador_morbilidad, score notable
save morbilidad, replace


****UNION DE LAS BASES DE DATOS*****
**se deben unir cerca a 28000 hogares
$intermedias
use hogar1, clear
merge 1:1 idh DOSQUEBRADAS using discapacidad, keep(3) nogen
merge 1:1 idh DOSQUEBRADAS using gestante, keep(3) nogen
merge 1:1 idh DOSQUEBRADAS using hogar2, keep(1 3) nogen
merge 1:1 idh DOSQUEBRADAS using hogar3, keep(1 3) nogen
merge 1:1 idh DOSQUEBRADAS using desnutridos, keep(1 3) nogen
merge 1:1 idh DOSQUEBRADAS using vacunas, keep(1 3) nogen
replace n_menores=0 if missing(n_menores)
merge 1:1 idh DOSQUEBRADAS using enfermedades, keep(1 3) nogen
merge 1:1 idh DOSQUEBRADAS using muerte, keep(1 3) nogen
merge 1:1 idh DOSQUEBRADAS using morbilidad, keep(1 3) nogen

$outputs
save base_final, replace
