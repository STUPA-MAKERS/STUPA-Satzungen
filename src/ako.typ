// Arbeitskreisordnung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "ako/metadata.typ"

// Die Vorlage setzt über den Abstract die Überschrift "Abstract". Die
// Titelseite der Ordnung beginnt stattdessen mit "Rechtsgrundlage".
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

#include "ako/chapters/01_allgemeines.typ"
#include "ako/chapters/02_arbeitskreise.typ"
#include "ako/chapters/03_schlussbest.typ"
#include "ako/chapters/04_unterschriften.typ"
