# AQLThemes

*[English version](README.md)*

Extension Quarto qui fournit deux formats de présentation au même style :

- `aqlt-beamer` : slides PDF (beamer), à partir du template LaTeX par défaut de Quarto ;
- `aqlt-revealjs` : slides HTML (reveal.js).

Les couleurs se règlent directement dans l'en-tête YAML : plus besoin de `template.tex` personnalisé.

**Démo en ligne : <https://aqlt.github.io/AQLThemes/>**

| | Couleurs par défaut | Couleurs personnalisées ([`examples/custom.yml`](examples/custom.yml)) |
|:---|:---:|:---:|
| beamer | [![beamer, couleurs par défaut](https://aqlt.github.io/AQLThemes/images/beamer-template.png)](https://aqlt.github.io/AQLThemes/template.pdf) | [![beamer, couleurs personnalisées](https://aqlt.github.io/AQLThemes/images/beamer-custom.png)](https://aqlt.github.io/AQLThemes/custom.pdf) |
| revealjs | [![revealjs, couleurs par défaut](https://aqlt.github.io/AQLThemes/images/revealjs-template.png)](https://aqlt.github.io/AQLThemes/template.html) | [![revealjs, couleurs personnalisées](https://aqlt.github.io/AQLThemes/images/revealjs-custom.png)](https://aqlt.github.io/AQLThemes/custom.html) |

Cliquer sur une image ouvre la présentation complète en PDF ou en HTML.

## Installation

Pour démarrer une nouvelle présentation à partir du [modèle](template.qmd) :

```bash
quarto use template AQLT/AQLThemes
```

Pour ajouter l'extension à un projet existant, depuis sa racine :

```bash
quarto add AQLT/AQLThemes
```

Les deux commandes copient l'extension dans `_extensions/aqlt`. On peut aussi copier ce dossier à la main.

## Utilisation

```yaml
---
title: "0 - Accueil des stagiaires"
subtitle: "Formation séries temporelles"
author: "Alain Quartier-la-Tente"
division: "Insee"          # lignes affichées sous l'auteur (facultatif)
departement: ""
logo: img/logo.jpeg        # logo de la page de garde (avec l'extension du fichier)
format:
  aqlt-beamer:
    classoption: [handout]
  aqlt-revealjs: default
---
```

Les deux formats utilisent la même structure de titres (`slide-level: 3`) :

- `#` : section, affichée dans le bloc en haut à gauche ;
- `##` : sous-section, affichée dans le bloc en haut à droite ;
- `###` : slide, dont le titre est souligné.

## Options

Toutes les options sont facultatives :

```yaml
aqlt:
  primary: "#00B0F0"          # bloc section, trait sous le titre, puces, liens
  secondary: "#CCEFFC"        # bloc sous-section et pied de page (défaut : primary à 20 %)
  section-text: white         # texte du bloc section et du bandeau titre
  subsection-text: "#00B0F0"  # texte du bloc sous-section (défaut : primary)
  footer-text: "#006A90"      # texte du pied de page (défaut : primary assombri)
  frametitle-text: black      # titre des slides
  bullet: circle              # circle | square | triangle | diamond (beamer uniquement)
  footer-title: false         # true : bloc en bas avec le titre (ou `footer:`)
footer: "Texte du pied de page"   # défaut : le titre ; affiche le bloc si footer-title n'est pas précisé
section-titles: false             # true : une slide par section et sous-section
```

En pratique, `primary` suffit souvent, car les autres couleurs en dérivent.
Une couleur s'écrit en hexadécimal (`"#C8102E"`, `"#C21"`) ou avec un nom connu
à la fois de LaTeX et de CSS (`white`, `black`, `red`...).

## Syntaxe commune aux deux formats

- `[texte]{.alert}` : texte mis en valeur (`\alert{}` en beamer) ;
- `\E{X}`, `\V{X}`, `\cov{X}{Y}`, `\Cov` : macros mathématiques, définies pour LaTeX et MathJax ;
- `. . .` (pauses), colonnes et callouts : comme d'habitude dans Quarto.

Les commandes LaTeX brutes (`\alert`, `bclogo`, `tikz`...) ne fonctionnent qu'en beamer.

## Exemples

Les exemples sont rendus à partir de [`template.qmd`](template.qmd) :

```bash
quarto render template.qmd                                   # couleurs par défaut
quarto render template.qmd --to aqlt-beamer \
  --metadata-file examples/custom.yml --output custom.pdf    # couleurs personnalisées
```

À chaque push sur `master`, la [GitHub Action](.github/workflows/publish.yml) rend les
deux versions, fait les captures d'écran et publie le tout sur la branche `gh-pages`.
