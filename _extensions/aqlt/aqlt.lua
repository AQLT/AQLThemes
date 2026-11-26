--[[
  Filtre de l'extension AQLT (beamer + revealjs).

  Options YAML (toutes facultatives) :

    aqlt:
      primary: "#00B0F0"        # bloc section, trait sous le titre, puces, liens
      secondary: "#C9EBFC"      # bloc sous-section et pied de page (défaut : primary à 20 %)
      section-text: white       # texte du bloc section et du bandeau titre
      subsection-text: "#00B0F0"# texte du bloc sous-section (défaut : primary)
      footer-text: "#006A90"    # texte du pied de page (défaut : primary assombri)
      frametitle-text: black    # titre des slides
      footer-title: false       # true : titre (ou `footer:`) dans un bloc en bas
      bullet: circle            # circle | square | triangle | diamond (beamer)
    division: ...               # lignes affichées sous l'auteur
    departement: ...
    logo: img/logo.png          # logo de la page de garde
    footer: ...                 # texte du bloc en bas (défaut : titre)
    section-titles: false       # slides de section (# et ##)

  Une couleur s'écrit en hexadécimal ("#RRGGBB" ou "#RGB") ou avec un nom
  connu à la fois de xcolor et de CSS (white, black, red, ...).
]]

local stringify = pandoc.utils.stringify

-- Ordre important côté LaTeX : les couleurs dérivées sont calculées à la
-- définition, primary doit donc être défini en premier.
local COLORS = {
  { key = "primary",         tex = "aqltprimary",        css = "--aqlt-primary",
    tex_default = "\\definecolor{aqltprimary}{HTML}{00B0F0}" },
  { key = "secondary",       tex = "aqltsecondary",      css = "--aqlt-secondary",
    tex_default = "\\colorlet{aqltsecondary}{aqltprimary!20}" },
  { key = "section-text",    tex = "aqltsectiontext",    css = "--aqlt-section-text",
    tex_default = "\\colorlet{aqltsectiontext}{white}" },
  { key = "subsection-text", tex = "aqltsubsectiontext", css = "--aqlt-subsection-text",
    tex_default = "\\colorlet{aqltsubsectiontext}{aqltprimary}" },
  { key = "footer-text",     tex = "aqltfootertext",     css = "--aqlt-footer-text",
    tex_default = "\\colorlet{aqltfootertext}{aqltprimary!60!black}" },
  { key = "frametitle-text", tex = "aqltframetitle",     css = "--aqlt-frametitle-text",
    tex_default = "\\colorlet{aqltframetitle}{black}" },
}

local function normalize_hex(value)
  local hex = value:match("^#(%x+)$")
  if hex == nil then return nil end
  if #hex == 3 then
    hex = hex:gsub("(%x)", "%1%1")
  end
  if #hex ~= 6 then return nil end
  return hex:upper()
end

local function latex_color(name, value)
  local hex = normalize_hex(value)
  if hex then
    return "\\definecolor{" .. name .. "}{HTML}{" .. hex .. "}"
  end
  return "\\colorlet{" .. name .. "}{" .. value .. "}"
end

local function opt(meta, key)
  local aqlt = meta.aqlt
  if aqlt == nil or aqlt[key] == nil then return nil end
  local v = stringify(aqlt[key])
  if v == "" then return nil end
  return v
end

-- Bloc titre en bas : `aqlt.footer-title`, sinon affiché seulement si
-- `footer:` est renseigné
local function show_footer_title(meta)
  local v = opt(meta, "footer-title")
  if v ~= nil then return v == "true" end
  return meta.footer ~= nil
end

local function to_latex(value)
  if value == nil then return nil end
  local blocks
  if pandoc.utils.type(value) == "Inlines" then
    blocks = { pandoc.Plain(value) }
  elseif pandoc.utils.type(value) == "Blocks" then
    blocks = value
  else
    blocks = { pandoc.Plain(pandoc.Inlines(stringify(value))) }
  end
  return pandoc.write(pandoc.Pandoc(blocks), "latex"):gsub("%s+$", "")
end

local function logo_path(meta)
  if meta.logo == nil then return nil end
  local v = meta.logo
  if pandoc.utils.type(v) == "table" or pandoc.utils.type(v) == "Meta" then
    v = v.path or v.light or v[1]
  end
  if v == nil then return nil end
  v = stringify(v)
  if v == "" then return nil end
  return v
end

