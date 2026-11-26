# AQLThemes

*[Version française](README.fr.md)*

A Quarto extension providing two presentation formats with the same look:

- `aqlt-beamer`: PDF slides (beamer), built on Quarto's default LaTeX template;
- `aqlt-revealjs`: HTML slides (reveal.js).

Colours are set directly from the YAML header: no custom `template.tex` is needed.

**Live demo: <https://aqlt.github.io/AQLThemes/>**

| | Default colours | Custom colours ([`examples/custom.yml`](examples/custom.yml)) |
|:---|:---:|:---:|
| beamer | [![beamer, default colours](https://aqlt.github.io/AQLThemes/images/beamer-template.png)](https://aqlt.github.io/AQLThemes/template.pdf) | [![beamer, custom colours](https://aqlt.github.io/AQLThemes/images/beamer-custom.png)](https://aqlt.github.io/AQLThemes/custom.pdf) |
| revealjs | [![revealjs, default colours](https://aqlt.github.io/AQLThemes/images/revealjs-template.png)](https://aqlt.github.io/AQLThemes/template.html) | [![revealjs, custom colours](https://aqlt.github.io/AQLThemes/images/revealjs-custom.png)](https://aqlt.github.io/AQLThemes/custom.html) |

Click an image to open the full PDF or HTML presentation.

## Installation

To start a new presentation from the [template](template.qmd):

```bash
quarto use template AQLT/AQLThemes
```

To add the extension to an existing project, from its root:

```bash
quarto add AQLT/AQLThemes
```

Both commands copy the extension into `_extensions/aqlt`. You can also copy that folder by hand.

## Usage

```yaml
---
title: "Welcome"
subtitle: "Time series training"
author: "Alain Quartier-la-Tente"
division: "Insee"          # extra lines under the author (optional)
departement: ""
logo: img/logo.jpeg        # title page logo (give the file extension)
format:
  aqlt-beamer:
    classoption: [handout]
  aqlt-revealjs: default
---
```

Both formats use the same heading structure (`slide-level: 3`):

- `#`: section, shown in the top-left block;
- `##`: subsection, shown in the top-right block;
- `###`: slide, whose title is underlined.

## Options

All options are optional:

```yaml
aqlt:
  primary: "#00B0F0"          # section block, line under the title, bullets, links
  secondary: "#CCEFFC"        # subsection block and footer (default: primary at 20%)
  section-text: white         # text of the section block and of the title band
  subsection-text: "#00B0F0"  # text of the subsection block (default: primary)
  footer-text: "#006A90"      # footer text (default: darker primary)
  frametitle-text: black      # slide titles
  bullet: circle              # circle | square | triangle | diamond (beamer only)
  footer-title: false         # true: block at the bottom with the title (or `footer:`)
footer: "Footer text"         # default: the title; shows the block unless footer-title is set
section-titles: false         # true: one slide for each section and subsection
```

In practice `primary` is often enough, because the other colours are derived from it.
A colour is either a hex code (`"#C8102E"`, `"#C21"`) or a name known to both
LaTeX and CSS (`white`, `black`, `red`...).

## Syntax shared by both formats

- `[text]{.alert}`: highlighted text (`\alert{}` in beamer);
- `\E{X}`, `\V{X}`, `\cov{X}{Y}`, `\Cov`: maths macros, defined for LaTeX and MathJax;
- `. . .` (pauses), columns and callouts work as usual in Quarto.

Raw LaTeX commands (`\alert`, `bclogo`, `tikz`...) only work in beamer.

## Examples

The examples are rendered from [`template.qmd`](template.qmd):

```bash
quarto render template.qmd                                   # default colours
quarto render template.qmd --to aqlt-beamer \
  --metadata-file examples/custom.yml --output custom.pdf    # custom colours
```

On each push to `master`, the [GitHub Action](.github/workflows/publish.yml) renders
both versions, takes the screenshots and publishes them to the `gh-pages` branch.
