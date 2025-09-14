// typst-template.typ

#let thesis_body_template(
  body-font: "Adobe Garamond Pro",
  body-size: 11pt,

  // ↓ Tighter line spacing; adjust 1.18–1.24 if needed
  line-height: 1.20em,

  paragraph-indent: 0pt,

  // ↓ Clear gap between paragraphs (tweak 0.60–0.70em to taste)
  paragraph-spacing: 0.65em,

  justify: true,
  hyphenate: true,

  heading-font: "Frutiger LT Std",
  heading-smallcaps: false,
  heading-numbering: "1.1.1",

  h1-size: 14pt, h1-above: 1.6em, h1-below: 0.8em,
  h2-size: 12pt, h2-above: 1.2em, h2-below: 0.6em,
  h3-size: 11pt, h3-above: 1.0em, h3-below: 0.5em,

  math-font: "New Computer Modern Math",

  // --- metadata from YAML ---
  meta-title: none,
  meta-thanks: none,
  meta-authors: [],
  meta-affiliations: [],
  meta-abstract: none,
  meta-keywords: [],
  meta-jel: [],

  body
) = {
  // Punctuation superscripts for affiliations (order matters)
  let aff_syms = ["*", "†", "‡", "§", "¶", "‖", "††", "‡‡", "§§", "¶¶"]

  // Find the index of an affiliation by id or name in meta-affiliations
  let aff_index = (needle) => {
    let i = 0
    for a in meta-affiliations {
      if (a.name == needle) or (a.id == needle) { i }
      else { i = i + 1 }
    }
    // If not found, -1
    -1
  }

  let aff_symbol = (aff_ref) => {
    let idx = aff_index(aff_ref)
    if idx >= 0 and idx < aff_syms.len() { aff_syms.at(idx) } else { "?" }
  }

  // Body text
  set text(font: body-font, size: body-size, hyphenate: hyphenate)
  set par(
    leading: line-height,              // line spacing within paragraphs
    justify: justify,
    first-line-indent: paragraph-indent,
    spacing: paragraph-spacing         // space between paragraphs
  )

  // Headings
  set heading(numbering: heading-numbering)
  show heading: it => {
    set text(font: heading-font)
    if heading-smallcaps { smallcaps(it) } else { it }
  }
  show heading.where(level: 1): it => {
    set text(size: h1-size)
    set block(above: h1-above, below: h1-below)
    it
  }
  show heading.where(level: 2): it => {
    set text(size: h2-size)
    set block(above: h2-above, below: h2-below)
    it
  }
  show heading.where(level: 3): it => {
    set text(size: h3-size)
    set block(above: h3-above, below: h3-below)
    it
  }

  // Lists & math
  set list(tight: true, spacing: 0.30em)
  set enum(tight: true, spacing: 0.30em)
  show math.equation: set text(font: math-font)

  // ------------------------------------------------------------
  // FRONT MATTER (Title • Authors • Affiliations • Thanks • Abstract)
  // ------------------------------------------------------------

  // Symbols used to mark affiliations in the order provided
  let aff_syms = ["*", "†", "‡", "§", "¶", "‖", "††", "‡‡", "§§", "¶¶"]

  // Build affiliations and authors from YAML at template time.
  let affs = [
    $for(affiliations)$(id: "$id$", name: "$name$")$sep$, $endfor$
  ]

  let authors = [
    $for(author)$( // fields may or may not exist; we guard later
      name: "$name$",
      corr: $if(corresponding)$true$else$false$endif$,
      email: $if(email)$"$email$"$else$none$endif$,
      affs: [ $for(author.affiliations)$"$author.affiliations$"$sep$, $endfor$ ]
    )$sep$, $endfor$
  ]

  // Look up a symbol for a given affiliation ref (id or name)
  let aff_symbol = (ref) => {
    let i = 0
    while i < affs.len() {
      if (affs.at(i).name == ref) or (affs.at(i).id == ref) {
        return aff_syms.at(i)
      }
      i += 1
    }
    "?"
  }

  // ==== Title line (with optional "thanks" footnote) ====
  $if(title)$
  align(center)[
    #set text(font: heading-font, size: h1-size + 2pt, weight: 600)
    $title$
    $if(thanks)$ #footnote{$thanks$} $endif$
  ]
  $endif$

  // ==== Authors (with punctuation superscripts + ✉ footnote for corresponding) ====
  $if(author)$
  v(0.5em)
  align(center)[
    #set text(size: body-size)
    #for (i, a) in authors.enumerate() [
      #a.name
      #if a.affs.len() > 0 [
        #for r in a.affs [ super[ #(aff_symbol(r)) ] ]
      ]
      #if a.corr and a.email != none [
        super[✉] #footnote(a.email)
      ]
      #if i < authors.len() - 1 [, ]
    ]
  ]
  $endif$

  // ==== Affiliation legend ====
  $if(affiliations)$
  v(0.25em)
  align(center)[
    #set text(size: body-size - 1pt)
    #for (i, a) in affs.enumerate() [
      super[ #(aff_syms.at(i)) ] #a.name
      #if i < affs.len() - 1 [ • ]
    ]
  ]
  $endif$

  // ==== Abstract ====
  $if(abstract)$
  v(0.9em)
  align(center)[ strong[Abstract] ]
  block(inset: (left: 0), above: 0.3em, below: 0.2em)[
    $abstract$
  ]
  $endif$

  // ==== Keywords / JEL ====
  $if(keywords)$$if(keywords)$
  v(0.5em)
  align(center)[
    *Keywords:* $for(keywords)$$keywords$$sep$, $endfor$
    $if(jel)$ • *JEL:* $for(jel)$$jel$$sep$, $endfor$ $endif$
  ]
  $endif$$endif$

  // Space before main body
  v(1.0em)

  // Render body
  body
}
