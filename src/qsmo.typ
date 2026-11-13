// QSM-Ordnung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "qsmo/metadata.typ"

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
  footer-text: [#metadata.last-changed-short],
)

#include "qsmo/chapters/01_allgemeines.typ"
#include "qsmo/chapters/02_verwendung.typ"
#include "qsmo/chapters/03_verfahren.typ"
#include "qsmo/chapters/04_schlussbest.typ"
#include "qsmo/chapters/05_unterschriften.typ"
