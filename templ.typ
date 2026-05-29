#let thesis-front-page(
  university: "Università degli Studi di Udine",
  department: none,
  faculty: none,
  degree-type: "Corso di Laurea Magistrale in",
  course: "Informatica",
  title: "Il Titolo Della Tua Bellissima Tesi di Laurea",
  subtitle: none, // Set to a string if you have a subtitle
  candidates: "Nome Cognome",
  academic-year: "2025/2026",
  logo-path: "polloPallido.jpg",
) = {
  if logo-path != none {
    place(
      center + horizon,
      dx: 0mm, dy: 0mm,
      image(logo-path, width: 80%)
    )
  }

  align(center)[
    #text(size: 16pt, weight: "bold", upper(university))

    #v(0.2em)
    #line(length: 60%, stroke: 0.5pt)
    #v(0.2em)

    #if faculty != none [
      Facoltà di #faculty
    ] else if department != none [
      Dipartimento di #department
    ]

    #v(0.5em)
    #degree-type #course

    #v(1fr)

    // Main Title
    #text(size: 24pt, weight: "bold")[#title]

    // Subtitle
    #if subtitle != none {
      v(1em)
      text(size: 18pt, style: "italic")[#subtitle]
    }

    #v(1fr)

    #align(center, text(datetime.today().display("[day]/[month]/[year]")))

    #v(1fr)

    #align(center)[
      #stack(
        dir: ttb,
        spacing: 1em,
        ..candidates
      )
    ]

    #v(1fr)

    // Academic Year Footer
    #line(length: 60%, stroke: 0.5pt)
    #v(0.5em)
    #text(size: 12pt)[Anno Accademico #academic-year]
  ]
}

#let templ(
  title: "",
  author: "",
  lang: "it",
  font: "Libertinus Serif",
  font-size: 10pt,
  code_font: "DejaVu Sans Mono",
  paper: "a4",
  front-page: none,
  body,
) = {
  set document(title: title, author: author)
  set text(
    font: font,
    size: font-size,
    ligatures: false,
    lang: lang,
  )
  show raw: set text(font: code_font)
  set page(
    paper: paper,
    numbering: "1",
  )

  set heading(numbering: "1.")

  show heading.where(level: 1): it => {
    pagebreak() + text(it) + v(0.2 * font-size)
  }
  show heading.where(level: 2): it => {
    v(0.8 * font-size) + text(it) + v(0.2 * font-size)
  }
  show heading.where(level: 3): it => {
    v(0.8 * font-size) + text(it) + v(0.2 * font-size)
  }

  set par(justify: true, linebreaks: "optimized")

  set figure(numbering: "1")
  set math.equation(numbering: none)

  set page(numbering: none)

  if front-page != none {
    front-page
  } else {
    align(
      center,
      text(18pt, weight: "bold", title),
    )
    v(18pt, weak: true)

    align(
      center,
      box(inset: (y: 10pt), {
        if type(author) == array {
          text(11pt, weight: "semibold")[#author.join(linebreak())]
        } else {
          text(11pt, weight: "semibold")[#author]
        }
      }),
    )
    v(6pt, weak: true)
  }

  set page(numbering: "i")

  // pagebreak(to: "odd")

  counter(page).update(1)
  outline()

  counter(page).update(1)
  set page(numbering: "1")
  body
}
