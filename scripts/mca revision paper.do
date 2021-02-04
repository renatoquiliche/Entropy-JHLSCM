*****************************Aplicacion del metodo MCA**************************
********************	Written by: Renato Quiliche    *************************

clear all

global originales cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\originales"
global intermedias cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\intermedias"
global outputs cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\outputs"

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

***Numero de miembros mayor a 4 punto de corte
gen d_n_miembros=(n_miembros>=4)

*****************MODELO MCA*********************
gen ne5_6=(ne5==1 | ne6==1)
gen riqueza4_6=(riqueza4==1 | riqueza5==1 | riqueza6==1)


label define d_prips 0 "No IPS" 1 "Yes IPS"
label values d_prips d_prips

label define d_prcaseta_comunal 0 "No ComunalHut" 1 "Yes ComunalHut"
label values d_prcaseta_comunal d_prcaseta_comunal

label define d_priglesia 0 "No Church" 1 "Yes Church"
label values d_priglesia d_priglesia

label define d_prsitio_esparcimiento 0 "No Recreational Areas" 1 "Yes Recreational Areas"
label values d_prsitio_esparcimiento d_prsitio_esparcimiento

label define d_prmejoramiento 0 "No Neighborhood Improvement" 1 "Yes Neighborhood Improvement"
label values d_prmejoramiento d_prmejoramiento

label define d_prr_vecinos 0 "No Neighbours Socialization" 1 "Yes Neighbours Socialization"
label values d_prr_vecinos d_prr_vecinos

label define d_prg__tercera_edad 0 "No Elderly Group Activities" 1 "Yes Elderly Group Activities"
label values d_prg__tercera_edad d_prg__tercera_edad

label define d_prg__actividad_fisica 0 "No Group Physical Activities" 1 "Yes Group Physical Activities"
label values d_prg__actividad_fisica d_prg__actividad_fisica

label define d_prg__oracion 0 "No Prayer Groups" 1 "Yes Prayer Groups"
label values d_prg__oracion d_prg__oracion

label define d_prg__veeduria 0 "No Monitoring Groups" 1 "Yes Monitoring Groups"
label values d_prg__veeduria d_prg__veeduria

label define d_prg__ecologico 0 "No Ecological Groups" 1 "Yes Ecological Groups"
label values d_prg__ecologico d_prg__ecologico

label define d_prg__juvenil 0 "No Youth Groups" 1 "Yes Youth Groups"
label values d_prg__juvenil d_prg__juvenil

label define d_prg__otro 0 "No Other Groups" 1 "Yes Other Groups"
label values d_prg__otro d_prg__otro

label define d_prmedica 0 "No Medical Attention" 1 "Yes Medical Attention"
label values d_prmedica d_prmedica

label define d_prodontologica 0 "No Odontological Attention" 1 "Yes Odontological Attention"
label values d_prodontologica d_prodontologica

label define d_prpsicologica 0 "No Psychological Attention" 1 "Yes Psychological Attention"
label values d_prpsicologica d_prpsicologica

label define d_proporcion_diabetes 0 "No Diabetes" 1 "Yes Diabetes"
label values d_proporcion_diabetes d_proporcion_diabetes

label define d_proporcion_hipertension 0 "No Hypertension" 1 "Yes Hypertension"
label values d_proporcion_hipertension d_proporcion_hipertension

label define d_proporcion_dislipidemia 0 "No Dyslipidemia" 1 "Yes Dyslipidemia"
label values d_proporcion_dislipidemia d_proporcion_dislipidemia

label define d_proporcion_renal 0 "No Kidney Disease" 1 "Yes Kidney Disease"
label values d_proporcion_renal d_proporcion_renal

label define d_proporcion_epoc 0 "No COPD" 1 "Yes COPD"
label values d_proporcion_epoc d_proporcion_epoc

label define d_discapacidad_miembro 0 "No With Disability" 1 "Yes With Disability"
label values d_discapacidad_miembro d_discapacidad_miembro

label define d_gestante 0 "No Expectant Mother" 1 "Yes Expectant Mother"
label values d_gestante d_gestante

label define d_proporcion_desnutridos 0 "No Undernourished" 1 "Yes Undernourished"
label values d_proporcion_desnutridos d_proporcion_desnutridos

label define casa_propia 0 "No Own House" 1 "Yes Own House"
label values casa_propia casa_propia

label define vivienda_casa 0 "No Properly Constructed" 1 "Yes Properly Constructed"
label values vivienda_casa vivienda_casa

label define pared_cemento 0 "No Block/Brick in Walls" 1 "Yes Block/Brick in Walls"
label values pared_cemento pared_cemento

label define grieta 0 "No Cracks in Walls" 1 "Yes Cracks in Walls"
label values grieta grieta

label define desague_alcantarillado 0 "No Toilet Aqueduct" 1 "Yes Toilet Aqueduct"
label values desague_alcantarillado desague_alcantarillado

