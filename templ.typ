#let templ(
  title: "",
  author: "",
  lang: "it",
  font: "Libertinus Serif",
  font-size: 10pt,
  code_font: "DejaVu Sans Mono",
  paper: "a4",
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
    v(3.8 * font-size, weak: true) + text(it) + v(0.2 * font-size)
  }
  show heading.where(level: 2): it => {
    v(0.8 * font-size) + text(it) + v(0.2 * font-size)
  }
  show heading.where(level: 3): it => {
    v(0.8 * font-size) + text(it) + v(0.2 * font-size)
  }

  set par(justify: true, linebreaks: "optimized")

  set figure(numbering: "1")
  set math.equation(numbering: "[1.1]")

  align(
    center,
    text(18pt, weight: "bold", title),
  )
  v(18pt, weak: true)

  align(
    center,
    box(inset: (y: 10pt), {
      text(11pt, weight: "semibold")[#author]
    }),
  )
  v(6pt, weak: true)

  // align(
  //   center,
  //   "Ultimo aggiornamento: "
  //     + text(
  //       datetime.today().display(),
  //     ),
  // )

  // pagebreak()

  // outline()

  // pagebreak()

  body
}
