# 📊 JMAK - Johnson-Mehl-Avrami-Kolmogorov Kinetics Tools

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)
![Version](https://img.shields.io/badge/Version-1.1-green.svg)

Un package R moderne et accessible pour **modéliser et analyser les cinétiques de transformation** (cristallisation, réactions chimiques, polymérisation, etc.) en utilisant le modèle **JMAK/Avrami**.

---

## 📋 Table des matières

1. [📌 À propos](#à-propos)
2. [🚀 Installation](#installation)
3. [⚡ Démarrage rapide](#démarrage-rapide)
4. [📖 Guide complet](#guide-complet)
5. [🔧 Fonctions principales](#fonctions-principales)
6. [📊 Exemples pratiques](#exemples-pratiques)
7. [❓ FAQ](#faq)
8. [📞 Support](#support)

---

## 📌 À propos

### Qu'est-ce que le modèle JMAK?

Le modèle **Johnson-Mehl-Avrami-Kolmogorov (JMAK/Avrami)** décrit comment une transformation progresse dans le temps. Il s'exprime par :

$$Y(t) = 1 - \exp(-K \cdot t^n)$$

Où :
- **Y(t)** : fraction transformée (0 à 1)
- **K** : constante cinétique (vitesse de transformation)
- **n** : exposant d'Avrami (type de mécanisme : nucléation/croissance)
- **t** : temps

### À quoi ça sert?

✅ **Cristallisation de polymères** - Prédire la vitesse de cristallisation  
✅ **Réactions chimiques** - Modéliser la cinétique réactionnelle  
✅ **Transformations de phase** - Analyser les transitions cristallines  
✅ **Procédés industriels** - Optimiser les paramètres de transformation  

### Fonctionnalités du package

| Fonctionnalité | Description |
|---|---|
| 📥 **Import & Validation** | Nettoyage automatique des données expérimentales |
| 🔧 **Ajustement automatique** | Sélection intelligente entre régression linéaire et non-linéaire |
| 📊 **Diagnostiques complets** | métriques de qualité (R², RMSE, Cook's distance) |
| 🎨 **Visualisations** | 4 graphiques diagnostiques professionnels avec ggplot2 |
| ⏱️ **Prédictions** | Calcul de Y(t) et temps caractéristiques (t₅₀, t₉₀) |
| ✓ **Tests statistiques** | Normalité des résidus, autocorrélation, points influents |

---

## 🚀 Installation

Choisissez la méthode qui correspond à votre situation :

### **Méthode 1 : Installation locale (⭐ Recommandée pour les débutants)**

C'est la méthode la plus simple si vous avez le code source sur votre machine.

#### Étape 1 : Récupérer le code source

**Sur Windows :**
```cmd
cd C:\Users\VotreNom\Documents
git clone https://github.com/prunelleeba/JMAK-.git
```

**Sur Ubuntu/Linux/macOS :**
```bash
cd ~/Documents
git clone https://github.com/prunelleeba/JMAK-.git
```

> ⚠️ **Important** : Vous devez avoir `git` installé sur votre machine. Si vous ne l'avez pas :
> - **Windows** : Téléchargez depuis https://git-scm.com/download/win
> - **Ubuntu** : `sudo apt-get install git`
> - **macOS** : `brew install git`

#### Étape 2 : Ouvrir RStudio et installer depuis le dossier local

1. Ouvrez **RStudio**
2. Allez au menu **Tools** → **Install Packages...**
3. Dans **Install from**, sélectionnez : **Package Archive File (.tar.gz, .zip)**
4. Cliquez sur **Browse** et naviguez vers le dossier `JMAK` que vous venez de télécharger
5. Sélectionnez le fichier `JMAK_1.1.tar.gz`
6. Cliquez sur **Install**

Attendez quelques secondes, c'est fini ! ✅

**Alternative (sans GUI RStudio)** :

Dans la console R :
```r
install.packages("C:/Users/VotreNom/Documents/JMAK/JMAK_1.1.tar.gz", 
                 repos = NULL, 
                 type = "source")
```

### **Méthode 2 : Installation depuis le répertoire source (Développeurs)**

**Dans la console R, depuis le dossier du projet :**

```r
# Première installation (une seule fois)
install.packages(c("devtools", "ggplot2"))

# Charger le package en développement
devtools::load_all()

# OU installer directement
devtools::install()
```

### **Méthode 3 : Installation en ligne de commande (Terminal/PowerShell)**

**Windows (PowerShell) :**
```powershell
cd C:\Users\VotreNom\Documents\JMAK
R CMD INSTALL JMAK_1.1.tar.gz
```

**Linux/macOS :**
```bash
cd ~/Documents/JMAK
R CMD INSTALL JMAK_1.1.tar.gz
```

---

## ⚡ Démarrage rapide

### Installation des dépendances (première fois)

Dans la console R :
```r
# Installez les packages dépendants
install.packages(c("ggplot2", "patchwork"))
```

### Utilisation basique en 5 minutes

```r
# 1. Charger le package
library(JMAK)

# 2. Charger les données exemple
data(polymere_cristallisation)
head(polymere_cristallisation)

# 3. Ajuster le modèle JMAK
fit <- jmnak_fit_auto(
  t = polymere_cristallisation$t,
  Y = polymere_cristallisation$Y,
  verbose = TRUE
)

# 4. Récupérer les paramètres
K <- fit$parameters$K
n <- fit$parameters$n
cat("K =", K, ", n =", n, "\n")

# 5. Faire des prédictions
predictions <- jmnak_predict(
  t = seq(0.5, 30, 0.5),
  K = K,
  n = n,
  Ystar = c(0.5, 0.9)
)

# Afficher les temps caractéristiques
print(predictions$tstar)
```

**Résultat attendu :**
```
========================================================
JMAK MODEL FIT RESULTS
========================================================
FINAL PARAMETERS:
  K  = 0.02003 (rate constant)
  n  = 3.1948 (Avrami exponent)

FIT QUALITY METRICS:
  R² (original scale): 0.9856
  RMSE: 0.0189

========================================================
```

---

## 📖 Guide complet

### Installation détaillée pas à pas

#### **Pour débutants sous Windows**

1. **Installez Git** (si vous ne l'avez pas)
   - Allez sur https://git-scm.com/download/win
   - Téléchargez l'installeur (vert, à droite)
   - Double-cliquez et acceptez les paramètres par défaut
   - Redémarrez votre ordinateur

2. **Téléchargez le code du package**
   - Ouvrez **PowerShell** (Win + X, puis sélectionnez PowerShell)
   - Tapez :
   ```powershell
   cd C:\Users\VotreNom\Documents
   git clone https://github.com/prunelleeba/JMAK-.git
   cd JMAK
   dir  # Vérifiez que vous voyez le fichier JMAK_1.1.tar.gz
   ```

3. **Installez le package dans R**
   - Ouvrez **RStudio**
   - Copiez-collez dans la console :
   ```r
   install.packages("C:/Users/VotreNom/Documents/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```
   - Appuyez sur **Entrée** et attendez
   - Si aucune erreur, c'est installé ✅

4. **Vérifiez l'installation**
   ```r
   library(JMAK)
   data(polymere_cristallisation)
   fit <- jmnak_fit_auto(polymere_cristallisation$t, 
                         polymere_cristallisation$Y, 
                         verbose = FALSE)
   print(fit)
   ```

#### **Pour débutants sous Ubuntu/Linux**

1. **Installez Git** (si vous ne l'avez pas)
   ```bash
   sudo apt-get update
   sudo apt-get install git
   ```

2. **Téléchargez le code du package**
   ```bash
   cd ~/Documents
   git clone https://github.com/prunelleeba/JMAK-.git
   cd JMAK
   ls  # Vérifiez que vous voyez le fichier JMAK_1.1.tar.gz
   ```

3. **Installez le package dans R**
   - Ouvrez **RStudio** ou lancez `R` dans le terminal
   ```r
   install.packages("~/Documents/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```

4. **Vérifiez l'installation**
   ```r
   library(JMAK)
   data(polymere_cristallisation)
   fit <- jmnak_fit_auto(polymere_cristallisation$t, 
                         polymere_cristallisation$Y, 
                         verbose = FALSE)
   print(fit)
   ```

---

## 🔧 Fonctions principales

### 1️⃣ `jmnak_import_validate()` - Préparer les données

**Qu'est-ce que ça fait ?**
Nettoie, valide et normalise vos données expérimentales.

**Syntaxe :**
```r
df <- jmnak_import_validate(t, Y, clamp_low = 1e-6, clamp_high = 1-1e-6)
```

**Paramètres :**
| Paramètre | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Vecteur des temps (doivent être > 0) |
| `Y` | numeric | Vecteur des fractions transformées |
| `clamp_low` | numeric | Limite min pour Y (par défaut 10⁻⁶) |
| `clamp_high` | numeric | Limite max pour Y (par défaut 1-10⁻⁶) |

**Retour :**
Data.frame avec colonnes `t` et `Y` nettoyées

**Exemple :**
```r
# Données en pourcentages
t <- c(1, 2, 5, 10, 15)
Y <- c(2, 10, 35, 80, 95)  # Pourcentages

# Nettoyage automatique
df <- jmnak_import_validate(t, Y)
print(df)
# t     Y
# 1 0.02
# 2 0.10
# ...
```

**Qu'est-ce que cette fonction fait ?**
- ✅ Convertit les pourcentages (0-100) en fractions (0-1)
- ✅ Rejette les valeurs <= 0 ou >= 1 (non-physiques)
- ✅ "Clamp" les valeurs trop extrêmes
- ✅ Retourne un data.frame propre et prêt à l'emploi

---

### 2️⃣ `jmnak_fit_auto()` - Ajuster le modèle JMAK

**Qu'est-ce que ça fait ?**
C'est la **fonction principale**. Elle ajuste automatiquement le modèle JMAK à vos données en determininant les valeurs de la constante cinetique k et de l'exposant d'avrami n qui seront utilisees par la fonction jmnak_predict() pour predire les Y(t) ou les t .

**Syntaxe :**
```r
fit <- jmnak_fit_auto(t, Y, r2_threshold = 0.90, verbose = TRUE)
```

**Paramètres :**
| Paramètre | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Vecteur des temps (>0) |
| `Y` | numeric | Vecteur des fractions (0..1 ou 0..100) |
| `r2_threshold` | numeric | Seuil R² pour accepter la régression linéaire (défaut: 0.90) |
| `verbose` | logical | Afficher les résultats détaillés ? (défaut: TRUE) |

**Retour :**
Objet `jmnak_fit` contenant :
- `$parameters` : K, n, lnK
- `$confidence_intervals` : intervalles de confiance 95%
- `$fit_quality` : R², RMSE, MAE, etc.
- `$diagnostics` : points influents, résidus, tests statist.
- `$models` : modèles lm et nls utilisés

**Exemple complet :**
```r
# Données expérimentales
t <- c(0.5, 1, 2, 5, 10, 15, 20, 25)
Y <- c(0.01, 0.05, 0.15, 0.45, 0.75, 0.90, 0.96, 0.99)

# Ajustement
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)

# Récupérer les paramètres
K <- fit$parameters$K
n <- fit$parameters$n
R2 <- fit$fit_quality$r2_original

cat("Paramètres ajustés:\n")
cat("  K =", K, "\n")
cat("  n =", n, "\n")
cat("  R² =", R2, "\n")

# Affichage résumé
print(fit)
```

**Comment ça marche en arrière-plan ?**

1. **Nettoyage** : les données sont validées avec `jmnak_import_validate()`
2. **Linéarisation** : transformation en espace log-log
3. **Régression linéaire** : extraction des paramètres par moindres carrés
4. **Sélection** : si R² ≥ 0.90 et pas de points influents → utilise lm
5. **Sinon** : essaye la régression non-linéaire (nls)
6. **Comparaison** : si nls converge, compare les deux et choisit la meilleure
7. **Diagnostiques** : calcule 10+ métriques et tests statistiques
8. **Graphiques** : génère 4 plots de diagnostic avec ggplot2
9. **Résultat** : retourne l'objet complet

**Les graphiques générés :**
```
┌─────────────────────────┬──────────────────────────┐
│ JMAK Fit (Y vs t)       │ Avrami Linearization     │
│ Données + courbe ajustée│ Espace log-log           │
├─────────────────────────┼──────────────────────────┤
│ Résiduals vs Time       │ Cook's Distance          │
│ Points influents?       │ Diagnostic de robustesse │
└─────────────────────────┴──────────────────────────┘
```

---

### 3️⃣ `jmnak_predict()` - Faire des prédictions

**Qu'est-ce que ça fait ?**
Utilise les paramètres K et n pour prédire Y(t) et calculer les temps caractéristiques.

**Syntaxe :**
```r
pred <- jmnak_predict(t = NULL, K, n, Ystar = c(0.5, 0.9))
```

**Paramètres :**
| Paramètre | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Grille de temps pour prédictions (optionnel) |
| `K` | numeric | Constante cinétique ajustée |
| `n` | numeric | Exposant d'Avrami ajusté |
| `Ystar` | numeric | Fractions cibles (ex: 0.5, 0.9) |

**Retour :**
Liste avec :
- `$t` : grille de temps
- `$Y_pred` : prédictions Y(t)
- `$tstar` : temps caractéristiques

**Exemple :**
```r
# À partir d'un ajustement
K <- 0.02
n <- 3.2

# Prédire Y(t) et temps t₅₀, t₉₀
pred <- jmnak_predict(
  t = seq(0.5, 25, by = 0.5),
  K = K,
  n = n,
  Ystar = c(0.5, 0.9)
)

# Temps caractéristiques
print(pred$tstar)
# t_for_Y=0.5  t_for_Y=0.9 
#      3.654      10.295

# Courbe de prédiction
plot(pred$t, pred$Y_pred, type = "l", 
     xlab = "Temps", ylab = "Fraction transformée Y(t)")
```

**Calculs effectués :**

Pour chaque Y* dans Ystar, calcule :

$$t^* = \left(\frac{-\ln(1-Y^*)}{K}\right)^{1/n}$$

Exemple : temps pour Y = 50% et Y = 90% de transformation

---

### 4️⃣ `print.jmnak_fit()` - Afficher les résultats

**Qu'est-ce que ça fait ?**
Affiche un résumé compact des résultats d'ajustement.

**Syntaxe :**
```r
print(fit)
```

**Exemple de résultat :**
```
JMAK Model Fit Summary:
  K = 0.02003
  n = 3.1948
  Method: lm
  R² = 0.9856
  RMSE = 0.0189
```

---

## 📊 Exemples pratiques

### Exemple 1 : Analyse simple avec données incluses

```r
library(JMAK)

# Charger les données exemple (cristallisation de polymère)
data(polymere_cristallisation)

# Visualiser les données
head(polymere_cristallisation)

# Ajuster le modèle
fit <- jmnak_fit_auto(
  polymere_cristallisation$t,
  polymere_cristallisation$Y
)

# Les graphiques diagnostiques s'affichent automatiquement
```

### Exemple 2 : Données personnalisées

```r
library(JMAK)

# Vos données expérimentales
temps <- c(1, 2, 3, 5, 8, 10, 12, 15, 20)
fraction <- c(0.02, 0.08, 0.18, 0.45, 0.72, 0.85, 0.92, 0.97, 0.99)

# Nettoyer les données
df <- jmnak_import_validate(temps, fraction)

# Ajuster silencieusement (sans affichage console)
fit <- jmnak_fit_auto(df$t, df$Y, verbose = FALSE)

# Récupérer les paramètres
K <- fit$parameters$K
n <- fit$parameters$n
R2 <- fit$fit_quality$r2_original

cat(sprintf("K = %.4g, n = %.3f, R² = %.4f\n", K, n, R2))
```

### Exemple 3 : Prédictions et analyse

```r
library(JMAK)

# Données
t <- c(0.5, 1, 2, 4, 8, 15, 25)
Y <- 1 - exp(-0.015 * t^2.8) + rnorm(7, 0, 0.02)  # Avec bruit
Y <- pmin(pmax(Y, 0.001), 0.999)

# Ajuster
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)

# Prédire Y(t) sur une grille fine et calculer t₅₀, t₉₀
pred <- jmnak_predict(
  t = seq(0.5, 25, 0.1),
  K = fit$parameters$K,
  n = fit$parameters$n,
  Ystar = c(0.25, 0.50, 0.75, 0.90)
)

# Afficher les résultats
cat("Temps caractéristiques:\n")
print(pred$tstar)

# Créer un graphique personnalisé
plot(t, Y, pch = 16, col = "blue", 
     xlab = "Temps", ylab = "Fraction transformée",
     main = "Données + Modèle JMAK ajusté",
     xlim = c(0, 25), ylim = c(0, 1))
lines(pred$t, pred$Y_pred, col = "red", lwd = 2)
abline(v = pred$tstar, col = "gray", lty = 2)
legend("bottomright", 
       legend = c("Données", "Modèle JMAK"),
       col = c("blue", "red"), pch = c(16, NA), lty = c(NA, 1))
```

### Exemple 4 : Comparaison de plusieurs datasets

```r
library(JMAK)

# Deux conditions expérimentales
temps_A <- c(1, 2, 3, 5, 8, 12, 18)
Y_A <- c(0.05, 0.15, 0.28, 0.52, 0.78, 0.92, 0.98)

temps_B <- c(0.5, 1, 1.5, 2.5, 4, 6, 9)
Y_B <- c(0.01, 0.08, 0.18, 0.35, 0.58, 0.78, 0.93)

# Ajuster les deux modèles
fit_A <- jmnak_fit_auto(temps_A, Y_A, verbose = FALSE)
fit_B <- jmnak_fit_auto(temps_B, Y_B, verbose = FALSE)

# Comparer les paramètres
comparison <- data.frame(
  Condition = c("A", "B"),
  K = c(fit_A$parameters$K, fit_B$parameters$K),
  n = c(fit_A$parameters$n, fit_B$parameters$n),
  R2 = c(fit_A$fit_quality$r2_original, fit_B$fit_quality$r2_original),
  RMSE = c(fit_A$fit_quality$rmse, fit_B$fit_quality$rmse)
)

print(comparison)

# Les graphiques de diagnostic s'affichent pour chaque ajustement
```

### Exemple 5 : Exporter les résultats

```r
library(JMAK)

# Ajuster le modèle
data(polymere_cristallisation)
fit <- jmnak_fit_auto(polymere_cristallisation$t,
                      polymere_cristallisation$Y,
                      verbose = FALSE)

# Prédictions
pred <- jmnak_predict(
  t = seq(0.5, 30, 0.5),
  K = fit$parameters$K,
  n = fit$parameters$n,
  Ystar = seq(0.1, 0.9, 0.1)
)

# Exporter les prédictions en CSV
predictions_df <- data.frame(
  t = pred$t,
  Y_pred = pred$Y_pred
)
write.csv(predictions_df, "predictions.csv", row.names = FALSE)

# Exporter les temps caractéristiques
tstar_df <- data.frame(
  Y = as.numeric(sub("t_for_Y=", "", names(pred$tstar))),
  t_star = as.numeric(pred$tstar)
)
write.csv(tstar_df, "characteristic_times.csv", row.names = FALSE)

cat("Fichiers exportés :\n")
cat("  - predictions.csv\n")
cat("  - characteristic_times.csv\n")
```

---

## ❓ FAQ

### Q1 : Je viens d'installer R et je ne sais rien faire. Par où je commence ?

**R :**
1. Installez **Git** depuis https://git-scm.com
2. Installez **RStudio** depuis https://posit.co/download/rstudio-desktop/
3. Suivez les étapes de la section [Installation détaillée pour débutants](#pour-débutants-sous-windows)
4. Exécutez le code du [Démarrage rapide](#⚡-démarrage-rapide)

---

### Q2 : Je n'arrive pas à installer le package. Que faire ?

**Essayez ces solutions dans l'ordre :**

1. **Vérifiez les dépendances** :
   ```r
   install.packages(c("ggplot2", "patchwork"))
   ```

2. **Réinstaller depuis zéro** :
   ```r
   # Supprimer l'ancienne version
   remove.packages("JMAK")
   
   # Réinstaller
   install.packages("C:/chemin/vers/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```

3. **Si vous êtes sous Windows et ça échoue** :
   - Assurez-vous que **R Tools** est installé : https://cran.r-project.org/bin/windows/Rtools/
   - Fermez toutes les fenêtres R et RStudio
   - Réessayez

4. **Contactez-moi** avec le message d'erreur complet

---

### Q3 : Mes données sont en pourcentages. Je dois les convertir ?

**Non !** La fonction `jmnak_import_validate()` le fait automatiquement.

```r
# Ceci fonctionne :
Y <- c(5, 10, 25, 50, 75, 90)  # Pourcentages
fit <- jmnak_fit_auto(t, Y)  # Conversion auto
```

---

### Q4 : Comment j'interprète R² ?

**R² (coefficient de détermination) :**
- R² = 1.0 : ajustement parfait
- R² > 0.95 : excellent
- R² > 0.90 : très bon
- R² > 0.80 : bon
- R² < 0.80 : ajustement faible, vérifier les données

```r
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)
cat("R² =", fit$fit_quality$r2_original, "\n")
```

---

### Q5 : Qu'est-ce que l'exposant n me dit ?

L'exposant **n** caractérise le **mécanisme** de transformation :

| Valeur de n | Mécanisme |
|---|---|
| n ≈ 1 | Croissance unidimensionnelle |
| n ≈ 2 | Croissance bidimensionnelle |
| n ≈ 3 | Croissance tridimensionnelle |
| n ≈ 4 | Nucléation et croissance 3D |
| n > 4 | Nucléation accélérée |

```r
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)
cat("Exposant n =", fit$parameters$n, "\n")
```

---

### Q6 : Les graphiques ne s'affichent pas

**Cause probable :** ggplot2 n'est pas installé

**Solution :**
```r
install.packages("ggplot2")
library(JMAK)
# Réessayez
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)
```

Le package utilise les graphiques base R en fallback si ggplot2 n'est pas dispo.

---

### Q7 : Comment savoir si mon ajustement est bon ?

**Regardez ces indices :**

1. **R²** > 0.90 ✅
2. **RMSE** faible (proche de l'erreur experimentale) ✅
3. **Résidus** dispersés aléatoirement autour de zéro ✅
4. **Cook's distance** : peu ou pas de points au-dessus du seuil ✅
5. **Shapiro-Wilk** p-value > 0.05 ✅ (résidus normaux)

```r
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)
# Tous ces indices s'affichent dans le résumé
```

---

### Q8 : Je veux enlever un point expérimental qui semble aberrant

```r
library(JMAK)

# Identifiez le point aberrant visuellement ou par son Cook's distance
# Puis réajustez sans ce point

t_clean <- t[-index_aberrant]  # Enlever l'élément à l'index
Y_clean <- Y[-index_aberrant]

# Réajuster
fit <- jmnak_fit_auto(t_clean, Y_clean, verbose = TRUE)
```

---

### Q9 : Puis-je utiliser ce package sur Mac ?

**Oui !** Le package fonctionne sur macOS. 

Installez d'abord Homebrew, puis :
```bash
brew install git
brew install r
```

Puis suivez les instructions Linux.

---

### Q10 : Où puis-je reporter des bugs ou demander une fonctionnalité ?

Créez une **Issue** sur GitHub : https://github.com/prunelleeba/JMAK-/issues

---

## 📋 Structure du package

```
JMAK/
│
├── DESCRIPTION              # Métadonnées du package
├── NAMESPACE                # Fonctions exportées
├── README.md                # Ce fichier
├── LICENSE                  # Licence MIT
├── JMAK_1.1.tar.gz          # Archive compressée du package
│
├── R/                       # Code source
│   ├── jmnak_fit_auto.R          # Fonction principale (596 lignes)
│   ├── jmnak_import_validate.R   # Validation des données
│   ├── jmak_model.R              # Prédictions
│   ├── data-polymere_cristallisation.R
│   └── zzz-imports.R             # Déclarations des imports
│
├── data/
│   └── polymere_cristallisation.rda  # Dataset exemple
│
├── data-raw/
│   └── make_data.R                   # Script de génération du dataset
│
├── man/                     # Documentation des fonctions
│   ├── jmnak_fit_auto.Rd
│   ├── jmnak_import_validate.Rd
│   ├── jmnak_predict.Rd
│   ├── print.jmnak_fit.Rd
│   └── polymere_cristallisation.Rd
│
└── tests/
    ├── testthat.R
    └── testthat/
        └── test-jmak.R     # Tests unitaires (137 lignes)
```

---

## 💻 Systèmes d'exploitation supportés

| Système | Version | Statut |
|---------|---------|--------|
| **Windows** | 10, 11 | ✅ Complet |
| **Ubuntu/Linux** | 18.04+ | ✅ Complet |
| **macOS** | 10.14+ | ✅ Complet |

---

## 📦 Dépendances

### Obligatoires
- **R** ≥ 4.0.0
- **ggplot2** : pour les graphiques
- **stats** : déjà inclus dans R

### Optionnelles (avec fallback automatique)
- **patchwork** : disposition avancée des graphiques
- **minpack.lm** : algorithme NLS alternatif
- **car** : test de Durbin-Watson

```r
# Installez tout en une fois :
install.packages(c("ggplot2", "patchwork", "minpack.lm", "car"))
```

---

## 🔬 Données incluses

### `polymere_cristallisation`

Dataset simulé de **cristallisation de polymère** :
- **60 observations**
- **Colonnes** : `t` (temps), `Y` (fraction transformée)
- **Paramètres vrais** : K = 0.02, n = 3.2
- **Bruit** : Gaussien (écart-type 0.02)

**Utilisation :**
```r
library(JMAK)
data(polymere_cristallisation)
head(polymere_cristallisation)
summary(polymere_cristallisation)
```

---

## ✅ Tests

Le package inclut **7 tests unitaires** couvrant :
- Validation et nettoyage des données
- Récupération des paramètres
- Robustesse sur données bruitées
- Calcul des prédictions
- Cas limites
- Clamping des valeurs
- Génération des résumés console

**Exécuter les tests :**
```r
devtools::test()
# ou
testthat::test_dir("tests/")
```

---

## 📖 Documentation complète

Pour la documentation de chaque fonction :

```r
?jmnak_fit_auto
?jmnak_import_validate
?jmnak_predict
?polymere_cristallisation
```

---

## 📞 Support et Contact

### Questions sur l'installation ?
Reportez les erreurs sur : https://github.com/prunelleeba/JMAK-/issues

### Feedback, suggestions ou bugs ?
Créez une nouvelle **Issue** avec :
1. La description du problème
2. Le code qui reproduit l'erreur
3. Le message d'erreur complet
4. Votre système d'exploitation et version de R

```r
sessionInfo()  # Utilisez ça pour envoyer vos infos système
```

### Auteur
**EBA NGOLONG Jeanne Chantal**  
Email : jeanne.eba@facsciences-uy1.cm

---

## 📜 Licence

Ce package est distribué sous **licence MIT**.  
Consultez le fichier `LICENSE` pour les détails.

---

## 🚀 Prochaines étapes

Maintenant que vous avez installé JMAK :

1. ✅ Suivez le [Démarrage rapide](#⚡-démarrage-rapide)
2. ✅ Explorez les [Exemples pratiques](#📊-exemples-pratiques)
3. ✅ Consultez l'aide des fonctions avec `?nom_fonction`
4. ✅ Adaptez le code à vos données
5. ✅ Générez vos rapports d'analyse

---

## 🎓 En savoir plus sur le modèle JMAK

### Références scientifiques
- Avrami, M. (1939). "Kinetics of phase change. I" Journal of Chemical Physics
- Johnson, W. A., & Mehl, R. F. (1939). "Reaction kinetics in processes of nucleation and growth"

### Ressources en ligne
- [JMAK model - Wikipedia](https://en.wikipedia.org/wiki/Johnson%E2%80%93Mehl%E2%80%93Avrami%E2%80%93Kolmogorov_nucleation)
- Cours de cinétique chimique (universités)

---

**Dernière mise à jour** : 14 décembre 2025  
**Version du package** : 1.1

---

