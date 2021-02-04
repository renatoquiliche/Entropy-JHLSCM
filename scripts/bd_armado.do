
global originales_pr cd "G:\Mi unidad\Entropía\Bases de datos\PUEBLO RICO"
global intermedias_pr cd "G:\Mi unidad\Entropía\Bases de datos\intermedias_pr"
global outputs_pr cd

**NECESARIO PARA ENTENDER LA BASE
**HAY CERCA DE 10000 PERSONAS
**3024 VIVIENDAS

**IMPORTANTE, proxy del jefe persona mayor con

$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen jefe=(parentescos_id=="1 - Jefe")
**nos quedamos con el jefe de hogar para obtener sus estadisticas
sort nivel_ed
drop in 1/1
tab nivel_educativo, gen(ne)
label variable ne1 sin_nivel
label variable ne2 primaria
label variable ne3 secundaria
label variable ne4 tecnica
label variable ne5 universitaria
label variable ne6 posgrado
gen ocupado=(ocupacion=="1 - Trabajando" | ocupacion=="7 - Estudia y trabaja")
gen convcas=(estado_civil_id=="1 - Union libre" | estado_civil_id=="2 - Casado")
gen edad_jefe=edad
gen mujer=(sexo=="F")
tab area, gen(a)
label variable a1 comuna
label variable a2 rural
label variable a3 urbano
**como gestante y discapacitado tienen pocas obs para el jefe de hogar se armara
**indicadores de los miembros para estas variables
$intermedias_pr
preserve
bys idh: egen max_edad=max(edad)
bys idh: egen max_jefe=max(jefe)
replace jefe=1 if max_edad==edad & max_jefe==0
keep if jefe==1
save a, replace
restore
keep id idh jefe ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer a1 a2 a3
tab jefe
drop jefe
merge 1:1 id idh using a, keep(3) nogen
tab jefe
keep if jefe==1
drop if edad<14
keep id idh jefe ne1 ne2 ne3 ne4 ne5 ne6 ocupado convcas edad_jefe ///
mujer a1 a2 a3
save hogar1_pr, replace

**Educacion PARA LOS MIEMBROS
$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
sort nivel_ed
drop in 1/1
tab nivel_educativo, gen(ne)
label variable ne1 sin_nivel
label variable ne2 primaria
label variable ne3 secundaria
label variable ne4 tecnica
label variable ne5 universitaria
label variable ne6 posgrado
gen ocupado=(ocupacion=="1 - Trabajando" | ocupacion=="7 - Estudia y trabaja")
gen convcas=(estado_civil_id=="1 - Union libre" | estado_civil_id=="2 - Casado")
gen edad_jefe=edad
gen mujer=(sexo=="F")
tab area, gen(a)
label variable a1 comuna
label variable a2 rural
label variable a3 urbano
**como gestante y discapacitado tienen pocas obs para el jefe de hogar se armara
**indicadores de los miembros para estas variables
$intermedias_pr
keep id idh ne1 ne2 ne3 ne4 ne5 ne6 ocupado edad_jefe ///
mujer
bys idh: egen ne_mean=mean(ne1)
sort ne1
sort idh id
collapse (mean) ne* ocupado mujer, by(idh)
save hogar1_pr_miembros, replace


$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
replace tipo_discapacidad="0 - Ninguna" if tipo_discapacidad==" "
gen discapacidad_miembro=(tipo_discapacidad!="0 - Ninguna")
**porcentaje de miembros con discapacidad
**pendiente probar la dummie
collapse (mean) discapacidad_miembro, by(idh)
$intermedias_pr
save discapacidad_pr, replace

$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
replace gestante_="100" if gestante_nro_meses=="NO"
destring gestante, replace
recode gestante_ (1/9=1) (100/999=0), gen(gestante)
collapse (mean) gestante, by(idh)
**porcentaje de miembros gestantes
**pendiente probar la dummie
$intermedias_pr
save gestante_pr, replace

$originales_pr
import delimited "PBLO RICO_B AMBIENTE FISICO 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen riesgo=(riesgo_deslizamiento=="1 - Si" | riesgo_inundacion=="1 - Si" | ///
 riesgo_colapso=="1 - Si")
destring personas_hab, replace
drop if estrato==" "
tab estrato, gen(riqueza) //Esta a nivel de hogar
gen casa_propia=(tipo_tenencia=="4 - Otra condicion")
gen pared_cemento=(tipo_pared=="1 - Bloque, ladrillo")
gen grieta=(grietas=="1 - Si")
**ver como relacionar carac de miembros con carac de hogar, facil por jefe de
**hogar o se hacen indicadores promedio

**PARA LOS MIEMBROS

**acceso a agua y desague por red
gen desague_alcantarillado=(tipo_servicio_=="1 - Inodoro con conexion a alcantarillado")
gen agua_acueducto=(tipo_origen_agua=="1 - Acueducto")

