****************Estimacion modelo logit y entropia******************

clear all

global originales cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\originales"
global intermedias cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\intermedias"
global outputs cd "C:\Users\DELL\Desktop\Entropy - Revising - Secod round\Paper Entropía - Revisión\datos\outputs"


$outputs
use base_estimaciones_revision, clear

global covariables comuna1-comuna23

**Endogeneidad
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

*Hacemos las regresiones de la primera etapa
reg				d1 $instruments $covariables
predict			d1_resid, resid
predict			d1_hat, xb
reg				d2 $instruments $covariables
predict			d2_resid, resid
predict			d2_hat, xb

**Logit sin variables instrumentales

**Deslizamiento
logit			riesg_deslizamiento d1 d2 d1_resid d2_resid ///
				$covariables riesg_inundacion riesg_colapso, 

				test (d1_resid = 0) (d2_resid =0)
				local wald1=r(chi2)
**Inundacion
logit			riesg_inundacion d1 d2 d1_resid d2_resid ///
				$covariables riesg_deslizamiento riesg_colapso, 

				test (d1_resid = 0) (d2_resid =0)
				local wald2=r(chi2)
**Colapso
logit			riesg_colapso d1 d2 d1_resid d2_resid ///
				$covariables riesg_inundacion riesg_deslizamiento, 

				test (d1_resid = 0) (d2_resid =0)
				local wald3=r(chi2)
				
**Logit con variables instrumentales
logit			riesg_deslizamiento d1_hat d2_hat ///
				$covariables riesg_inundacion riesg_colapso
outreg2 using results_logit_iv, excel dec(3) replace ctitle("Deslizamientos")
estat clas		
				
logit			riesg_inundacion d1_hat d2_hat ///
				$covariables riesg_deslizamiento riesg_colapso, 
outreg2 using results_logit_iv, excel dec(3) append ctitle("Deslizamientos")
estat clas	
				
logit			riesg_colapso d1_hat d2_hat ///
				$covariables riesg_inundacion riesg_deslizamiento, 	
outreg2 using results_logit_iv, excel dec(3) append ctitle("Deslizamientos")				
estat clas	
				
**Logit sin IV
logit			riesg_deslizamiento d1_hat d2_hat ///
				$covariables riesg_inundacion riesg_colapso
predict			
				
logit			riesg_inundacion d1_hat d2_hat ///
				$covariables riesg_deslizamiento riesg_colapso, 

				
logit			riesg_colapso d1_hat d2_hat ///
				$covariables riesg_inundacion riesg_deslizamiento, 	
				
ttest			
				