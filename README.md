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

All options are optional. The example below shows the default values:

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

In practice `primary` is often enough, because the other colours are derived from it.
A colour is either a hex code (`"#C8102E"`, `"#C21"`) or a name known to both
LaTeX and CSS (`white`, `black`, `red`...).

### Theme options (`aqlt:`)

| Option | Default | What it changes |
|---|---|---|
| `primary` | `#00B0F0` | Background of the section block (top left), line under slide titles, bullets and list numbers, `[text]{.alert}`, links (revealjs), title band and subtitle block of the title page, block titles; block bodies use it at 10 % (beamer) |
| `secondary` | `primary` at 20 % | Background of the subsection block (top right), of the bottom title block and of the slide number |
| `section-text` | `white` | Text on a `primary` background: section block, title band, subtitle block, block titles |
| `subsection-text` | `primary` | Text of the subsection block |
| `footer-text` | `primary` darkened (60 %) | Text of the bottom title block and of the slide number |
| `frametitle-text` | `black` | Slide titles |
| `bullet` | `circle` | Bullet shape: `circle`, `square`, `triangle` or `diamond` (beamer only) |
| `footer-title` | `false` | `true` shows a block at the bottom of the slides with the title (or the `footer:` text) |

### Document options

| Option | Default | What it changes |
|---|---|---|
| `title`, `subtitle`, `author`, `date` | | Title page; the subtitle goes in the rounded block at the top |
| `institute`, `division`, `departement` | | Lines under the author on the title page |
| `logo` | | Image on the title page (give the file extension, e.g. `img/logo.jpeg`) |
| `footer` | the title | Text of the bottom block; setting it shows the block unless `footer-title: false` |
| `shorttitle` | `footer` | Text of the bottom block in beamer only |
| `section-titles` | `false` | `true` adds a slide for each section (`#`) and subsection (`##`) |

### Format defaults set by the extension

They can be overridden under `format:` like any Quarto option.

| Format | Values |
|---|---|
| both | `slide-level: 3` |
| `aqlt-beamer` | `pdf-engine: pdflatex`, `fontsize: 10pt`, `classoption: [xcolor=table, dvipsnames]` |
| `aqlt-revealjs` | `width: 1280`, `height: 720`, `slide-number: c/t`, `center: false`, `transition: none` |

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
