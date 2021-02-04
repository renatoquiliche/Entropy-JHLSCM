****************Estimacion modelo logit y entropia******************

clear all

global originales cd "C:\Users\user\Desktop\Paper Entropía - Revisión\datos\originales"
global intermedias cd "C:\Users\user\Desktop\Paper Entropía - Revisión\datos\intermedias"
global outputs cd "C:\Users\user\Desktop\Paper Entropía - Revisión\datos\outputs"


$outputs
use base_estimaciones_revision, clear

*gen ne5_6=(ne5==1 | ne6==1)
*gen riqueza4_6=(riqueza4==1 | riqueza5==1 | riqueza6==1)

*save base_sensibilidad, replace
global covariables comuna1-comuna23

**

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

****************** Estimation de distribucion de probabilidades por distritos******************
keep pr_deslizamiento pr_inundacion pr_colapso com*

cd "C:\Users\user\Desktop\Paper Entropía - Revisión\datos\outputs\entropia cruzada"

foreach comu in comuna1 comuna2 comuna3 comuna4 comuna5 comuna6 comuna7 comuna8 comuna9 comuna10 comuna11 comuna12 comuna13 comuna14 comuna15 comuna16 comuna17 comuna18 comuna19 comuna20 comuna21 comuna22 comuna23 comuna24{
preserve
keep if `comu'==1

export excel using prob_dist_`comu'.xlsx, firstrow(variables) replace
restore
}