**agua tratada
gen agua_tratada=(tipo_tratamiento_agua!="1 - Sin Tratamiento")

**piso
gen piso_madera_buena=(tipo_piso== ///
"2 - Marmol, parque, madera pulida, baldosa, vinilo, mineral, tableta o ladrillo")

*techo
gen techo_bueno=(estado_techo=="1 - Bueno")

gen cielo_r=(cielo_raso=="1 - Si")

gen s_energia=(servicio_energia=="SI")
gen s_gas=(servicio_gas=="SI")
gen s_recoleccion=(servicio_recoleccion=="SI")
gen s_telefono=(servicio_telefono=="SI")

keep id idh riesgo riqueza1 riqueza2 riqueza3 riqueza4 riqueza5 ///
casa_propia pared_cemento grieta desague_alcantarillado agua_acueducto ///
 agua_tratada piso_madera_buena techo_bueno cielo_r s_energia s_gas ///
 s_recoleccion s_telefono
$intermedias_pr
save hogar2_pr, replace

$originales_pr
import delimited "PBLO RICO_C AMBIENTE SOCIAL 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen apoyo_social=(red_apoyo=="1 - Si")
gen esp_comunitarios=(relacion_vecinos=="1 - Si")
collapse (mean) apoyo esp_, by(idh)

$intermedias_pr
save hogar3_pr, replace

$originales_pr
***Morbilidad muy importante (aunque parece que no esta completa) //NO SE USARA
**animales
///VACUNAS
**vacunas de los bebes 1 año
import delimited "PBLO RICO_E MENORES 1 AÑO 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido1=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido1_pr, replace
**vacunas na 5 años
$originales_pr
import delimited "PBLO RICO_E NIÑOS ENTRE 1 Y 5 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido2=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido2_pr, replace
**vacunas 6 a 10 años
$originales_pr
import delimited "PBLO RICO_E NIÑOS ENTRE 6 Y 10 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido3=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido3_pr, replace
**11 a 17
$originales_pr
import delimited "PBLO RICO_E JOVENES ENTRE 11 Y 17 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido4=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido4_pr, replace
**18 a 44
$originales_pr
import delimited "PBLO RICO_E POBLACION ENTRE 18 Y 44 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido5=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido5_pr, replace
**44 a mas
$originales_pr
import delimited "PBLO RICO_E POBLACION MAYORES DE 45 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
destring peso, replace
destring talla, replace
gen m2=talla/100
gen imc_corregido=peso/(m2^2)
gen desnutrido6=(imc_corregido<20)
collapse (sum) desnutrido, by(idh)
$intermedias_pr
save desnutrido6_pr, replace
**
$intermedias_pr
use desnutrido1_pr, clear
merge 1:1 idh using desnutrido2_pr, nogen
merge 1:1 idh using desnutrido3_pr, nogen
merge 1:1 idh using desnutrido4_pr, nogen
merge 1:1 idh using desnutrido5_pr, nogen
merge 1:1 idh using desnutrido6_pr, nogen
egen n_desnutridos=rowtotal(desnutrido*)
save desnutridos_pr, replace ////Base final
//VACUNAS\\********************************************************************
**numero de niños vacunados o porcentaje sobre el total de niños
**por cada tipo
$originales_pr
import delimited "PBLO RICO_E MENORES 1 AÑO 01012012 A 31122017.csv", clear
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
$intermedias_pr
save vacunas1_pr, replace
**numero de niños vacunados con todas las vacunas*********************************
$originales_pr
import delimited "PBLO RICO_E NIÑOS ENTRE 1 Y 5 AÑOS 01012012 A 31122017.csv", clear
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
 $intermedias_pr
 save vacunas2_pr, replace
 *******************************************************************************
$originales_pr
import delimited "PBLO RICO_E NIÑOS ENTRE 6 Y 10 AÑOS 01012012 A 31122017.csv", clear
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
 $intermedias_pr
save vacunas3_pr, replace
*******************************************************************************
$originales_pr
import delimited "PBLO RICO_E JOVENES ENTRE 11 Y 17 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen vph=(vph_1_dosis=="1 - Si")
gen todas_v=(vph)
collapse (sum) vph todas_v, by(idh)
 foreach var in vph todas_v{
 rename `var' `var'4
 }
 $intermedias_pr
