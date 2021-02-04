****************Estimacion modelo logit y entropia******************

clear all

global originales cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\originales"
global intermedias cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\intermedias"
global outputs cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\outputs"


$outputs
use base_estimaciones_revision, clear

global covariables comuna1-comuna23

mca d_prips-mujer $indicador_morbilidad ne1 ne2 ne3 ne4 ne5_6 riqueza1 riqueza2 ///
riqueza3 riqueza4_6 d_n_miembros, dim(2)

corr	riesg_deslizamiento riesg_inundacion riesg_colapso d1 d2 ///
		d_prips-mujer $indicador_morbilidad ne1 ne2 ne3 ne4 ne5_6 riqueza1 riqueza2 ///
		riqueza3 riqueza4_6 d_n_miembros
		
matrix	CM=r(C)
matrix	EM=CM[1..86,1..5]

putexcel 	set Endogenity_analysis, modify sheet("Sheet1")
putexcel	B2=matrix(EM)
***RIQUEZA 5 Y 6 PREDICEN FALLO COMPLETAMENTE

logit riesg_deslizamiento d1-d2 ///
$covariables riesg_inundacion riesg_colapso, cluster(com)
estimates store deslizamiento
																					estat clas
outreg2 using results_logit, excel dec(3) replace ctitle("Deslizamientos")
predict pr_deslizamiento

logit riesg_inundacion d1-d2 ///
$covariables riesg_deslizamiento riesg_colapso, cluster(com)
estimates store inundacion
																					estat clas
outreg2 using results_logit, excel dec(3) append ctitle("Inundaciones")
predict pr_inundacion

logit riesg_colapso d1-d2 ///
$covariables riesg_inundacion riesg_deslizamiento, cluster(com)
estimates store colapso
																					estat clas
outreg2 using results_logit, excel dec(3) append ctitle("Colapsos")
predict pr_colapso

order	riesg_deslizamiento riesg_inundacion riesg_colapso d1 d2 ///
		d_prips-mujer $indicador_morbilidad ne1 ne2 ne3 ne4 ne5_6 riqueza1 riqueza2 ///
		riqueza3 riqueza4_6 d_n_miembros, first
		
global	instruments d_prips ///
		d_prcaseta_comunal ///
		d_priglesia ///
		d_prsitio_esparcimiento ///
		d_prmejoramiento ///
		d_prr_vecinos ///
		d_prg__tercera_edad ///
		d_prg__actividad_fisica ///
		d_prg__oracion ///
		d_prg__veeduria ///
		d_prg__ecologico ///
		d_prg__juvenil ///
		d_prg__otro ///
		d_prmedica ///
		d_prodontologica ///
		d_prpsicologica ///
		d_proporcion_diabetes ///
		d_proporcion_hipertension ///
		d_proporcion_dislipidemia ///
		d_proporcion_renal ///
		d_proporcion_epoc ///
		d_discapacidad_miembro ///
		d_gestante ///
		d_proporcion_desnutridos ///
		casa_propia ///
		techo_barro ///
		agua_tratada ///
		reservorio_agua ///
		techo_bueno ///
		cielo_r ///
		alumbrado_electricidad ///
		pres_humo ///
		cocina_aislada1 ///
		cocina_aislada2 ///
		nevera ///
		almc_alimentos_toxic ///
		alm_residuos_adecuado ///
		disp_residuos_adecuado ///
		reusa_residuos ///
		residuos_separados_fuente ///
		s_energia ///
		s_gas ///
		s_recoleccion ///
		s_telefono ///
		s_alcantarillado ///
		s_acueducto ///
		almc_quimicos_adecuado ///
		almac_medicamentos_adecuado ///
		cons_medicamentos_adecuado ///
		revisa_medicamentos_adecuado ///
		muerte_enfermedad ///
		muerte_incidental_delito ///
		ocupado ///
		convcas ///
		mujer ///
		infectado_eta ///
		infectado_ira ///
		infectado_eda ///
		infectado_tuberculosisolepra ///
		infectado_malaria ///
		infectado_diabetesmellitus ///
		infectado_cancermen18 ///
		infectado_chikungunya ///
		infectado_sintomresp ///
		infectado_otracual ///
		ne1 ///
		ne2 ///
		ne3 ///
		ne4 ///
		ne5_6 ///
		riqueza1 ///
		riqueza2 ///
		riqueza3 ///
		riqueza4_6
asd
		putexcel set endogenity_tests_entropy, modify

ivprobit riesg_deslizamiento   ///
$covariables  riesg_inundacion riesg_colapso ///
(d1 d2 = $instruments), first
local		chi2_exog_wald=e(chi2_exog)
estimates store iv_deslizamiento

probit riesg_deslizamiento d1-d2 ///
$covariables riesg_inundacion riesg_colapso, 
estimates store noiv_deslizamiento

hausman iv_deslizamiento noiv_deslizamiento, equations(1:1) //No cumple los supuestos asintóticos del test de hausman
suest	iv_deslizamiento noiv_deslizamiento, vce(cluster com)
test	[iv_deslizamiento_riesg_deslizami  = noiv_deslizamiento_riesg_desliza ], cons //Hay endogeneidad significativa
local		chi2_hausman=r(chi2)

putexcel	A1="Floods and colapses endogenous to landsildes" A2="Wald test" B2=`chi2_exog_wald' ///
			A3="Hausman test" B3=`chi2_hausman'
********
ivprobit riesg_inundacion ///
$covariables riesg_deslizamiento riesg_colapso  ///
(d1 d2 = $instruments), first 
local		chi2_exog_wald=e(chi2_exog) 
estimates store iv_inundacion

probit riesg_inundacion d1-d2 ///
$covariables riesg_deslizamiento riesg_colapso, 
estimates store noiv_inundacion

hausman iv_inundacion noiv_inundacion, equations(1:1) //No cumple los supuestos asintóticos del test de hausman
local		chi2_hausman=r(chi2)
*suest	iv_inundacion noiv_inundacion, vce(cluster com)
*test	[iv_deslizamiento_riesg_deslizami  = noiv_deslizamiento_riesg_desliza ], cons //Hay endogeneidad significativa


putexcel	A4="Landslides and colapses endogenous to floods" A5="Wald test" B5=`chi2_exog_wald' ///
			A6="Hausman test" B6=`chi2_hausman'
********
ivprobit riesg_colapso d1 d2  ///
$covariables   ///
( riesg_inundacion riesg_deslizamiento = $instruments), first 
local		chi2_exog_wald=e(chi2_exog)
estimates store iv_colapso

probit riesg_colapso d1-d2 ///
$covariables riesg_inundacion riesg_deslizamiento, 
estimates store noiv_colapso

hausman iv_colapso noiv_colapso, equations(1:1) //No cumple los supuestos asintóticos del test de hausman
suest	iv_colapso noiv_colapso, vce(cluster com)
test	[iv_colapso_riesg_colapso   = noiv_colapso_riesg_colapso ], cons //Hay endogeneidad significativa
local		chi2_hausman=r(chi2)


putexcel	A7="Landslides and colapses endogenous to floods" A8="Wald test" B8=`chi2_exog_wald' ///
			A9="Hausman test" B9=`chi2_hausman'
			
******************************************************
foreach dis in deslizamiento colapso{
estimates 	restore iv_`dis'
estat clas
local iv_ppv=r(P_1n)
local iv_npv=r(P_0n)

estimates 	restore noiv_`dis'
estat clas
local noiv_ppv=r(P_1n)
local noiv_npv=r(P_0n)
}
putexcel set endogenity_tests_entropy, modify sheet(Sheet2)
putexcel A1=`iv_ppv' B1=
