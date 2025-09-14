// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}

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

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

#show: thesis_body_template.with(
  body-font: "Adobe Garamond ProAdobeGaramondPro",
  body-size: 11pt,
  line-height: 1.20em,               // will use 1.15em if you don’t override in QMD
  paragraph-indent: 0pt,
  paragraph-spacing: 2em,
  justify: true,
  hyphenate: true,

  heading-font: "Frutiger LT StdFrutigerLTStd",
  heading-smallcaps: false,
  heading-numbering: "1.1.a",

  h1-size: 18pt, h1-above: 1.6em, h1-below: 0.8em,
  h2-size: 12pt, h2-above: 1.2em, h2-below: 0.6em,
  h3-size: 11pt, h3-above: 1.0em, h3-below: 0.5em,

  math-font: "New Computer Modern Math"
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

#footnote[I gratefully acknowledge the support of colleagues, mentors, friends, and family whose guidance and encouragement made this work possible.]

= Level 1
<level-1>
Paragraph one. Paragraph two after a blank line.

== Level 2
<level-2>
- Bullet
- Bullet

=== Level 3
<level-3>
Inline math $x^2 + y^2 = z^2$.

While displacement may have many causes, our interest in technological displacement requires a further elaboration of our conceptual framework: how to attribute labor displacement to technological change. In the best case, authors of studies would observe employers stating that workers are being displaced because of the adoption of new technology. This is an exceedingly rare occurrence. Instead, most authors look for the temporal coincidence of technological adoption and displacement of workers whose jobs overlapped with the new technology.

Testing testing one two, lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
