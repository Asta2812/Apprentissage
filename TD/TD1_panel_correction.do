                                                                           /*********************************************************************************************


		Author:  Esther Delesalle

	------------------------------------------------------------------
		   Prise en main de Stata 
	------------------------------------------------------------------

* Raccourcis clavier 	(Sous Windows)

	-----------------
		CTRL+L: Stata sélectionne la ligne sur laquelle est le curseur
	
		CTRL+D : Stata execute la partie du texte selectionne 
	

**********************************************************************************************/
* log using journal , replace text // enregistre tout ce qui apparait dans la fenetre de sortie
* log close

		quietly {                      
			// ne fait pas apparaitre l'outcomes des commandes de la boucle
		clear *						// supprimer tout ce qui se trouve en memoire
		set mem 512m				// augmenter la memoire disponible
		set mat 800					// agmenter le nbr variables (800 = max. sous Stata IC)
		set more off, perma			// ne pas interrompre le deroulement des progr. par -more-
		noi di "{hline}"			// tracer un trait dans la fenetre de sortie

		noi di as res "Aujourd'hui : " c(current_date)  _col(50) "Ouverture de cette session à " c(current_time) // tableaux à 2 colonnes : date et heure pour le journal
	 * col 50 pour mieux aligner: séparer en 2 le tableau
		noi di "{hline}"			// tracer un trait dans la fenetre de sortie
				}

**************************
*** START PROGRAM HERE ***
**************************


	* Define paths to files
global chemin C:\Users\edelesalle\Dropbox\Cours IEDES\Evaluation d'impact\TD	/*chemin où se trouve ma base de données*/



