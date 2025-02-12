* CORRIGER DU TD 


        * Author:  Esther Delesalle


* Spécification du chemin d'accès 
cd "/Users/astaoliviaouattara/Downloads/TD1/"
use nlswork471.dta, clear



***************************************
*** Session 1 : Introduction aux données de panel
***************************************


	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 1 : Format long/wide - et commandes xt
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------

	*1 : Charger la base de données "nlswork47.dta"
use nlswork471.dta, clear

	*2 : Description de la base de données
		* a/ Décrivez la base de données : variables,  nombre d'observations, unité d'observation( voir rapport PDF)

describe
summarize
 

		* b/ Quelles variables varient dans le temps?
xtset id year
xtdescribe


		* c/ Quel est le format de cette base?
* Si chaque ligne represente une observation sur plusieurs periode alors c'est long sinon c'est wide

		* d/ Quels sont les identifiants
xtset

	*3. Long --> Wide :
	* a/ Passez la base en en format wide. 

reshape wide age msp nev_mar grade collgrad not_smsa c_city south ind_code occ_code union wks_ue ttl_exp tenure hours wks_work wage neighborhood agesq race1 race2 race3 unsouth untenure, i(idcode) j(year)


	* b/ Commentez (voir Rapport PDF).
	
	*4. Données Wide
	* Les données panel ne sont pas toujours organisées de façon à être directement exploitées
	* a/ Ouvrir la base "reshapewage.dta"
use reshapewage.dta, clear

	* b/ Observez la structure des donneés. Commentez.
describe
browse

	* c/ Quel est l'identifiant? 
	* identifiant est idcode
	
	* d/ Passer cette base en format long. Comment le nombre d'observations a-t-il évolué ? 
	
reshape long age msp nev_mar grade collgrad not_smsa c_city south ind_code occ_code union wks_ue ttl_exp tenure hours wks_work wage neighborhood agesq race1 race2 race3 unsouth untenure, i(idcode) j(year)

	* e/ Effectuer la même procédure à partir de la base "wide.dta"
use wide.dta, clear
reshape long wage exper manuf inlf, i(id) j(year)

	
    * 5 : A partir de la base "nlswork471.dta" en format long:
		* a/ Déclarez la structure de panel de vos données
xtset idcode year


		* b/ Décrivez vos données avec la commande xtdescribe
xtdescribe

		* c/ Analysez la décomposiion de la variance pour chaque variable avec la commande xtsum

xtsum birth_yr age race msp nev_mar grade collgrad not_smsa c_city south ind_code occ_code union wks_ue ttl_exp tenure hours wks_work wage neighborhood agesq race1 race2 race3 unsouth untenure



		* d/ Tabulez la variable msp, south, union et race avec la commande xttab et xtrans
		
xttab msp
xttab south
xttab union
xttab race
xttrans msp
xttrans south
xttrans union
xttrans race 
 
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 2 : Panel cylindrés, non cylindrés
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	
	/* Les bases suivantes sont-elles cylindrées? Justifiez votre réponse 
	a/ pig (utilisez la commande "webuse" pour obtenir cette base)*


* b/ nlswork471.dta */

webuse pig, clear
xtset id week
xtdescribe

*b / 

use nlswork471.dta, clear
xtset idcode year
xtdescribe







		* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 3 : Rappel: régressions linéaires et validité des hypothèses 
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	
	*1. Ouvrir la base "nlswork471.dta". 
	use "nlswork471.dta", clear

	* a/ On suppose que le salaire individuel dans la base "nlswork471.dta", wage, dépend du niveau d'éducation (grade), du fait d'être syndicalisé (union), de l'éthnicité (race) et de variables inobservables. Comment cette relation s'écrit-elle ?
	* b/ Quelles hypothèses le modèle MCO fait-il ? 
	* d/ Représenter graphiquement la régression pour les individus noirs syndicalisés. L'hypothèse d'homoscédasticité est-elle vérifiée ? 
reg wage grade if race == 2 & union == 1
rvfplot

	* e/ En cas de violation de l'hypothèse d'homoscédasticité, quelle hypothèse alternative peut-on faire? 
	* f/ Comparer les régressions supposant 1.l'homoscédasticité 2. l'hétéroscédasticité des termes d'erreur. Que concluez-vous?
	reg wage grade union race
	reg wage grade union race, robust


	* g/ Supposons maintenant que le salaire dépend également de l'ancienneté du contrat (tenure). A l'aide de la commande margins, estimer l'effet marginal de tenure? 
reg wage grade union race tenure
margins, dydx(tenure)

	* Dans un second temps, ajouter un terme d'interaction entre l'ancienneté du contrat et le fait d'être syndicalisé. L'effet marginal évolue-t-il?

reg wage grade i.union race tenure c.tenure#i.union
margins, dydx(tenure) at(union=(0 1))

	




