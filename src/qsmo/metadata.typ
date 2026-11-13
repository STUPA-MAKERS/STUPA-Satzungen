// Document metadata of the QSM-Ordnung: dates, title page fields and the
// title page text.

#import "common.typ": offen

// Date of the STUPA decision on this version.
#let last-changed = "XX.XX.20XX"
#let last-changed-short = "Entwurf vom 13.11.2026"

// The Ordnung is an internal rule of the Studierendenschaft. It needs no
// approval by the Präsidium.

#let title = [QSM-Ordnung der \ Studierendenschaft der Hochschule Reutlingen (QSMO)]
#let short-title = [QSM-Ordnung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vom STUPA beschlossen am*], [#last-changed],
)

// The text of the title page. The template prints its first heading, see
// qsmo.typ.
#let first-heading = "Rechtsgrundlage"
#let front-text = {
  // The title page of the template sets no space between paragraphs.
  set par(spacing: 0.8em)
  let title-heading(body) = block(
    above: 2em,
    below: 1em,
    text(font: "Blender", size: 14.346pt, weight: "bold", body),
  )

  [
    Auf Grund von § 65a Abs. 1 S. 1 des Gesetzes über die Hochschulen in
    Baden-Württemberg (Landeshochschulgesetz – LHG) in der Fassung vom
    1.~April 2014 (GBl. S. 99), zuletzt geändert durch Artikel 5 des Gesetzes
    vom 11. Dezember 2025 (GBl. 2025 Nr. 139), in Verbindung mit § 1 Abs. 2
    des Qualitätssicherungsgesetzes (QualSiG) vom 5.~Mai 2015 (GBl. S. 313),
    zuletzt geändert durch Artikel 4 des Gesetzes vom 11. Dezember 2025
    (GBl. 2025 Nr. 139), hat das Studierendenparlament der Hochschule
    Reutlingen am #last-changed die nachfolgende Ordnung als interne Ordnung der Studierendenschaft beschlossen.
  ]

  title-heading[Zweck der Ordnung]
  [
    Die Ordnung regelt, wie die Studierendenschaft ihren Vorschlag für die
    Vergabe der studentischen Qualitätssicherungsmittel erstellt: wer Anträge
    stellen kann, welche Fristen gelten, nach welchen Grundsätzen das
    Studierendenparlament entscheidet und wie der Vorschlag an das Präsidium
    geht. Sie beruht in ihrem Aufbau auf der QSM-Ordnung der Verfassten
    Studierendenschaft der Universität Heidelberg, die mit deren Zustimmung
    als Vorlage diente.
  ]

  place(bottom + left, data)
}
