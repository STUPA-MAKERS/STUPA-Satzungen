// Beitragssatzung der Studierendenschaft der Hochschule Reutlingen.

#import "satzung.typ": *
#import "bs/metadata.typ"

// The template prints the heading "Abstract" above the abstract. The title
// page of the Satzung starts with "Rechtsgrundlage" instead.
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
