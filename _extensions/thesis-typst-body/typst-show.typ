#show: thesis_body_template.with(
  body-font: "$body-font$",
  body-size: $body-size$,
  line-height: $line-height$,               // will use 1.15em if you don’t override in QMD
  paragraph-indent: $paragraph-indent$,
  paragraph-spacing: $paragraph-spacing$,
  justify: $if(justify)$$justify$$else$true$endif$,
  hyphenate: $if(hyphenate)$$hyphenate$$else$true$endif$,

  heading-font: "$heading-font$",
  heading-smallcaps: $if(heading-smallcaps)$$heading-smallcaps$$else$false$endif$,
  heading-numbering: "$heading-numbering$",

  h1-size: $h1-size$, h1-above: $h1-above$, h1-below: $h1-below$,
  h2-size: $h2-size$, h2-above: $h2-above$, h2-below: $h2-below$,
  h3-size: $h3-size$, h3-above: $h3-above$, h3-below: $h3-below$,

  math-font: "$math-font$"
)


// Smaller, indented block quote (like your screenshot)
#let blockquote(body) = [
  #set text(size: 0.92em)
  #set par(leading: 1.12em, spacing: 0.40em)
  #block(inset: (left: 1.5em, top: 0.25em, bottom: 0.25em))[#body]
]

// Raw/code blocks stay readable without ballooning line height
#show raw.where(block: true): it => [
  #set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )
  #set par(leading: 1.10em, spacing: 0.35em)
  #it
]