--------------------------------------------------------------------------
-- Beamer
--------------------------------------------------------------------------
local function beamer_meta(meta)
  local lines = { "\\makeatletter" }
  for _, c in ipairs(COLORS) do
    local v = opt(meta, c.key)
    lines[#lines + 1] = v and latex_color(c.tex, v) or c.tex_default
  end
  if show_footer_title(meta) then lines[#lines + 1] = "\\aqltfootertitle{true}" end
  local bullet = opt(meta, "bullet")
  if bullet then lines[#lines + 1] = "\\aqltbullet{" .. bullet .. "}" end
  local logo = logo_path(meta)
  if logo then lines[#lines + 1] = "\\aqltlogo{" .. logo .. "}" end
  for _, key in ipairs({ "division", "departement" }) do
    local v = to_latex(meta[key])
    if v and v ~= "" then lines[#lines + 1] = "\\" .. key .. "{" .. v .. "}" end
  end
  lines[#lines + 1] = "\\makeatother"
  quarto.doc.include_text("in-header", table.concat(lines, "\n"))

  -- `footer:` (option revealjs) sert aussi de titre court en beamer
  if meta.shorttitle == nil and meta.footer ~= nil then
    meta.shorttitle = meta.footer
  end
  if meta["section-titles"] == nil then
    meta["section-titles"] = false
  end
  return meta
end

--------------------------------------------------------------------------
-- Revealjs
--------------------------------------------------------------------------
local function revealjs_meta(meta)
  local css = {}
  for _, c in ipairs(COLORS) do
    local v = opt(meta, c.key)
    if v then
      if v:find("!") then
        quarto.log.warning("aqlt: la couleur '" .. v .. "' (" .. c.key ..
          ") est une expression xcolor, ignorée en revealjs")
      else
        local hex = normalize_hex(v)
        css[#css + 1] = c.css .. ": " .. (hex and ("#" .. hex) or v) .. ";"
      end
    end
  end
  if #css > 0 then
    quarto.doc.include_text("in-header",
      "<style>:root {" .. table.concat(css, " ") .. "}</style>")
  end

  local logo = logo_path(meta)
  if logo then meta["aqlt-logo"] = logo end
  -- Pied de page : `footer:` s'il est renseigné, sinon le titre
  if not show_footer_title(meta) then
    quarto.doc.include_text("in-header",
      "<style>.reveal .footer.footer-default {display: none !important;}</style>")
    return meta
  end
  quarto.doc.include_text("after-body", [[
<script>
document.addEventListener("DOMContentLoaded", function () {
  var footer = document.querySelector(".footer-default");
  var title = document.querySelector("#title-slide .title");
  if (footer && title && footer.textContent.trim() === "") {
    footer.innerHTML = "<p>" + title.innerHTML + "</p>";
  }
});
</script>]])
  return meta
end

-- Ajoute en haut de chaque slide le bandeau « section | sous-section »
-- et masque les slides de section, comme en beamer.
-- Macros mathématiques de preambule.tex, définies pour MathJax
local MATH_MACROS = table.concat({
  "\\newcommand{\\Cov}{\\operatorname{Cov}}",
  "\\newcommand{\\E}[1]{\\mathbb{E}\\left[ #1 \\right]}",
  "\\newcommand{\\V}[1]{\\mathbb{V}\\left[ #1 \\right]}",
  "\\newcommand{\\cov}[2]{\\Cov\\left( #1\\,,\\,#2 \\right)}",
})

local function revealjs_doc(doc)
  local slide_level = tonumber(stringify(doc.meta["slide-level"] or "3")) or 3
  local show_sections = doc.meta["section-titles"] == true
  local section, subsection = pandoc.Inlines({}), pandoc.Inlines({})
  local blocks = pandoc.Blocks({})
  local macros_done = false

  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" and b.level < slide_level then
      if b.level == 1 then
        section = b.content
        subsection = pandoc.Inlines({})
      elseif b.level == 2 then
        subsection = b.content
      end
      if not show_sections then
        b.attributes["visibility"] = "hidden"
      end
      blocks:insert(b)
    elseif b.t == "Header" and b.level == slide_level then
      blocks:insert(b)
      local header = pandoc.Inlines({})
      if not b.classes:includes("no-aqlt-header") then
        header = pandoc.Inlines({
          pandoc.Span(section, { class = "aqlt-section" }),
          pandoc.Span(subsection, { class = "aqlt-subsection" }),
        })
      end
      if not macros_done then
        header:insert(pandoc.Span(pandoc.Math("InlineMath", MATH_MACROS),
          { style = "display:none" }))
        macros_done = true
      end
      if #header > 0 then
        blocks:insert(pandoc.Div(pandoc.Plain(header), { class = "aqlt-header" }))
      end
    else
      blocks:insert(b)
    end
  end
  doc.blocks = blocks
  return doc
end

--------------------------------------------------------------------------

-- [texte]{.alert} : mis en valeur dans les deux formats (\alert en beamer)
local function alert_span(span)
  if quarto.doc.is_format("beamer") and span.classes:includes("alert") then
    local out = pandoc.Inlines({ pandoc.RawInline("latex", "\\alert{") })
    out:extend(span.content)
    out:insert(pandoc.RawInline("latex", "}"))
    return out
  end
end

local function main(doc)
  if quarto.doc.is_format("beamer") then
    doc.meta = beamer_meta(doc.meta)
  elseif quarto.doc.is_format("revealjs") then
    doc.meta = revealjs_meta(doc.meta)
    doc = revealjs_doc(doc)
  end
  return doc
end

return {
  { Span = alert_span },
  { Pandoc = main },
}
