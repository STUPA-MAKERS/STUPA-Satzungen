// Daten der Geschäftsordnung: Datumsangabe, Feld und Text der Titelseite.

#import "../satzung.typ": datum

// Datum des STUPA-Beschlusses zu dieser Fassung. Die Geschäftsordnung ist
// keine Satzung. Sie hat deshalb kein Datum für eine Genehmigung.
#let last-changed = datum("beschluss", "XX.XX.20XX")
#let last-changed-short = "Entwurf vom 13.11.2026"

#let title = [Geschäftsordnung des \ Studierendenparlamentes der Hochschule Reutlingen (GO)]
#let short-title = [Geschäftsordnung des Studierendenparlamentes]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vom STUPA beschlossen am*], [#last-changed],
)

// Text der Titelseite. Die Vorlage setzt die erste Überschrift, siehe go.typ.
#let first-heading = "Rechtsgrundlage"
#let front-text = {
  // Die Titelseite der Vorlage setzt keinen Abstand zwischen Absätzen.
  set par(spacing: 0.8em)
  let title-heading(body) = block(
    above: 2em,
    below: 1em,
    text(font: "Blender", size: 14.346pt, weight: "bold", body),
  )

  [
    Auf Grund von § 11 und § 12 Nr. 2 der Organisationssatzung der
    Studierendenschaft der Hochschule Reutlingen hat das Studierendenparlament
    am #last-changed die nachfolgende Geschäftsordnung beschlossen.

    Die Geschäftsordnung ist keine Satzung im Sinne des § 65a Abs. 1 des
    Landeshochschulgesetzes. Sie bedarf nicht der Genehmigung des Präsidiums
    der Hochschule.
  ]

  title-heading[Zweck der Geschäftsordnung]
  [
    Die Geschäftsordnung regelt den Geschäftsgang des Studierendenparlamentes:
    die Sitzungen, die Anträge und ihre Beratung, die Abstimmungen und Wahlen
    und das Protokoll. Sie regelt außerdem den Verlust des Mandats durch
    Fehlen nach § 15 der Organisationssatzung und die Aufwandsentschädigungen
    nach § 34 Abs. 2 der Organisationssatzung.
  ]

  place(bottom + left, data)
}