label define agua_acueducto 0 "No Aqueduct" 1 "Yes Aqueduct"
label values agua_acueducto agua_acueducto

label define sanitario_dentro 0 "No Toilet Inside" 1 "Yes Toilet Inside"
label values sanitario_dentro sanitario_dentro

label define techo_barro 0 "No Roof of Mud, Plastic or Iron" 1 "Yes Roof of Mud, Plastic or Iron"
label values techo_barro techo_barro

label define agua_tratada 0 "No Treated Water" 1 "Yes Treated Water"
label values agua_tratada agua_tratada

label define reservorio_agua 0 "No Water Reservoir" 1 "Yes Water Reservoir"
label values reservorio_agua reservorio_agua

label define techo_bueno 0 "No Good Roof" 1 "Yes Good Roof"
label values techo_bueno techo_bueno

label define cielo_r 0 "No Ceiling" 1 "Yes Ceiling"
label values cielo_r cielo_r

label define alumbrado_electricidad 0 "No Electric Lighting" 1 "Yes Electric Lighting"
label values alumbrado_electricidad alumbrado_electricidad

label define pres_humo 0 "No Smoke Presence" 1 "Yes Smoke Presence"
label values pres_humo pres_humo

label define cocina_aislada1 0 "No Kitchen and Bedroom Together" 1 "Yes Kitchen and Bedroom Together"
label values cocina_aislada1 cocina_aislada1

label define cocina_aislada2 0 "No Kitchen and Bathroom Together" 1 "Yes Kitchen and Bathroom Together"
label values cocina_aislada2 cocina_aislada2

label define nevera 0 "No Refrigerator" 1 "Yes Refrigerator"
label values nevera nevera

label define almc_alimentos_toxic 0 "No Food Storage with Toxic Products" 1 "Yes Food Storage with Toxic Products"
label values almc_alimentos_toxic almc_alimentos_toxic

label define alm_residuos_adecuado 0 "No Good Waste Storage" 1 "Yes Good Waste Storage"
label values alm_residuos_adecuado alm_residuos_adecuado

label define disp_residuos_adecuado 0 "No Good Waste Disposal" 1 "Yes Good Waste Disposal"
label values disp_residuos_adecuado disp_residuos_adecuado

label define reusa_residuos 0 "No Waste Recycle" 1 "Yes Waste Recycle"
label values reusa_residuos reusa_residuos

label define residuos_separados_fuente 0 "No Waste Isolated" 1 "Yes Waste Isolated"
label values residuos_separados_fuente residuos_separados_fuente

label define s_energia 0 "No Energy Service" 1 "Yes Energy Service"
label values s_energia s_energia

label define s_gas 0 "No Gas Service" 1 "Yes Gas Service"
label values s_gas s_gas

label define s_recoleccion 0 "No Waste Collection Service" 1 "Yes Waste Collection Service"
label values s_recoleccion s_recoleccion

label define s_telefono 0 "No Telephone Service" 1 "Yes Telephone Service"
label values s_telefono s_telefono

label define s_alcantarillado 0 "No Sewer Service" 1 "Yes Sewer Service"
label values s_alcantarillado s_alcantarillado

label define s_acueducto 0 "No Aqueduct Service" 1 "Yes Aqueduct Service"
label values s_acueducto s_acueducto

label define almc_quimicos_adecuado 0 "No Good Chemicals Storage" 1 "Yes Good Chemicals Storage"
label values almc_quimicos_adecuado almc_quimicos_adecuado

label define almac_medicamentos_adecuado 0 "No Good Medicines Storage" 1 "Yes Mecines Storage"
label values almac_medicamentos_adecuado almac_medicamentos_adecuado

label define cons_medicamentos_adecuado 0 "No Good Medicine Consumption" 1 "Yes Good Medicine Consumption"
label values cons_medicamentos_adecuado cons_medicamentos_adecuado

label define revisa_medicamentos_adecuado 0 "No Expiration Checking on Drugs" 1 "Yes Expiration Checking on Drugs"
label values revisa_medicamentos_adecuado revisa_medicamentos_adecuado

label define muerte_enfermedad 0 "No Death by Disease" 1 "Yes Death by Disease"
label values muerte_enfermedad muerte_enfermedad

label define muerte_incidental_delito 0 "No Death by Accident/Murder" 1 "Yes Death by Accident/Murder"
label values muerte_incidental_delito muerte_incidental_delito

label define ocupado 0 "No Employed" 1 "Yes Employed"
label values ocupado ocupado

label define convcas 0 "No Married/Cohabiting" 1 "Yes Married/Cohabiting"
label values convcas convcas

label define mujer 0 "No Woman as Head of Household" 1 "Yes Woman as Head of Household"
label values mujer mujer

