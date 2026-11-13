// Finanzordnung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "fo/metadata.typ"

// The template prints the heading "Abstract" above the abstract. The title
// page of the Ordnung starts with "Rechtsgrundlage" instead.
#show "Abstract": metadata.first-heading

#show: hsrtreport.with(
  title: metadata.title,
  author: "STUPA der Hochschule Reutlingen",
  variant: "stupa",
  abstract: metadata.front-text,
  data: (),
  show-toc: false,
)

#show: satzung.with(
  title: metadata.short-title,
  footer-text: [Stand #metadata.last-changed-short],
)

#include "fo/chapters/01_allgemeines.typ"
#include "fo/chapters/02_haushaltsplan.typ"
#include "fo/chapters/03_feststellung.typ"
#include "fo/chapters/04_ausfuehrung.typ"
#include "fo/chapters/05_kassenfuehrung.typ"
#include "fo/chapters/06_verwendung.typ"
#include "fo/chapters/07_schlussbest.typ"
#include "fo/chapters/08_unterschriften.typ"
