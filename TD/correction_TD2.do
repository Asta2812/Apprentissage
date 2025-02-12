
	* global wrk /Users/paolavillar/Dropbox/Teaching/UdeParis/M2_Econometrie_Avancee/Slides/Chapitre 3/data0/
	*global wrk C:\Users\PhuongLe\Dropbox\PC (2)\Mes cours\Evaluation d'impact 2024\TD2\TD2
	
*****************************************
*** Chap 3 : Estimation des modèles de panel vu en cours ***
*****************************************
* regarder si les données sont cylindré ou pas 
xtdescribe 
* la base de donnéer est bien cylindré car on a au moin 6 observations dans chaque pays

	* Exercice 1.
	* -----------
	*1/ Chargez la base de données wbdecade2.dta et créez log(GNI). 

		use "${wrk}/data0/wbdecade2.dta" , clear


* effet du PIB sur l'espérance de vie
	
		gene lnGNI = log(GNI)
		label var lnGNI "log(GNI)"
		
**** Les modèles que nous allons estimer s'attachent à étudier comment lnGNI affecte lifex
		
	*2/ - Calculer les estimateurs MCO :
		*(a) par décennie
		*(b) poolée 
		*(c) poolée avec des tendances temporelles (dummies)
		*(d) poolée en interagissant les variables de temps avec lnGNI
		*(e) Que concluez-vous?

		*(a)
		xtset id decade 
		xtdescribe
		* 1960-2010 , 51 periodes, 94 fully balanced
		* on s'attend à quel lien entre ln pib et life expectancy? relation linéaire ?
		* relation positive mais plus forte pour les pays avec un faible PIB: forme log lineaire: explique p e^tre prquoi la relation plus forte pr les anciennes cohortes
		* -> car pays étaient moins riches il y a plusieurs décennies
		forvalues t = 1960(10)2010 {
		reg lifex lnGNI if decade==`t'
		est sto m_`t'
		}
		* la commade "es tab" permet de rappeler tout les resultas des colonnes estimées
		
		
		est tab m_* , b(%9.3f) stats(N r2_a) star(.1 .05 .01)
		* b(%9.3f) : 9 characterers and three decimals , f for numeric formar
		*(b)
		reg lifex lnGNI
		est sto pool
		
		*(c)
		reg lifex lnGNI i.decade
		est sto pool_t
		
		*(d) Avec le terme d'intéraction l'effe est poisitif et significatif  ==> elle permt de distinguer aussi l'effet du PIB pour chaque decennies 
		
		reg lifex c.lnGNI##i.decade
		est sto pool_x
		est tab m_1960 pool*, b(%9.3f) stats(N r2_a) star(.1 .05 .01)
* Avec la regression poolé, ona pas de varition dans le temps
* intuitivement on  doit voir que l'effe temps -est positif est significative mais le tableau montre uyn resultast contradcitoire
* Donc il ya une correlation entre le PIB et l tendance de temps
		** (a) suggère que 
		** 		en etudiant les constantes : l'esperance de vie mpyenne s'améliore dans le temps
		** 		l'effet de la richesse sur lifex est plus fort dans les années 1960 et diminue graduellement dans le temps de 8,8 à 5,4
		** (b) ne tient pas compte de cette heterogeneité temporelle, et trouve un effet moyen de 6 
		** (c) l introduction des tendances temporelles permettent de tenir compte des changements temporels de l'esperance de vie : ici TCEPA en moyenne, cette tendance est négative
		******  comment expliquer cela? Peut etre que la richesse n'a pas le meme effet selon les decennies comme vu en a)
		** (d) semble confirmer cette intuition et nous retrouvons les résultats de a/
		** Il faut donc prendre en compte la structure de panel des ces données ! 




*3/ - Calculer les estimateurs suivants  (attention aux corrections des écarts-types)
	*en utilisant la commande Stata
	*retrouvez les résultats "à la main" en applicant les transformations correspondantes (sauf pour le Random Effect estimator, plus délicat... en bonus si vous avez le temps!)
		xtset id decade
		
	* -Between estimator on calcul la moyenne des valaurs au sein des individus
	

		** Stata
		xtreg lifex lnGNI ,  be	
		est sto be
		** A la main
		
			cap drop m_*
			foreach v in lifex lnGNI {
			 egen m_`v'=mean(`v') , by(id)
			}
			preserve
			duplicates report id decade
			duplicates drop id,force
			reg m_lifex m_lnGNI 
			est sto be_main
			restore

		est tab be be_main, b(%9.3f) se(%9.3f) stats(N r2_a) 

	
				
	* -  First Difference estimator (FD) 
		
		** Stata
		sort id decade
		cap drop t
		egen t=group(decade)
		
		xtset id t
		regress D.(lifex lnGNI)	, vce(cluster id)
		est sto fd
		
		
		** A la main
		cap drop d_*
		by id (decade), sort: gen d_lifex = (lifex[_n]-lifex[_n-1])
		by id (decade), sort: gen d_lnGNI = (lnGNI[_n]-lnGNI[_n-1])
		reg d_lifex d_lnGNI , vce(cluster id)  noconstant 
		est sto fd_main1
		
		est tab fd fd_main1 , b(%9.3f) se(%9.3f) stats(N r2_a) 



	* -  Within - Fixed Effects estimator (FE)
	
		*  Least Squares Dummy Variables (LSDV)		
		reg lifex lnGNI  i.id, vce(cluster id)
		est sto LSDV
	
		** Stata
		xtset id decade
		xtreg lifex lnGNI  , fe vce(cluster id)  
		est sto FE
	
		** A la main
		*cap drop fe_*
		gen fe_lifex=lifex-m_lifex
		gen fe_lnGNI=lnGNI-m_lnGNI
		reg fe_lifex fe_lnGNI, vce(cluster id)  
		est sto FE_main

		est tab LSDV FE FE_main, b(%9.3f) se(%9.3f) stats(N r2_a) keep(lnGNI fe_lnGNI)

		
	*  Random effect estimator (RE)
		
		* RE Stata's package
		xtreg lifex lnGNI, re theta vce(cluster id)  
		est sto RE		
		
		*  Pooled estimator
		reg lifex lnGNI, vce(cluster id)
		est sto pool
	
	
