// Organisationssatzung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "metadata.typ"

// The template prints the heading "Abstract" above the abstract. The title
// page of the statute starts with "Rechtsgrundlage" instead.
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
  title: metadata.title,
  footer-text: [Fassung vom #metadata.last-changed-short],
)

#include "chapters/01_allgemeines.typ"
#include "chapters/02_zentrale_orga.typ"
#include "chapters/03_dezentrale_orga.typ"
#include "chapters/04_vollversammlung.typ"
#include "chapters/05_vermoegen.typ"
#include "chapters/06_schlussbest.typ"
#include "chapters/07_unterschriften.typ"
