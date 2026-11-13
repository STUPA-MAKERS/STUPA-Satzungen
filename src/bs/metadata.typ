// Daten der Beitragssatzung: Datumsangaben, Felder und Text der Titelseite.

#import "../satzung.typ": datum, hl, removed, show-changes

// Datum des STUPA-Beschlusses zu dieser Fassung. Das Präsidium genehmigt sie
// zusammen mit den anderen Satzungen.
#let last-changed = datum("beschluss", "XX.XX.20XX")
#let last-changed-short = datum("beschluss", "XX.XX.20XX", kurz: true)

// Datum der Genehmigung durch das Präsidium. Lass den Platzhalter stehen,
// bis das Präsidium diese Fassung genehmigt.
#let accepted-university = datum("genehmigung", "XX.XX.20XX")

// Datum der Fassung der Organisationssatzung, die diese Satzung zitiert.
#let orgs-date = "XX.XX.20XX"

#let title = [Beitragssatzung der \ Studierendenschaft der Hochschule Reutlingen]
#let short-title = [Beitragssatzung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vorangegangene Fassung vom*], [#"3. Dezember 2018"],
  [*Vom STUPA beschlossen am*], [#last-changed],
  [*Vom Präsidium genehmigt am*], [#accepted-university],
)

// Text der Titelseite. Die Vorlage setzt die erste Überschrift, siehe
// bs.typ.
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
    Auf Grund von § 65a Abs. 1 Satz 1 und Abs. 5 des Landeshochschulgesetzes
    (LHG) in der Fassung vom 1.~April 2014 (GBl. S. 99), zuletzt geändert
    durch Artikel 5 des Gesetzes vom 11. Dezember 2025 (GBl. 2025 Nr. 139),
    sowie des § 31 Abs. 2 der Organisationssatzung der Studierendenschaft der
    Hochschule Reutlingen vom #orgs-date hat das Studierendenparlament am
    #last-changed die nachstehende Beitragssatzung beschlossen.

    Das Präsidium der Hochschule Reutlingen hat die Beitragssatzung am
    #accepted-university gemäß § 65b Abs. 6 S. 3 des
    Landeshochschulgesetzes genehmigt.
  ]

  // Die Vorfassung hatte hier eine Präambel zur männlichen Sprachform.
  // Die Satzung verwendet keine männlichen Bezeichnungen. Die Präambel
  // entfällt.
  if show-changes {
    title-heading[#removed[Präambel]]
    removed[
      Im Folgenden wird aus Gründen der besseren Lesbarkeit ausschließlich die
      männliche Form verwendet. Es können alle Amts-, Status- und
      Funktionsbezeichnungen, die in dieser Satzung in der männlichen
      Sprachform verwendet werden, in der entsprechenden weiblichen Sprachform
      geführt werden.
    ]
  }

  place(bottom + left, data)
}
