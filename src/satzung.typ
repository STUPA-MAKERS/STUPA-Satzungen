// Layout rules of the statute on top of the HSRTReport template.
//
// Structure:
//   =   Abschnitt        numbered "I.", "II.", ... with a rule below
//   ==  Unterabschnitt   prints "Erster Unterabschnitt: <title>", the table
//                        of contents shows only the title
//   === Paragraph        numbered "§ 1", "§ 2", ... through the whole statute

#import "hsrtreport/src/lib.typ": *

// Highlights the text that changed from the previous version. The clean
// version is the default, `typst compile --input changes=true` shows the
// changes. `tools/aenderungen.py` sets the marks in the chapters.
#let show-changes = sys.inputs.at("changes", default: "false") == "true"
#let hl(body) = if show-changes {
  highlight(fill: hsrt-yellow.lighten(40%), body)
} else {
  body
}

// Marks text that this version deletes. The version with changes shows it
// struck through, the clean version leaves it out.
#let removed(body) = if show-changes {
  highlight(fill: hsrt-yellow.lighten(40%), strike(body))
}

#let _ordinals = ("Erster", "Zweiter", "Dritter", "Vierter", "Fünfter", "Sechster")

#let _numbering(..numbers) = {
  let numbers = numbers.pos()
  if numbers.len() == 1 {
    numbering("I.", numbers.at(0))
  } else if numbers.len() == 2 {
    [#_ordinals.at(numbers.at(1) - 1) Unterabschnitt:]
  } else {
    [§~#numbers.last()]
  }
}

// The § count before a location.
#let _paragraphs-before(location) = query(
  heading.where(level: 3).before(location, inclusive: false),
).len()

// The last heading of a level that starts on or before the current page.
#let _open-heading(level) = {
  let page-number = here().page()
  let found = query(heading.where(level: level))
    .filter(it => it.numbering != none and it.location().page() <= page-number)
  if found.len() > 0 { found.last() }
}

// The running head: the title on the left, the open Abschnitt and
// Unterabschnitt on the right.
#let _header(title) = context {
  let chapter = _open-heading(1)
  let section = _open-heading(2)
  // An Unterabschnitt counts only inside the Abschnitt that is open.
  if section != none and chapter != none {
    let s = section.location().position()
    let c = chapter.location().position()
    if s.page < c.page or (s.page == c.page and s.y < c.y) { section = none }
  }
  text(font: heading-font, size: sizes.normal, fill: head-foot-color, grid(
    columns: (1fr, auto),
    align: (left, right),
    title,
    if chapter == none {
      [INHALT]
    } else {
      let number = counter(heading).at(chapter.location()).at(0)
      upper[#numbering("I.", number) #chapter.body]
      if section != none { linebreak() + section.body }
    },
  ))
}

// The table of contents. It has the style of the template, but shows no
// prefix for an Unterabschnitt and keeps it at the indent of a paragraph.
#let satzung-toc() = {
  heading(level: 1, numbering: none, outlined: false)[Inhaltsverzeichnis]
  v(18.94pt)

  show outline.entry: set block(above: 11.07pt)
  show outline.entry.where(level: 1): set block(above: 2em)
  show outline.entry.where(level: 1): set text(weight: "bold")
  show outline.entry.where(level: 2): set text(weight: "bold")
  show outline.entry.where(level: 1): set outline.entry(fill: none)
  show outline.entry: it => {
    let indent = if it.level == 1 { 0pt } else { 1.5em }
    let prefix = if it.level == 2 { none } else { it.prefix() }
    link(it.element.location(), pad(left: indent, it.indented(prefix, it.inner(), gap: 1em)))
  }
  set outline.entry(fill: repeat(gap: 0.35em)[.])
  set text(font: heading-font, fill: link-color)
  outline(title: none, indent: 0pt, depth: 3)
}

#let satzung(title: none, footer-text: none, body) = {
  set heading(numbering: _numbering, supplement: none)

  // The § count runs through the whole statute. An Abschnitt or an
  // Unterabschnitt resets the deeper heading levels, so the count is put
  // back after each of them.
  show heading.where(level: 1): it => {
    it
    block(above: -0.6em, below: 0pt, sticky: true, line(length: 100%, stroke: 0.5mm))
    context {
      let count = _paragraphs-before(here())
      counter(heading).update((..n) => (n.pos().at(0), 0, count))
    }
  }
  show heading.where(level: 2): it => {
    it
    context {
      let count = _paragraphs-before(here())
      counter(heading).update((..n) => (n.pos().at(0), n.pos().at(1, default: 0), count))
    }
  }

  // Absätze are numbered "(1)", the items below them "a)".
  set enum(full: true, numbering: (..n) => {
    let n = n.pos()
    if n.len() == 1 { numbering("(1)", n.at(0)) } else { numbering("a)", n.last()) }
  })

  set page(
    header: _header(title),
    footer: page-footer(
      author: if show-changes [#footer-text · Änderungsfassung] else { footer-text },
      numbering: "1",
      logos: footer-logo-names("stupa"),
    ),
  )

  // The title page is page 1, as in the LaTeX version.
  counter(page).update(2)
  satzung-toc()
  pagebreak(weak: true)

  body
}

// A list with the items "a)", "b)", ...
#let alpha-list(..items) = enum(numbering: "a)", ..items)
// A list with the items "1.", "2.", ...
#let num-list(..items) = enum(numbering: "1.", ..items)
