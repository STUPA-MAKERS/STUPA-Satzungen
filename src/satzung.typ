// Layout der Satzungen. Es baut auf der Vorlage HSRTReport auf.
//
// Gliederung:
//   =   Abschnitt        Nummer "I.", "II.", ... mit einer Linie darunter
//   ==  Unterabschnitt   zeigt "Erster Unterabschnitt: <Titel>". Das
//                        Inhaltsverzeichnis zeigt nur den Titel.
//   === Paragraph        Nummer "§ 1", "§ 2", ... durch die ganze Satzung

#import "hsrtreport/src/lib.typ": *

// Markiert Text, der gegenüber der Vorfassung neu ist. Der Standard ist die
// saubere Fassung. `typst compile --input changes=true` zeigt die Änderungen.
// `tools/aenderungen.py` setzt die Markierungen in den Kapiteln.
#let show-changes = sys.inputs.at("changes", default: "false") == "true"
#let hl(body) = if show-changes {
  highlight(fill: hsrt-yellow.lighten(40%), body)
} else {
  body
}

// Enthält Text, den diese Fassung streicht. Die Änderungsfassung zeigt ihn
// durchgestrichen. Die saubere Fassung lässt ihn weg.
#let removed(body) = if show-changes {
  highlight(fill: hsrt-yellow.lighten(40%), strike(body))
}

// Ein Datum für Beschluss oder Genehmigung. Solange `wert` ein Platzhalter mit
// "XX" ist, steht an der Stelle ein Formularfeld. Alle Felder mit dem gleichen
// `key` haben im PDF den gleichen Inhalt. `tools/felder.py` schreibt die
// Felder in das PDF. Die Stellen dafür liest `typst eval` über das Label
// `<datumsfeld>`. `kurz: true` macht ein schmales Feld für die Fußzeile.
#let datum(key, wert, kurz: false) = if "XX" not in wert {
  wert
} else {
  context {
    let breite = measure(if kurz [30.09.2026] else [30. September 2026]).width
    let groesse = text.size
    box(
      width: breite,
      height: 1.3 * groesse,
      baseline: 0.35 * groesse,
      fill: luma(235),
      context {
        let stelle = here().position()
        [#metadata((
          key: key,
          page: stelle.page,
          x: stelle.x.pt(),
          y: stelle.y.pt(),
          width: breite.pt(),
          height: 1.3 * groesse.pt(),
          size: groesse.pt(),
        )) <datumsfeld>]
      },
    )
  }
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

// Die Zahl der Paragraphen vor einer Stelle.
#let _paragraphs-before(location) = query(
  heading.where(level: 3).before(location, inclusive: false),
).len()

// Die letzte Überschrift einer Ebene, die auf oder vor der aktuellen Seite
// beginnt.
#let _open-heading(level) = {
  let page-number = here().page()
  let found = query(heading.where(level: level))
    .filter(it => it.outlined and it.location().page() <= page-number)
  if found.len() > 0 { found.last() }
}

// Kopfzeile: links der Titel, rechts der aktuelle Abschnitt und
// Unterabschnitt.
#let _header(title) = context {
  let chapter = _open-heading(1)
  let section = _open-heading(2)
  // Ein Unterabschnitt zählt nur im aktuellen Abschnitt.
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
      // Ein Abschnitt ohne Nummer ist die Unterschriftenseite.
      if chapter.numbering == none {
        upper(chapter.body)
      } else {
        let number = counter(heading).at(chapter.location()).at(0)
        upper[#numbering("I.", number) #chapter.body]
      }
      if section != none { linebreak() + section.body }
    },
  ))
}

// Inhaltsverzeichnis im Stil der Vorlage. Ein Unterabschnitt hat kein Präfix
// und steht auf dem Einzug eines Paragraphen.
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

  // Die Paragraphen zählen durch die ganze Satzung. Ein Abschnitt oder ein
  // Unterabschnitt setzt die tieferen Ebenen zurück. Deshalb stellt die
  // Regel den Zähler danach wieder her.
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

  // Absätze haben die Nummer "(1)", die Punkte darunter "a)".
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

  // Die Titelseite ist Seite 1, wie in der LaTeX-Fassung.
  counter(page).update(2)
  satzung-toc()
  pagebreak(weak: true)

  body
}

// Liste mit den Punkten "a)", "b)", ...
#let alpha-list(..items) = enum(numbering: "a)", ..items)
// Liste mit den Punkten "1.", "2.", ...
#let num-list(..items) = enum(numbering: "1.", ..items)

// Unterschriftenseite für alle Satzungen. Sie ist ein Abschnitt ohne Nummer:
// Sie steht im Inhaltsverzeichnis und in der Kopfzeile, gehört aber nicht zum
// nummerierten Text. Sie hat zwei Blöcke: Ausfertigung durch den Vorsitz und
// Genehmigung durch das Präsidium. `beschlossen-am` ist das Datum des
// Beschlusses des STUPA, `genehmigt-am` das Datum der Genehmigung.
// `markiert: true` zeigt die Seite in der Änderungsfassung als neu.
// `genehmigt-am: none` lässt den Block für die Genehmigung weg. Das gilt für
// Ordnungen, die keine Satzung sind.
#let unterschriftenseite(beschlossen-am, genehmigt-am, markiert: false) = {
  let neu(body) = if markiert { hl(body) } else { body }
  // Ein Block: die Bedeutung der Unterschrift, die Zeilen für Ort, Datum und
  // Unterschrift und die Funktion der Person.
  let unterschrift(bedeutung, funktion) = block(breakable: false, above: 2.5cm, {
    neu(bedeutung)
    v(2.5cm)
    grid(
      columns: (5cm, 1fr),
      column-gutter: 1.5cm,
      row-gutter: 0.4em,
      line(length: 100%, stroke: 0.5pt), line(length: 100%, stroke: 0.5pt),
      text(size: sizes.small)[Ort, Datum], text(size: sizes.small)[Unterschrift],
      [], strong(neu(funktion)),
    )
  })

  pagebreak(weak: true)
  heading(level: 1, numbering: none, if genehmigt-am == none { neu[Ausfertigung] } else { neu[Ausfertigung und Genehmigung] })
  unterschrift(
    [*Ausgefertigt* nach Beschluss des Studierendenparlamentes vom #beschlossen-am.],
    [Die:Der Vorsitzende der Studierendenschaft der Hochschule Reutlingen],
  )
  if genehmigt-am != none {
    unterschrift(
      [*Genehmigt* durch Beschluss des Präsidiums vom #genehmigt-am.],
      [Die:Der Kanzler:in der Hochschule Reutlingen],
    )
  }
}