***************************************
*** Session 1 : Introduction aux données de panel
***************************************


	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 1 : Format long/wide - et commandes xt
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------

	*1 : Charger la base de données "nls417.dta"
	use "$chemin/TD2/data_nc471/nlswork471.dta", clear


	*2 : Description de la base de données
		* a/ Décrivez la base de données : variables,  nombre d'observations, unité d'observation
		* b/ Quelles variables varient dans le temps?
		* c/ Quel est le format de cette base?
		* d/ Quels sont les identifiants

	* a/ 
	describe 
	summarize 
	* 28,534 observations et 28 variables. L'unité d'observation est l'individu: Femmes âgées de 14-26 ans en 1968: 
	*Certaines variables sont spécifiques à des années données (1968 à 1988): 
	** wage :salaire
	**wks_work : nombre d'heures
	** occ_code occupation
	**ind_code : secteur d'acitivté
	** msp: situation maritalz
	
	* b/ d'autres invariantes : année de naissance, années d'education et etre noir/blanc ou autre  (birth_yr grade race respectivement)
	
	* c/ Format panel long : 1 ligne 1 observation
	* 1 femme observée chaque année de 1968 à 1988
	* un peu plus loin: combien d'observations et combien d'année?
	codebook idcode year
	*4,711  femmes sur 15 ans: N grand et T petit
	* variables identifiantes
	
	* d/ identifiants: idcode year
	sort idcode year
	br idcode year wage grade south 
	list idcode year wage grade south if inrange(idcode,1,10)
	
	*3. Long --> Wide :
	* a/ Passez la base en en format wide. 
	* b/ Commentez.
	 reshape wide age msp nev_mar c_city south ind_code occ_code union wks_ue ttl_exp tenure hours wks_work wage neighborhood agesq  not_smsa unsouth untenure, i(idcode) j(year)
	* voit que si sélectionne pas toutes les variables qui changent dans le temps : le passage ne s'opère pas
	* pas pratique à utiliser car bcp de variables varient dans le temps: pas très pratique 

	*4. Données Wide
	* Les données panel ne sont pas toujours organisées de façon à être directement exploitées
	* a/ Ouvrir la base "reshapewage.dta"
	* b/ Observez la structure des donneés. Commentez.
	* c/ Quel est l'identifiant? 
	* d/ Passer cette base en format long. Comment le nombre d'observations a-t-il évolué ? 
	* e/ Effectuer la même procédure à partir de la base "wide"
	
	* a/
	use "$chemin/TD2/data_nc471/reshapewage.dta", clear
	
	* b/ list, noobs
	reshape long wage south, i(idcode) j(year)
	/* 	grade ne bouge pas donc qu'une variables
	pour le salaire et localisation, change chaque année donc une variable par année */
	 list, noobs
	 
	 
	 * e/
	 use "$chemin/TD2/data_nc471/wide.dta", clear
	 reshape long wage exper inlf manuf, i(id) j(year 81 82 83 84 85 86 87)
	* Important de mettre les années dans j quand pas il y a des sauts, pas régulier, etc

    *5 : A partir de la base nlswork471 en format long:
		* a/ Déclarez la structure de panel de vos données
		* b/ Décrivez vos données avec la commande xtdescribe
		* c/ Analysez la décomposiion de la variance pour chaque variable avec la commande xtsum
		* d/ Tabulez la variable msp, south, union et race avec la commande xttab et xtrans
		
	* a/
	use "$chemin/TD2/data_nc471/nlswork471.dta", clear
	xtset idcode 
	* stata reconnait que l'on a des données de pane: 
	xtset idcode year // idcode = identifiant individuel , year = identifiant temporel ; 
	/*Panel variable: idcode (unbalanced)
	 Time variable: year, 1968 to 1988, but with gaps
			 Delta: 1 unit
	 Détermine la vairable temporelle */ 
	xtset idcode year, yearly
	* determine l'écart entre chaque vague
	* unblanced: pas d'info à chaque vague pour tous les individus
	
	* b/
	xtdescribe // on retrouve ce que l'on a observé précédemment : T=15 périodes, n= 4711 , delta = 1 :1 unité d'intervalle entre deux dates, sur 21 ans: années vides

	// Distribution des T_i: le type de pattern: quand les observations sont observées.
	* voit que plusieurs "patterns" différents: observations pas observées nécesssairement aux mêmes années
	
	* c/
	xtsum
	/*Certaines variables n'ont pas de 
	: - variance within : nous dit quelle  variables pour un même individu au cours du temps*variable birth_yr, race, grade: ces variables ne varient pas d'une période à l'autre
	Cette commande nous permet de regarder le poids relatif de la variable within par rapport à between:
	- ex : pour wage, la variance totale est  expliquée autant par la variable between entre individus que par la within (1256.639 /  1163: un peu plus entre les individus)*/
   * the between mean, ranges from 0 to 19,768
   *The within value, on the other hand, informs us about how the average demeaned wages are shifted from zero to the sample mean.
   
   /*Pourquoi la somme totale de la variance n'est pas égale à la variance between+ within? 
   - Lorsque le panel est cylindré: 
   Seulement lié au fait que la variance reportée est la variance corrigée des biais en multipliant par n/(n-1), Il suffit donc pour retrouver la vraie variance de multiplier par n-1/n (si on part de l'écart type on multiplie par  racine((n-1)/n)
   - Lorsque le panel n'est pas cylindré:
   1. le même problème de variance ajusté se pose
   2. La moyenne totale est différentes de la moyenne des moyenne between et cela biaise le résultat
   Moyenne du panel (between): moyenne pas pondérée, donne le même poids à chaque individu
   Moyenne échantillon: moyenne pondérée et dépend donc du nombre d'observation par individus
   */
   
   * d/
	xttab msp
	/*- permet d'étudier la dynamique de la variable: 
	Interprétation si l'on considère que l'unité d'observation est l'individu-année alors 60% de l'échantillon est marié à au moins une dates
	* nb observations supérieur au nombre d'indiv dans la base car certains individus peuvent être observés selon la vague, marié ou non marié
	-   3113 individus ont au moins une fois pas été mariées et  3643   ont au moins une fois été mariés
	- parmi les individus observés mariés, 76% de chance de les observer mariés
	- parmi les individus non mariés: 63% de chance de les voir non mariés */
	
	xttab south
	* 41 % des indiv vivent au sud qq soit la période
	* parmi  indiv 	au sud, 87% de les observer vivant au sud
	* 46 % des indiv ont vécus au moins une fois au sud (66 au nord)
	* parmi indiv observés une fois dans le sud: 87 % de chance que ces individus soient obsérver dans le sud
	Autrement dit: conditionnellement au fait d'être observé une fois dans le sud, la proba que ce même individu soit observé dans le sud est de 87%
	/*
					  Overall             Between            Within
		south |    Freq.  Percent      Freq.  Percent        Percent
	----------+-----------------------------------------------------
			0 |   16843     59.04      3104     65.89          91.50
			1 |   11683     40.96      2147     45.57          87.14
	----------+-----------------------------------------------------
		Total |   28526    100.00      5251    111.46          89.72
								  (n = 4711)
	*/

    xttrans south
	* Matrice de transition: éléments en diagonal
	/*-parmi ceux vivant en dehors du sud à n'importe quelle date, 97.27% des individus restent en dehors
	-parmi ceux vivant auu sud, 96.29% restent au sud à l'année T+1
	t
			   |      1 if south
	1 if south |         0          1 |     Total
	-----------+----------------------+----------
			 0 |     97.27       2.73 |    100.00 
			 1 |      3.71      96.29 |    100.00 
	-----------+----------------------+----------
		 Total |     58.76      41.24 |    100.00 

		*/
	
	 xttab union
     /*  76% observations ne sont pas syndicalisés.
	 * - parmi ceux que l'on observe non syndicalisés, 86.5% des fois que l'on observe, tjs non syndicalisés
	 *- parmi ceux que l'on observe syndicalisés, 54.4% des fois que l'on observe, ces individus sont syndicalisés
	 * persistance plus importantes des non syndicalisés que des syndicalisés
	 * 3765 individu qui a au moins une date, n'étaient pas syndicalisé
	 *1641 individus qui a au moins une date étaient syndicalisés
                  Overall             Between            Within
    union |    Freq.  Percent      Freq.  Percent        Percent
----------+-----------------------------------------------------
        0 |   14728     76.56      3765     90.72          86.50
        1 |    4510     23.44      1641     39.54          54.44
----------+-----------------------------------------------------
    Total |   19238    100.00      5406    130.27          76.77 */
                        
						
	xttrans union
    /*
           |      1 if union
1 if union |         0          1 |     Total
-----------+----------------------+----------
         0 |     90.76       9.24 |    100.00 
         1 |     27.13      72.87 |    100.00 
-----------+----------------------+----------
     Total |     74.88      25.12 |    100.00 
	parmi les indiv non syndicalisés, 91% d'entre eux on le les voit pas syndicalisés90% à l'année t+1
	parmi indiv syndicalisé, 73 de chance de les voir syndicalisés à la date t+1 */

     xttab race
	 * normal qu'il y ait aucune variation within
	 
	 
	 
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 2 : Panel cylindrés, non cylindrés
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	
	/* Les bases suivantes sont-elles cylindrées? Justifiez votre réponse 
	a/ pig (webuse )
	b/ nlswork471 */
	
	* a/
	webuse pig, clear
	xtset id week /*balanced*/
	xtdes /*ok*/ 
	*les 48 observations sont observées à chaque fois aux 9 périodes
	
	
	* b/
	use "$chemin/nlswork471", clear
	xtset idcode year /*unbalanced*/
	xtdes /*attrition et renouvellement : panel rotatif*/ 
	
	

		* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	* Exercice 3 : Rappel: régressions linéaires et validité des hypothèses 
	* ---------------------------------------------------------------------------------------------------
	* ---------------------------------------------------------------------------------------------------
	
	
	*1. Ouvrir la base nlswork471. 
	* a/ On suppose que le salaire individuel dans la base "nlswork471", wage, dépend du niveau d'éducation (grade), du fait d'être syndicalisé (union), de l'éthnicité (race) et de variables inobservables. Comment cette relation s'écrit-elle ?
	* b/ Quelles hypothèses le modèle OLS fait-il ? 
	* d/ Représenter graphiquement la régression pour les individus noirs syndicalisés. L'hypothèse d'homoscédasticité est-elle vérifiée ? 
	* e/ En cas de violation de l'hypothèse d'homoscédasticité, quelle hypothèse alternative peut-on faire? 
	* f/ Comparer les régressions supposant 1.l'homoscédasticité 2. l'hétéroscédasticité des termes d'erreur. Que concluez-vous?
	* g/ Supposons maintenant que le salaire dépend également de l'ancienneté du contrat (tenure). A l'aide de la commande margins, estimer l'effet marginal de tenure? 
	* Dans un second temps, ajouter un terme d'interaction entre l'ancienneté du contrat et le fait d'être syndicalisé. L'effet marginal évolue-t-il?
	
	
	* a/ 
	use "$chemin/nlswork471", clear
	* wagei= b_0 +b_1 grade + beta_2 union + b3_black + b_4 other race + epsilon_i
	reg wage grade union race2 race3 
	reg wage grade union ib2.race

	* b/  Hypothèses:
	/*
	- Le modèle est linéaire dans ses paramètres 
	- échantillonage aléatoire de la population
	- pas de colinéarité parfaite entre les variables explicatives
	- E(ei/xi)=0
	partie non observée n'explique pas les salaires et pas corrélées aux variables explicatives 
	- E(Ei^2/xi)=sigma^2
	* variablilité des termes d'erreur est la même et est constante (égale à sigma2) qq soit le niveeau des variables explicatives: homocédasticité */
	
	* d/  E(wage/grade, union==1, race==2)= b_0 +b_1 grade + beta_2  + b3 on pose delta1= b0+ beta2+ beta3
	graph twoway (lfit wage grade if (union==1 & race==2))(scatter wage grade if (union==1 & race==2))
	
	*. rejette hypothèse d'homoscédasticité: vairance change selon la valeur de Xi: grade. 

	* e/ vce(robust) vce(cluster variables_xi) : tolère hétéroscadasticité: option des variances correcte en supposant que E(e_i^2/x_i)=sigma^2(x_i): 
	* on suppose que la variance dépend de la valeur des variables indépendantes xi: prend en compte cette hétérocédasticité pour calculer variance correcte 

	* f/	
	regress wage i.south grade i.union i.race
	estimates store hom
	regress wage i.south grade i.union i.race, vce(robust)
	estimates store het
	estimates table hom het, se
	
 	* g/
	regress wage i.south grade i.union tenure i.race, vce(robust)
	estimates store nointerac
	margins, dydx(tenure)
	* effet marginal équivalent effet moyen car relation linéaire

	regress wage grade i.union##c.tenure i.race, vce(robust)
	estimates store intera
	margins if union==1, dydx(tenure)
	margins if union==0, dydx(tenure)
	margins, dydx(tenure) at(union=(0 1))
	 * peut calculez effet marginal pour chaque groupe 