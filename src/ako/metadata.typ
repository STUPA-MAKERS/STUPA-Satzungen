// Daten der Arbeitskreisordnung: Datumsangaben, Felder und Text der Titelseite.

#import "../satzung.typ": datum

// Datum des STUPA-Beschlusses zu dieser Fassung.
#let last-changed = datum("beschluss", "XX.XX.20XX")
#let last-changed-short = "Entwurf vom 13.11.2026"

// Die Ordnung ist keine Satzung. Das Präsidium genehmigt sie nicht.

#let title = [Arbeitskreisordnung der \ Studierendenschaft der Hochschule Reutlingen (AKO)]
#let short-title = [Arbeitskreisordnung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vom STUPA beschlossen am*], [#last-changed],
)

// Text der Titelseite. Die Vorlage setzt die erste Überschrift, siehe
// ako.typ.
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
    Auf Grund von § 17 Abs. 5 der Organisationssatzung der
    Studierendenschaft der Hochschule Reutlingen hat das
    Studierendenparlament am #last-changed die nachfolgende Ordnung
    beschlossen.

    Die Ordnung regelt die innere Organisation des Studierendenparlamentes.
    Sie ist keine Satzung im Sinne des § 65a Abs. 1 des
    Landeshochschulgesetzes (LHG) und bedarf deshalb nicht der Genehmigung
    des Präsidiums nach § 65b Abs. 6 LHG.
  ]

  title-heading[Zweck der Ordnung]
  [
    Die Ordnung bestimmt die ständigen Arbeitskreise des
    Studierendenparlamentes und ihre Aufgaben. Sie regelt außerdem, welche
    Aufgaben und Pflichten alle Arbeitskreise haben und wie sie
    zusammenarbeiten. Sie beruht in ihrem Aufbau auf der Referateordnung der
    Verfassten Studierendenschaft der Universität Heidelberg, die mit deren
    Zustimmung als Vorlage diente.
  ]

  place(bottom + left, data)
}
