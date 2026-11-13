// Gemeinsame Importe der Finanzordnung.

#import "../satzung.typ": *

// Liste mit den Punkten "1.", "2.", ... in einem Absatz.
#let nummern(body) = {
  set enum(numbering: "1.", full: false)
  body
}
