// Geschäftsordnung des Studierendenparlamentes der Hochschule Reutlingen.

#import "satzung.typ": *
#import "go/metadata.typ"

// Die Vorlage setzt über den Abstract die Überschrift "Abstract". Die
// Titelseite der Geschäftsordnung beginnt stattdessen mit "Rechtsgrundlage".
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

#include "go/chapters/01_allgemeines.typ"
#include "go/chapters/02_sitzungen.typ"
#include "go/chapters/03_beratung.typ"
#include "go/chapters/04_abstimmungen.typ"
#include "go/chapters/05_protokoll.typ"
#include "go/chapters/06_aufwand.typ"
#include "go/chapters/07_schlussbest.typ"
#include "go/chapters/08_unterschriften.typ"