label define infectado_cancermen18 0 "No Cancer in a Young Member" 1 "Yes Cancer in a Young Member"
label values infectado_cancermen18 infectado_cancermen18

label define infectado_chikungunya 0 "No Chikungunya" 1 "Yes Chikungunya"
label values infectado_chikungunya infectado_chikungunya

label define infectado_diabetesmellitus 0 "No Diabetes" 1 "Yes Diabetes"
label values infectado_diabetesmellitus infectado_diabetesmellitus

label define infectado_eda 0 "No ADIs" 1 "Yes ADIs"
label values infectado_eda infectado_eda

label define infectado_eta 0 "No Foodborne Illness" 1 "Yes Foodborne Illness"
label values infectado_eta infectado_eta

label define infectado_ira 0 "No ARTIs" 1 "Yes ARTIs"
label values infectado_ira infectado_ira

label define infectado_malaria 0 "No Malaria" 1 "Yes Malaria"
label values infectado_malaria infectado_malaria

label define infectado_otracual 0 "No Other Illness" 1 "Yes Other Illness"
label values infectado_otracual infectado_otracual

label define infectado_sintomresp 0 "No Respiratory Disease" 1 "Yes Respiratory Disease"
label values infectado_sintomresp infectado_sintomresp

label define infectado_tuberculosisolepra 0 "No Tuberculosis/Leprosis" 1 "Yes Tuberculosis/Leprosis"
label values infectado_tuberculosisolepra infectado_tuberculosisolepra

label define ne1 0 "No Household Head Uneducated" 1 "Yes Household Head Uneducated"
label values ne1 ne1

label define ne2 0 "No Household Head with Primary" 1 "Yes No Household Head with Primary"
label values ne2 ne2

label define ne3 0 "No Household Head with Secondary" 1 "Yes Household Head with Secondary"
label values ne3 ne3

label define ne4 0 "No Household Head with Technical Degree" 1 "Yes Household Head with Technical Degree"
label values ne4 ne4

label define ne5_6 0 "No Household Head with Bachelor/Doctor Degree" 1 "Yes Household Head with Bachelor/Doctor Degree"
label values ne5_6 ne5_6

label define riqueza1 0 "No Poorest" 1 "Yes Poorest"
label values riqueza1 riqueza1

label define riqueza2 0 "No Poor" 1 "Yes Poor"
label values riqueza2 riqueza2

label define riqueza3 0 "No Medium Poor" 1 "Yes Medium Poor"
label values riqueza3 riqueza3

label define riqueza4_6 0 "No Medium/Rich/Richest" 1 "Yes Medium/Rich/Richest"
label values riqueza4_6 riqueza4_6

label define d_n_miembros 0 "No <4 Members per Household" 1 "Yes <4 Members per Household"
label values d_n_miembros d_n_miembros


mca d_prips-mujer $indicador_morbilidad ne1 ne2 ne3 ne4 ne5_6 riqueza1 riqueza2 riqueza3 riqueza4_6 d_n_miembros, dim(2)
*ne1-ne6 riqueza1-riqueza6 n_miembros

screeplot, 	lwidth(thin) xlab(, nogrid labsize(small)) ylab(, nogrid labsize(small)) ///
			msymbol(X) msize(medlarge) graphregion(color(white)) ///
			title("Scree plot of principal inertias after MCA", size(medium))
asd
mcaplot, legend(off) overlay scale(0.9) maxlength(1) ///
xline(0, lcolor(black%40) lpattern(dash)) yline(0, lcolor(black%40) lpattern(dash)) ///
mlabcolor(black) mcolor(black) msize(vsmall) graphregion(color(white)) mlabsize(zero) ///
msymbol(Oh) ///
xlab(-15(1)5, nogrid labsize(small)) ylab(-10(1)5, nogrid labsize(small)) ///
xtitle("D1 (Wealth: assets, household status, services, morbidity)", size(medsmall)) ///
ytitle("D2 (Chronic diseases and related social support groups)", size(medsmall)) ///
title("", size(small)) ///
note("", size(vsmall)) ///
text(2 -9 "Morbidity, Bad Household Status", place(n) size(small)) ///
text(2 2 "Good Household Status and Wealth", place(n) size(small)) ///
text(5 1 "No Social Capabilities/No Soft Medical Care", place(w) size(small)) ///
text(-8 1 "Chronic Diseases and Social Capabilities", place(w) size(small)) 



predict d1 d2, rowscores
*foreach dim in d3 d5{
*replace `dim'=-1*`dim'
*}
******************** CORRELACION DE LAS DIMENSIONES
forvalues i=1/2{
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
matrix D1_5=D1,D2
matrix list D1_5
*sig
matrix S1_5=S1,S2

putexcel set MCA_correlation_results, replace sheet("coef")
$outputs
save base_estimaciones_revision, replace

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
sleep 100
putexcel G`i'=`i'-1
}