save vacunas4_pr, replace
*************************MERGE********************************************
use vacunas1_pr, clear
merge 1:1 idh using vacunas2_pr, nogen
merge 1:1 idh using vacunas3_pr, nogen
merge 1:1 idh using vacunas4_pr, nogen
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
**Estimacion indice usando PCA*
*Se observa que la variable que no esta muy correlacionada con el resto es vph
*La vacunacion del virus del papiloma humano no sigue las demas vacunaciones
pca tbc hepatitis polio pentavalente rotavirus neumococo influenza ///
amarilla dtp vph
predict indicador_vacunacion_menores, score
gen tiene_hijo=1
$intermedias_pr
save vacunas_pr, replace
********************************************************************************
$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
keep if edad<=17
**NRO DE MENORES DE EDAD por hogar
gen n_menores=1
collapse (sum) n_menores, by(idh)
$intermedias_pr
save n_menores_pr, replace
******////MIEMBROS
$originales_pr
import delimited "PBLO RICO_A IDENTIFICACION 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
**NRO DE MENORES DE EDAD por hogar
gen n_miembros=1
collapse (sum) n_miembros, by(idh)
$intermedias_pr
save n_miembros_pr, replace
*********************ENFERMEDADES DE LOS MAYORES********************************
$originales_pr
import delimited "PBLO RICO_E POBLACION ENTRE 18 Y 44 AÑOS 01012012 A 31122017.csv", clear
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
$intermedias_pr
save enfermedades1_pr, replace
********************************************************************************
$originales_pr
import delimited "PBLO RICO_E POBLACION MAYORES DE 45 AÑOS 01012012 A 31122017.csv", clear
duplicates drop vivienda_id_ familia_id persona_nro, force
egen id=concat(vivienda_id_ familia_id persona_nro)
egen idh=concat(vivienda_id_ familia_id)
gen diabetes2=(diabetes=="1 - Si con control" | diabetes=="2 - Si sin control")
gen hipertension2=(hipertension=="1 - Si con control" | hipertension=="2 - Si sin control")
gen dislipidemia2=(dislipidemia=="1 - Si con control" | dislipidemia=="2 - Si sin control")
gen renal2=(renal=="1 - Si con control" | renal=="2 - Si sin control")
gen epoc2=(epoc=="1 - Si con control" | epoc=="2 - Si sin control")
collapse (sum) diabetes2 hipertension2 dislipidemia2 renal2 epoc2, by(idh)
$intermedias_pr
save enfermedades2_pr, replace
********************************************************************************
use enfermedades1_pr, clear
merge 1:1 idh using enfermedades2_pr, nogen
egen diabetes=rowtotal(diabetes*)
egen hipertension=rowtotal(hipertension*)
egen dislipidemia=rowtotal(dislipidemia*)
egen renal=rowtotal(renal*)
egen epoc=rowtotal(epoc*)
keep idh diabetes hipertension dislipidemia renal epoc
pca diabetes hipertension dislipidemia renal epoc
predict indicador_enfermedad_mayores, score
save enfermedades_pr, replace
  **mas indicadores pueden ser porcentaje por hogar o porcentaje por barrio/vecindad
**mortalidad (indicadores personas muertas por hogar)
*18 a mas: indicador numero de personas enfermas
**porcentaje sobre el total del hogar 
*numero con cada tipo de enfermedad por hogar
a
********************************************************************************
**************************union bases de datos**********************************
$intermedias_pr
use hogar1_pr, clear
*seguros del mismo hogar pero no la misma persona
merge m:1 idh using discapacidad_pr, keep(1 3) nogen
merge m:1 idh using gestante_pr, keep(1 3) nogen
merge m:1 idh using hogar2_pr, keep(1 3) nogen
merge m:1 idh using hogar3_pr, keep(1 3) nogen
merge m:1 idh using vacunas_pr, keep(1 3) nogen
merge m:1 idh using enfermedades_pr, keep(1 3) nogen
merge m:1 idh using n_menores_pr, nogen
replace n_menores=0 if missing(n_menores)
merge m:1 idh using n_miembros_pr, nogen
replace tiene_hijo=0 if missing(tiene_hijo)
 
global xvar riqueza2-riqueza5 a1-a2 casa_propia pared_cemento grieta ///
desague_alcantarillado ///
agua_acueducto agua_tratada piso_madera_buena techo_bueno cielo_r s_energia ///
 s_gas s_recoleccion s_telefono ///
 ne3-ne6 ocupado mujer ///
 discapacidad gestante apoyo_social esp_comunitarios
 **HECKMAN
probit tiene_hijo $xvar
predict xb, xb
gen lambda0= normalden(xb)/normal(xb)
logit riesgo $xvar indicador_vacunacion_menores lambda0
drop xb lambda0

 



logit riesgo $xvar indicador_vacunacion_menores
predict pr_logit, pr
margins, dydx(*) post
outreg2 using marginal_effects, excel dec(3) replace

gmentropylogit riesgo $xvar, gen(pr_melogit) mfx
outreg2 using marginal_effects, excel dec(3) append

**predicciones tablas
gen riesgo_logit=(pr_logit>0.5)
gen riesgo_melogit=(pr_melogit>0.5)

tab riesgo riesgo_logit
tab riesgo riesgo_melogit

sum riesgo $xvar



