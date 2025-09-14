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

  body
) = {
  // Body text
  set text(font: body-font, size: body-size, hyphenate: hyphenate)
  set par(
    leading: line-height,              // line spacing within paragraphs
    justify: justify,
    first-line-indent: paragraph-indent,
    spacing: paragraph-spacing         // space between paragraphs
  )

  // Headings (unchanged)
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
  // (Remove any old 'set list(spacing: auto)' line.)
  set list(tight: true, spacing: 0.30em)
  set enum(tight: true, spacing: 0.30em)

  show math.equation: set text(font: math-font)

  // Render body
  body
}
