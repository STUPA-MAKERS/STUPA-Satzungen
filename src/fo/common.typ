// Shared imports of the Finanzordnung.

#import "../satzung.typ": *

// A list with the items "1.", "2.", ... inside an Absatz.
#let nummern(body) = {
  set enum(numbering: "1.", full: false)
  body
}
