// Beitragssatzung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "bs/metadata.typ"

// Die Vorlage setzt über den Abstract die Überschrift "Abstract". Die
// Titelseite der Satzung beginnt stattdessen mit "Rechtsgrundlage".
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
  footer-text: [Fassung vom #metadata.last-changed-short],
)

#include "bs/satzung-text.typ"
#include "bs/unterschriften.typ"
