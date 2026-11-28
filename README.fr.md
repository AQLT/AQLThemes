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

Toutes les options sont facultatives. L'exemple ci-dessous reprend les valeurs par défaut :

```yaml
aqlt:
  primary: "#00B0F0"
  secondary: "#CCEFFC"
  section-text: white
  subsection-text: "#00B0F0"
  footer-text: "#006A90"
  frametitle-text: black
  bullet: circle
  footer-title: false
```

En pratique, `primary` suffit souvent, car les autres couleurs en dérivent.
Une couleur s'écrit en hexadécimal (`"#C8102E"`, `"#C21"`) ou avec un nom connu
à la fois de LaTeX et de CSS (`white`, `black`, `red`...).

### Options du thème (`aqlt:`)

| Option | Défaut | Ce qu'elle change |
|---|---|---|
| `primary` | `#00B0F0` | Fond du bloc section (haut gauche), trait sous le titre des slides, puces et numéros de liste, `[texte]{.alert}`, liens (revealjs), bandeau titre et bloc du sous-titre de la page de garde, titres des blocs ; le corps des blocs l'utilise à 10 % (beamer) |
| `secondary` | `primary` à 20 % | Fond du bloc sous-section (haut droite), du bloc titre en bas et du numéro de slide |
| `section-text` | `white` | Texte sur fond `primary` : bloc section, bandeau titre, bloc du sous-titre, titres des blocs |
| `subsection-text` | `primary` | Texte du bloc sous-section |
| `footer-text` | `primary` assombri (60 %) | Texte du bloc titre en bas et du numéro de slide |
| `frametitle-text` | `black` | Titre des slides |
| `bullet` | `circle` | Forme des puces : `circle`, `square`, `triangle` ou `diamond` (beamer uniquement) |
| `footer-title` | `false` | `true` affiche en bas des slides un bloc avec le titre (ou le texte de `footer:`) |

### Options du document

| Option | Défaut | Ce qu'elle change |
|---|---|---|
| `title`, `subtitle`, `author`, `date` | | Page de garde ; le sous-titre va dans le bloc arrondi en haut |
| `institute`, `division`, `departement` | | Lignes sous l'auteur sur la page de garde |
| `logo` | | Image de la page de garde (avec l'extension, par exemple `img/logo.jpeg`) |
| `footer` | le titre | Texte du bloc en bas ; le renseigner affiche le bloc, sauf si `footer-title: false` |
| `shorttitle` | `footer` | Texte du bloc en bas, en beamer uniquement |
| `section-titles` | `false` | `true` ajoute une slide pour chaque section (`#`) et sous-section (`##`) |

### Valeurs imposées par l'extension

Elles se remplacent sous `format:` comme n'importe quelle option Quarto.

| Format | Valeurs |
|---|---|
| les deux | `slide-level: 3` |
| `aqlt-beamer` | `pdf-engine: pdflatex`, `fontsize: 10pt`, `classoption: [xcolor=table, dvipsnames]` |
| `aqlt-revealjs` | `width: 1280`, `height: 720`, `slide-number: c/t`, `center: false`, `transition: none` |

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

## Licence

[MIT](LICENSE), sauf [`_extensions/aqlt/beamerthemeaqlt.sty`](_extensions/aqlt/beamerthemeaqlt.sty),
dérivé du thème beamer TorinoTh de Claudio Fiandrino et distribué sous la
[LaTeX Project Public License 1.3c](https://www.latex-project.org/lppl.txt).
