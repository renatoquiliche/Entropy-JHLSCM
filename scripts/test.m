clear all
cd 'C:\Users\user\Desktop\Paper Entropía - Revisión\datos\outputs\Entropia cruzada'

%We create a matrix in where we output the results for 24 districts
%results = zeros(24,2);

for x=1:1:24
comuna1 = readtable(sprintf('%s%d.xlsx','prob_dist_comuna',x));
zona_urbana_pueblorico = comuna1.pr_deslizamiento;

P = vertcat(zona_urbana_pueblorico);

%Parametros de la simulaciön distribución normal
%Distribucion de bajo riesgo, reflejado por una baja vulnerabilidad
mu=0.05;
sigma=0.01;

Q = normrnd(mu,sigma,[length(P),1]);

%P = sort(P)
%Kullback leibler calculation
KL = P.*log2(P./Q);
KL = sum(KL);

results1(x,1) = sprintf('%s%d','prob_dist_comuna',x)
results2(x,2) = KL

KL
sprintf('%s%d.xlsx','prob_dist_comuna',x)
end


