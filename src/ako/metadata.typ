// Daten der Arbeitskreisordnung: Datumsangaben, Felder und Text der Titelseite.

#import "../satzung.typ": datum

// Datum des STUPA-Beschlusses zu dieser Fassung.
#let last-changed = datum("beschluss", "XX.XX.20XX")
#let last-changed-short = "Entwurf vom 13.11.2026"

// Datum der Genehmigung durch das Präsidium. Lass den Platzhalter stehen,
// bis das Präsidium diese Fassung genehmigt.
#let accepted-university = datum("genehmigung", "XX.XX.20XX")

#let title = [Arbeitskreisordnung der \ Studierendenschaft der Hochschule Reutlingen (AKO)]
#let short-title = [Arbeitskreisordnung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vom STUPA beschlossen am*], [#last-changed],
  [*Vom Präsidium genehmigt am*], [#accepted-university],
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
    Auf Grund von § 65a Abs. 1 S. 1 des Gesetzes über die Hochschulen in
    Baden-Württemberg (Landeshochschulgesetz – LHG) in der Fassung vom
    1.~April 2014 (GBl. S. 99), zuletzt geändert durch Artikel 5 des Gesetzes
    vom 11. Dezember 2025 (GBl. 2025 Nr. 139), in Verbindung mit § 17 Abs. 5
    der Organisationssatzung der Studierendenschaft hat das
    Studierendenparlament der Hochschule Reutlingen am #last-changed die
    nachfolgende Ordnung als Satzung beschlossen.

    Die Hochschule Reutlingen hat die Ordnung durch Beschluss des Präsidiums
    am #accepted-university genehmigt.
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
