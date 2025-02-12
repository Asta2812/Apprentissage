/*********************************************************************************************
	
		Author:  Esther Delesalle
	------------------------------------------------------------------
		  Panel data econometrics / Econométrie des données de panel
	------------------------------------------------------------------

**********************************************************************************************/

		qui {
		clear *						
		set mem 512m				
		set mat 800					
		set more off, perma			
		}



	* Define paths to files
    global chemin C:\Users\edelesalle\Dropbox\Cours IEDES\Evaluation d'impact\data_nc471	
	global wrk C:\Users\edelesalle\Dropbox\Cours IEDES\Panel\Cours Pao\Chapitre 3\data0
	

*****************************************
*** Chap 3 : Estimation des modèles de panel vu en cours ***
*****************************************


	* Exercice 1.
	* -----------
	*1/ Chargez la base de données wbdecade2.dta et créez log(GNI). 

		
**** Les modèles que nous allons estimer s'attachent à étudier comment lnGNI affecte lifex
		
	*2/ - Calculer les estimateurs MCO :
		*(a) par décennie
		*(b) poolée 
		*(c) poolée avec des tendances temporelles (dummies)
		*(d) poolée en interagissant les variables de temps avec lnGNI
		*(e) Que concluez-vous?

		
	*3/ - Calculer les estimateurs suivants (attention aux corrections des écarts-types)
		*en utilisant la commande Stata
		*retrouvez les résultats "à la main" en applicant les transformations correspondantes (sauf pour le Random Effect estimator, plus délicat... en bonus si vous avez le temps!)
			
		* - Between estimator	
		* - First Difference estimator (FD)
		* - Least Squares Dummy Variables (LSDV)		
		* - Fixed Effects estimator (FE)
		* - Random effect estimator (RE)
		* - Pooled estimator
		
	*4/ - Comparez les résultats (coeff et écarts-types)
		


	
	* Exercice 2.
	* -----------
	*1/ Chargez la base de données nlswork417.dta. 

		
****  A partir de données de panel, nous allons estimer différents modèles, et chercher à identifier le plus pertinent.
     * Dans chaque modèle nous régresserons le salaire  (wage) sur l'âge (age), le fait d'être syndicalisé (union), l'ancienneté du contrat (tenure), et le fait de vivre au sud (south)
	 
 
	*2/ - Estimation des modèles suivant à partir des commandes regress, xtreg, estimates store et estimates table, se
		*(a) Pooled estimator
		
		*(b) Random effect estimator (RE)
	
	*3/ Comparez les résultats (coeff et écarts-types). Qu'en déduisez-vous sur la validité du modèle RE? Comment interpréter les coefficients sigma? 

	*4/ Estimer les modèles suivants:
		*(a) Fixed Effects estimator (FE)
		*(b) First Difference estimator (FD)
	
	*5/ Comparez les résultats (coeff et écarts-types).
	
	*6/ A partir de la commande hausman, en déduire si le modèle RE est valide. 
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
