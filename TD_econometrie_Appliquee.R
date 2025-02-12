# Séance 1 économétrie appliqué 02/10/24

# PRB : CALCUL D'effet moyen du traitement (génération des données)
# step1 : generer un échantillon d'observation avec assignation du traitement 
# identifier l'effet causal su traitement
# generer 100 observationd yoi, yo1, assignation du traitemnt(aléatoire ou non aléatoire) ==> identi de l'effe causaul du traitemnt

# step2 : identification de l'effet causal du traitement dans le cadre de la regression linéaire

# Installation des packages 
install.packages(c("tidyverse", "ggplot2", "dplyr"))

# Importation des packages 
library(tidyverse)
library(ggplot2)
library(dplyr)
library(dplyr)

# Création d'un échantillon de 100 
n <- 100

# les resultats de Y0 sous les resultats réels sous controle
set.seed(1234) # genration de nombre pseudo aléatoire


data <- tibble(
  Y0 = rnorm(n, mean=0, sd=1)) # avec varible de resultats qui suit une loi normal
# génération de la variable de traitement 
data <- data %>% 
  mutate(Y1 = rnorm(n,mean=0, sd=1)
  )


# Assignation aléaoire du traitement ou du controle aux individus
# calculer l'effet causalul du traitement
# comparer avec la vrai valaur de l'effet du traitement Y1 ET Y

## step 2

#creer deux valeurs possibles et se mettre à la place d'une assignation aléatoire', 

# creer la variable de traiteent et la varible de resultats observé yi = diYi +(1-d1)yoi
# création d'une variable binaire pour le traitement

data<-
  data <- data %>%
  mutate(D = rbinom(n, 1, 0.5)) # regle d'association et d'assignation aléatoire à probabilité 0.5

# effet causal du traitement sur les traités ATT


effet_causal_traite <- mean(data$Y1[data$D == 1] - data$Y0[data$D == 1])

# interpretation de l'effet causaul du traitement sur les traités ou effet moyen du traitement sur les traités
# le traitement à réduit de -0.2593472 la valeur de Y par rapport à ce qui aurait été sans traitement 
# Un résultat de -0.2593472 signifie que, en moyenne, le traitement a réduit le résultat de 0.259 unités par rapport à ce qu'il aurait été sans traitement.
# Les individus qui ont bénéficier du programme ont un y inférieur par rapport à ceux qui n'ont pas participé
# création d'une variable de resultats observé. 

data <- data %>%
  mutate(Y_obs = D * Y1 + (1 - D) * Y0)


# séance du 10 octobre, méthodologie de la resolution du TD
# comment l'hypoth d'assignation aléatoire permt d'indentifier l'effet causal cad l'ffeet du traotement
#  l'idée simuler les resultas potentiel avec ous an traiteent et comment l'hyp causal permt d'identifier l'effet moyen du traitement 
# Donc generer les reusltas potentiel sur un échantillon yoi et y1i (la differnce donne l'effet causal du traitement),
# ensuite de simuler une expérience aléatoire et regarder le role du caractere aléaoite
 # Avec les resultats, on essaie d'estimer l'effet moyen du traitent cad rho
# Après comparer le rho de notre expérience avec le vrai rho simuler à partir de notre fausse données
# Apres vérifier que le rho correspond à notre effet idendividuel


## correction de l'exercice de la séance

# simuler une expérience aléatoire / non aléatoire pour visualiser 
set.seed(1234)
 # declarer le nombre d'observation 
n<- 100

data_sim_2 <- tibble(
  YO = rnorm(n, mean=0, sd=1),
  Y1 = rnorm(n, mean=2, sd=1),
  D = rbinom(n, 1, 0.5)
)
 # graphique sur les données de l'assignation aléatoire 
plot(data_sim$D) # prend deux valeurs 
hist(data_sim$D)

# l'effet moyen du traitement sur les traités 

# calculer le y observer , reveler certains des resultats potentiel 
# les reusltas potentiel correspondant à l'assignation au traitement
data_sim <- data_sim %>%
  mutate(Y_obs = D * Y1 + (1 - D) * YO)

# Calcul de l'effet moyen du traitement sur les traités,
# Moyenne des y_obs conditionnelemnt aux niveau du traitement E(yobs/D=1) - E(Yobs/D=1) =rho

myobs0 <- mean(data_sim$Y_obs[data_sim$D == 0]) 
myobs1 <- mean(data_sim$Y_obs[data_sim$D == 1]) # la moyenne des valeurs possibles 

# Identification de l'effet du traitement sur les traités 
# Calcul du rho de l'expérience 

# ATT, l'effet moyen du traitement sur les traités 
myobs1 - myobs0

# Quelle est la vrai valeur de l'effet du traitement 
# le traitemebnt apporte en moyenne une reduction de 

# regression linéaier sous R , pourquoi faire une regression linéaire?
# c'est une autre maniere de calculer l'effet du traitement sur les traités 

# écrire la regresion , on observe jmais les resultats potentiel lm(y,tilde D, data= data_sim)

# representation de deux variables dans le datafRAME
plot(data_sim$Y_obs)

# representation graphique

ggplot(data_sim) +
  aes(x=D, y=Y_obs) +
  geom_point()

# boxplot des différentes valeurs observées en fonction du traitement 

# Visualiser les distriburuin des valaurs observées  les histogrammes

# Modèle de regression linéaire, la cinstante est la moyenne du resuktat observé sous le controle
# la constante est la moyenne des individu controle

lm(Y_obs ~ D, data=data_sim)

# on peut identofoer l'effet causal car on a une affectation alatoire, l'effet du traitelent sur els reuslts est de45?5
# les ind traités ont une un resultas de 45 5 superieur aux individus controle