*4/ - Comparez les résultats (coeff et écarts-types)
	
		est tab  fd LSDV  FE be pool  RE, b(%9.3f)  se(%9.3f) stats(N) drop(i.id _cons)
		* Pourquoi les coefficients de FD et FE sont differents?




			* Exercice 2.
	* -----------
	*1/ Chargez la base de données nlswork417.dta. 

		
****  A partir de données de panel, nous allons estimer différents modèles, et chercher à identifier le plus pertinent.
     * Dans chaque modèle nous régresserons le salaire  (wage) sur l'âge (age), le fait d'être syndicalisé (union), l'ancienneté du contrat (tenure), et le fait de vivre au sud (south)

/* Rappels: 

Modèle panel: y_it=x'_it beta + alpha_i + e_it
                  =x'_it beta + v_it
			avec v_it= alpha_i + e_it
			
Hypothèse du modèle RE: 
E(alpha_i)/x_i1,....,xiT)=	E(alpha_i)=0
Les caractéristiques inobservables constants au cours du temps ne sont pas corrélés au regresseur. Cela implique que: 
E(e_it^2)=sigma_e
E(alpha_i^2)=sigma_alpha
-> variance homscedastique qui ne dépend pas des xiT
Si les hypothèses du modèle RE sont vérifiées, le modèle FE et le modèle RE devrait être similaires (convergent) et les plus efficaces: les constantes individuelles rentrent dans le terme d'erreur
Si les hypothèses ne sont pas vérifiées, les modèles divergent.

Interpretations: 
- sigma e: estimation de la variance d'epsilon
- sigma u: estimation de la variance d'alpha
- rho: fraction de la variabilité lié à alpha 
*/

 
	*2/ - Estimation des modèles suivant à partir des commandes regress, xtreg, estimates store et estimates table, se
		*(a) Pooled estimator
		
		*(b) Random effect estimator (RE)
	
	*3/ Comparez les résultats (coeff et écarts-types). Qu'en déduisez-vous sur la validité du modèle RE? Comment interpréter les coefficients sigma? 

	*4/ Estimer les modèles suivants:
		*(a) Fixed Effects estimator (FE)
		*(b) First Difference estimator (FD)
	
	*5/ Comparez les résultats (coeff et écarts-types).
	
	*6/ A partir de la commande hausman, en déduire si le modèle RE est valide. 
		
	
	*2-3
	use "$wrk/data_nc471/nlswork471", clear
	xtset 
	reg wage age i.south i.union tenure, vce(robust)	
	xtreg wage age i.south i.union tenure, vce(robust)
	estimates store re

	xtreg wage age i.south i.union tenure
	estimates store re2
	regress wage age i.south i.union tenure, vce(cluster idcode)
	estimates store pooled
	estimates table re re2 pooled, b(%9.3f)  se(%9.3f) stats(N)  

* coefficients différents: proabablement existe une constance, et de plus modèle RE probablement pas satisfaits. Doit faire un test pour savoir si cette différence statistiquement significative


    *4-5
	xtreg wage age i.south i.union tenure, fe 
	estimates store fe
	regress D.(wage age south union tenure), noconstant noheader
	estimates store difference

	estimates table fe difference, se

	hausman fe re2, sigmamore
* Si les hypothèses de RE sont vérifiées, le modèle RE et FE devraient être similaires, mais le modèle RE devrait être plus efficace
* le test est la différence au carrés des coefficients divisé par la variance des 2 estimateurs
* on rejette le test: les coefficients sont différents
* autrment dit, les effets indivduels sont  corrélées aux variables explicatives
* on en deduit que le modèle FE est plus approprié
	
	/*
	   b = Consistent under H0 and Ha; obtained from xtreg.
           B = Inconsistent under Ha, efficient under H0; obtained from xtreg.

Test of H0: Difference in coefficients not systematic

    chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
            = 189.55
Prob > chi2 = 0.0000

*/
	
	
	
	
	
	
	
	
	
	
	
	
