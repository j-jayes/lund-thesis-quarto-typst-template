// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#show: doc => lund-thesis(
  title: $if(title)$"$title$"$else$"Title"$endif$,
  subtitle: $if(subtitle)$"$subtitle$"$else$"Subtitle"$endif$,
  author: $if(author)$"$author$"$else$"Author Name"$endif$,
  year: $if(year)$$year$$else$2024$endif$,
  degree: $if(degree)$"$degree$"$else$"Thesis for the degree of Doctor of Philosophy"$endif$,
  faculty: $if(faculty)$"$faculty$"$else$"Faculty of Science"$endif$,
  department: $if(department)$"$department$"$else$"Department Name"$endif$,
  address: $if(address)$($for(address)$"$address$"$sep$, $endfor$)$else$("Box XYZ", "SE--221 00 LUND", "Sweden")$endif$,
  advisors: $if(advisors)$"$advisors$"$else$"Prof. First Advisor"$endif$,
  opponent: $if(opponent)$"$opponent$"$else$"Prof. External Examiner"$endif$,
  
  defence-date: $if(defence-date)$"$defence-date$"$else$"2024-12-24"$endif$,
  defence-time: $if(defence-time)$"$defence-time$"$else$"13:00"$endif$,
  defence-room: $if(defence-room)$"$defence-room$"$else$"Lecture Hall"$endif$,
  defence-announcement: $if(defence-announcement)$"$defence-announcement$"$else$none$endif$,
  
  isbn-print: $if(isbn-print)$"$isbn-print$"$else$"978-0-0000-0000-0"$endif$,
  isbn-pdf: $if(isbn-pdf)$"$isbn-pdf$"$else$"978-0-0000-0000-1"$endif$,
  issn: $if(issn)$"$issn$"$else$"0000-0000"$endif$,
  
  abstract-en: $if(abstract-en)$[$abstract-en$]$else$[No abstract provided.]$endif$,
  keywords: $if(keywords)$"$keywords$"$else$""$endif$,
  
  cover-front: $if(cover-front)$"$cover-front$"$else$""$endif$,
  cover-back: $if(cover-back)$"$cover-back$"$else$""$endif$,
  funding: $if(funding)$"$funding$"$else$""$endif$,
  
  papers: $if(papers)$($for(papers)$(
    title: "$papers.title$",
    authors: "$papers.authors$",
    journal: "$papers.journal$",
  )$sep$, $endfor$)$else$()$endif$,
  
  paper-size: $if(paper-size)$"$paper-size$"$else$"g5"$endif$,
  font-main: $if(font-main)$"$font-main$"$else$"TeX Gyre Termes"$endif$,
  font-sans: $if(font-sans)$"$font-sans$"$else$"TeX Gyre Heros"$endif$,
  
  doc
)