# il existe à l'intérier des indivis l'info supplemantaire, comparer l'effet individuel du traitement et m'effet moyen assigner grace aux traitement
# l'effet individuel du traitemlent permet de voir les heterogeneité entre lesindovidus
# permet de voir la diff entre l'estmation de l'effet moyen (le coeff de D) et la difference caché entre les individus

data_sim <- data_sim %>% 
  mutate(
    rhoi= Y1 - YO # effet individuel du traitement
  )

ggplot(data_sim) +
  aes(x=rhoi) +
  geom_density(alpha=0.5) + 
  theme_minimal()

# moyenne de la diff de resultat potentile indivuel (y1-y0), c'est la moyenne d'une difference de resukts potentiel
mean(data_sim$rhoi) # c'est la moyenne d'une difference de resultats potentiels

# TAF prochaine séance création d'une assignation non aléaoire 

data_sim_2 <- tibble(
  YO = rnorm(n, mean = 0, sd = 1),
  Y1 = rnorm(n, mean = 1, sd = 2)
)

# Assigner D de manière non aléatoire en fonction de YO
data_sim_2 <- data_sim_2 %>%
  mutate(D = ifelse(YO > 0, 1, 0))

# calcul des valeurs observée
data_sim_2 <- data_sim_2 %>%
  mutate(Y_obs = D * Y1 + (1 - D) * YO)
data_sim_2
# Effet moyen du traitement ATE

m_Y0 <- mean(data_sim_2$Y_obs[data_sim_2$D == 0]) 
m_Y1 <- mean(data_sim_2$Y_obs[data_sim_2$D == 1]) 

m_Y1 - m_Y0

# regression linéaire 
model <- lm(Y_obs ~ D, data=data_sim_2)
summary(model) # coefficient du model de regression linéaire

#  les distributions de YO et Y1 selon D
ggplot(data_sim_2, aes(x = Y_obs, fill = factor(D))) +
  geom_histogram(alpha = 0.7, position = "identity", bins = 20) +
  scale_fill_manual(values = c("blue", "red"), labels = c("Contrôle (D=0)", "Traitement (D=1)")) +
  labs(
    title = "Distribution des valeurs observées selon le groupe de traitement",
    x = "Valeur observée (Y_obs)",
    y = "Fréquence",
    fill = "Groupe"
  ) +
  theme_minimal()

 # différence entre les individus yo et yobs
ggplot(data_sim_2, aes(x = YO, y = Y_obs, color = factor(D))) +
  geom_point(size = 3, alpha = 0.7) +
  labs(
    title = "Valeurs observées selon le statut de traitement",
    x = "Valeur initiale (YO)",
    y = "Valeur observée (Y_obs)",
    color = "Groupe (0 = Contrôle, 1 = Traitement)"
  ) +
  scale_color_manual(values = c("blue", "red"), labels = c("Contrôle (D=0)", "Traitement (D=1)")) +
  theme_minimal()


# y1 - yobs sachant d=1 et sachant d=0
ggplot(data_sim_2, aes(x = Y1, y = Y_obs, color = factor(D))) +
  geom_point(size = 3, alpha = 0.7) +
  labs(
    title = "Valeurs observées selon le statut de traitement",
    x = "Valeur initiale (YO)",
    y = "Valeur observée (Y_obs)",
    color = "Groupe (0 = Contrôle, 1 = Traitement)"
  ) +
  scale_color_manual(values = c("blue", "red"), labels = c("Contrôle (D=0)", "Traitement (D=1)")) +
  theme_minimal()

# conclusion
# il a des dofference entre les indivuds 


# verofocation des hypothèses de tendances parrallèlle

# Simulation des données avec une valeur avant le traitement
data_DD <- tibble(
  YO_pre = rnorm(n, mean = 0, sd = 1),  # Valeur avant le traitement
  YO_post = YO_pre + rnorm(n, mean = 0.5, sd = 1), # Valeur après le traitement pour le groupe de contrôle
  Y1_post = YO_pre + rnorm(n, mean = 1, sd = 1)  # Valeur après le traitement pour le groupe de traitement
)

# Assignnation aléatoire du traitement
data_DD <- data_DD %>%
  mutate(D = rbinom(n, 1, 0.5)) %>%
  mutate(Y_obs_post = D * Y1_post + (1 - D) * YO_post)

# Calculer les moyennes par groupe et période
summary_data <- data_DD %>%
  group_by(D) %>%
  summarise(
    mean_YO_pre = mean(YO_pre),
    mean_YO_post = mean(YO_post),
    mean_Y1_post = mean(Y1_post),
    mean_Y_obs_post = mean(Y_obs_post)
  )

# Créer le graphique DID
ggplot(data_DD, aes(x = factor(D), color = factor(D))) +
  geom_point(aes(y = YO_pre), position = position_dodge(width = 0.2), size = 3, alpha = 0.7) +
  geom_point(aes(y = Y_obs_post), position = position_dodge(width = 0.2), size = 3, alpha = 0.7) +
  geom_line(aes(y = YO_pre, group = D), linetype = "dashed", size = 1) +
  geom_line(aes(y = Y_obs_post, group = D), size = 1) +
  scale_color_manual(
    values = c("blue", "red"),
    labels = c("Contrôle (D=0)", "Traitement (D=1)")
  ) +
  labs(
    title = "Vérification de l'hypothèse de tendances parallèles (Assignation Aléatoire)",
    x = "Groupe (0 = Contrôle, 1 = Traitement)",
    y = "Valeur",
    color = "Groupe"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14),
    legend.position = "bottom"
  )



## Essaie sur les problèmes de covariables 






