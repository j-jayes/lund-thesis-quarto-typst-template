
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

// Lund University PhD Thesis Template
// Typst adaptation of the LaTeX template

// Define a dedicated function to draw the datasheet
// Define a dedicated function to draw the datasheet
#let datasheet-page(
  author: "",
  department: "",
  address: (),
  defence-date: "",
  title: "",
  subtitle: "",
  abstract-en: "",
  keywords: "",
  issn: "",
  isbn-print: "",
  isbn-pdf: "",
  font-sans: "TeX Gyre Heros"
) = {
  // Helper for creating a form row
  #let form-row(label, content, height: auto, stroke: (bottom: 1pt)) = {
    rect(
      width: 100%,
      height: height,
      stroke: stroke,
      inset: (top: 6pt, bottom: 8pt, x: 4pt),
      [
        #text(size: 8pt)[*#label*] \
        #content
      ]
    )
  }

  page(
    margin: 20mm,
    [
      #align(center)[#text(font: font-sans, size: 8pt, weight: "bold")[DOKUMENTDATABLAD enl SIS 61 41 21]]
      #v(1em)

      #rect(width: 100%, stroke: 1pt)[
        // Top section: Organization and Document Info
        #grid(
          columns: (1fr, 1fr),
          gutter: 0pt,
          // Organization
          rect(
            width: 100%,
            stroke: (right: 1pt),
            form-row(
              "Organization",
              [
                #v(0.5em)
                #text(weight: "bold")[LUND UNIVERSITY] \
                #department \
                #address.join("\n")
              ],
              height: 4.5cm,
              stroke: (bottom: 1pt)
            ),
            // Author
            form-row(
              "Author(s)",
              [#v(1em) #author],
              stroke: none
            )
          ),
          // Document Name & Date
          grid(
            rows: (2.5cm, 2cm, auto),
            gutter: 0pt,
            form-row(
              "Document name",
              [#v(0.5em) #text(weight: "bold")[DOCTORAL DISSERTATION]],
              stroke: (bottom: 1pt)
            ),
            form-row(
              "Date of disputation",
              [#v(0.5em) #defence-date],
              stroke: (bottom: 1pt)
            ),
            form-row(
              "Sponsoring organization", [], stroke: none
            )
          )
        )

        // Title and Abstract
        form-row("Title and subtitle", [#v(0.5em) #title#if subtitle != "" [: #subtitle]])
        form-row("Abstract", [#v(0.5em) #abstract-en], height: 10cm)
        form-row("Key words", [#v(0.5em) #keywords])
        
        // Bottom Section
        form-row("Supplementary bibliographical information", [])
        grid(
          columns: (3fr, 1fr),
          gutter: 0pt,
          form-row(
            "ISSN and key title",
            [#v(0.5em) #issn],
            stroke: (right: 1pt)
          ),
          form-row(
            "ISBN",
            [#v(0.5em) #isbn-print (print) \ #isbn-pdf (pdf)]
          )
        )
        // ... continue for other fields like Price, Pages etc.
        
        // Signature line
        form-row("", [
          I, the undersigned, being the copyright owner...
          #v(2em)
          Signature #h(1fr) Date #h(1fr)
        ], stroke: none)
      ]
    ]
  )
}

// Define a reusable title page function
#let lund-title-page(full: true) = {
  page(
    margin: (top: 2cm, bottom: 2cm),
    [
      #v(3cm)
      #align(center)[
        // Use much larger font sizes like the LaTeX \HUGE
        #text(size: 28pt, weight: "bold")[#title] \
        #v(2mm)
        #text(size: 22pt)[#subtitle]
        
        #v(1fr)
        
        by #author
        
        #v(1fr)
        
        // Use the actual university logo
        #image("assets/LundUniversity_C2line_BLACK.svg", width: 25%)
        
        // Conditionally show the details only on the full page
        #if full {
          [
            #v(10mm)
            #text(size: 12pt)[
              #degree \
              Thesis advisors: #advisors \
              Faculty opponent: #opponent \
            ]
            
            #v(1cm)
            
            #text(size: 9pt)[
              #if defence-announcement != none [
                #defence-announcement
              ] else [
                To be presented, with the permission of the #faculty of Lund University, for public criticism in the #defence-room at the #department on #defence-date at #defence-time.
              ]
            ]
          ]
        } else {
          // This is the clever part: create the same spacing as the `full`
          // page but without any visible content, just like the LaTeX template.
          [
            #v(10mm)
            #block(height: 2.7cm) // Approximate height of the text block
            #v(1cm)
            #block(height: 2cm) // Approximate height of the announcement
          ]
        }
      ]
      #v(1fr)
    ]
  )
}

#let lund-thesis(
  // Basic thesis information
  title: "Title",
  subtitle: "Subtitle", 
  author: "Firstname Lastname",
  year: 2024,
  degree: "Thesis for the degree of Doctor of Philosophy",
  faculty: "Faculty of Science",
  department: "Department Name",
  address: ("Box XYZ", "SE--221 00 LUND", "Sweden"),
  advisors: "Prof. First Advisor, Dr. Second Advisor",
  opponent: "Prof. External Examiner",
  
  // Defense information
  defence-date: "2024-12-24",
  defence-time: "13:00",
  defence-room: "Lecture Hall Name",
  defence-announcement: none,
  
  // Publication details
  isbn-print: "1234567890",
  isbn-pdf: "0987654321", 
  issn: "1234-5678",
  
  // Abstract and keywords
  abstract-en: "",
  keywords: "",
  
  // Cover and funding
  cover-front: "",
  cover-back: "",
  funding: "",
  
  // Paper information
  papers: (),
  
  // Document settings
  paper-size: "g5", // Accepted values: "g5" (169mm × 239mm, Swedish standard) or "e5" (155mm × 220mm, alternative format)
  font-main: "TeX Gyre Termes", // Fallback for Garamond
  font-sans: "TeX Gyre Heros", // Uses "TeX Gyre Heros" as a fallback for Frutiger
  
  body
) = {
  
  // Set page dimensions based on format
  let page-dims = if paper-size == "g5" {
    (width: 169mm, height: 239mm)
  } else {
    (width: 155mm, height: 220mm)
  }
  
  // Set up document with Swedish academic formatting
  set document(
    title: title + ": " + subtitle,
    author: author,
    date: date(defence-date)
  )
  
  set page(
    paper: "custom",
    width: page-dims.width,
    height: page-dims.height,
    margin: (
      top: 18mm,
      bottom: 22mm, // Extra for footskip
      left: auto,
      right: auto,
    ),
    numbering: none
  )
  
  set text(
    font: font-main,
    size: 11pt,
    lang: "en"
  )
  
  set par(
    leading: 0.65em,
    spacing: 3mm,
    justify: true
  )
  
  // Define helper functions for thesis structure
  let roman(n) = {
    let values = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
    let numerals = ("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")
    let result = ""
    let num = n
    
    for (value, numeral) in values.zip(numerals) {
      while num >= value {
        result += numeral
        num -= value
      }
    }
    result.lower()
  }
  
  // Page 1: Title only
  page(
    margin: (top: 5cm, bottom: auto, left: auto, right: auto),
    [
      #align(center)[
        #text(size: 18pt)[#title]
        // Uncomment if you want subtitle on title page
        // #v(0.5em)
        // #text(size: 14pt)[#subtitle]
      ]
    ]
  )
  
  // Page 2: Empty (important for Swedish thesis format)
  pagebreak()
  []
  
  // Page 3: Full title page with defense information
  pagebreak()
  #lund-title-page(full: true)

  
  // Page 4: Datasheet (simplified version)
  pagebreak()
  #datasheet-page(
    author: author,
    department: department,
    address: address,
    defence-date: defence-date,
    title: title,
    subtitle: subtitle,
    abstract-en: abstract-en,
    keywords: keywords,
    issn: issn,
    isbn-print: isbn-print,
    isbn-pdf: isbn-pdf,
    font-sans: font-sans
  )
    
  // Page 5: Clean title page
  pagebreak()
  #lund-title-page(full: false) // Call the function again, but in "clean" mode

  // Page 6: Copyright and publication info
  pagebreak()
  page(
    margin: (top: 15mm, left: 20mm, right: 20mm),
    [
      A doctoral thesis at a university in Sweden takes either the form of a single,
      cohesive research study (monograph) or a summary of research papers
      (compilation thesis), which the doctoral student has written alone or together
      with one or several other author(s).
      
      In the latter case the thesis consists of two parts. An introductory text puts
      the research work into context and summarizes the main points of the papers.
      Then, the research publications themselves are reproduced, together
      with a description of the individual contributions of the authors. The
      research papers may either have been already published or are manuscripts at
      various stages (in press, submitted, or in draft).
      
      #v(1fr)
      
      #text(size: 9pt)[
        #if cover-front != "" [
          *Cover illustration front:* #cover-front
          
        ]
        #if cover-back != "" [
          *Cover illustration back:* #cover-back
          
        ]
        #if funding != "" [
          *Funding information:* #funding
          
        ]
        
        #v(5mm)
        
        © #author #year
        
        #faculty, #department
        
        ISBN: #isbn-print (print) \
        ISBN: #isbn-pdf (pdf) \
        ISSN: #issn
        
        Printed in Sweden by Media-Tryck, Lund University, Lund #year
      ]
    ]
  )
  
  // Dedication page (optional)
  pagebreak()
  page(
    margin: (top: 140pt, others: auto),
    [
      #align(right + top)[
        _Dedicated to my family_
      ]
    ]
  )
  
  // Start main content with Roman numbering
  pagebreak()
  set page(
    numbering: (..nums) => roman(nums.pos().first()),
    number-align: center
  )
  counter(page).update(1)
  
  // Table of Contents
  {
    set par(spacing: 0.65em)
    outline(
      title: [Contents],
      indent: auto,
      depth: 2
    )
  }
  
  pagebreak()
  
  // List of Publications
  [
    = List of publications <sec:paperlist>
    
    This thesis is based on the following publications, referred to by their Roman numerals:
    
    #v(2mm)
    
    #for (i, paper) in papers.enumerate() [
      #let num = [#roman(i + 1).upper()]
      
      #table(
        columns: (auto, 1fr),
        stroke: none,
        column-gutter: 5mm,
        [*#num*], [
          *#paper.title* \
          #paper.authors \
          #paper.journal
        ]
      )
      #v(6mm)
    ]
    
    All papers are reproduced with permission of their respective publishers.
  ]
  
  pagebreak()
  
  // Acknowledgements 
  [
    = Acknowledgements
    
    [Your acknowledgements text here]
  ]
  
  pagebreak()
  
  // Popular summaries in different languages
  [
    = Popular summary in English
    
    [Your English summary here]
  ]
  
  pagebreak()
  
  // Switch to Arabic numbering for main content
  set page(
    numbering: "1",
    number-align: center
  )
  counter(page).update(1)
  
  // Main thesis content
  body
}