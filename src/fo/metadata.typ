// Daten der Finanzordnung: Datumsangaben, Felder und Text der Titelseite.

#import "common.typ": hl, removed, datum, show-changes

// Datum des STUPA-Beschlusses zu dieser Fassung.
#let last-changed = datum("beschluss", "XX. Monat 20XX")
#let last-changed-short = datum("beschluss", "XX. Monat 20XX", kurz: true)

// Datum der Genehmigung durch das Präsidium. Lass den Platzhalter stehen,
// bis das Präsidium diese Fassung genehmigt.
#let accepted-university = datum("genehmigung", "XX. Monat 20XX")

// Datum der Fassung der Organisationssatzung, die diese Ordnung zitiert.
#let orgs-date = "XX. Monat 20XX"

#let title = [Finanzordnung der \ Studierendenschaft der Hochschule Reutlingen]
#let short-title = [Finanzordnung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vorangegangene Fassung vom*], [#"12. Dezember 2018"],
  [*Vom STUPA #removed[angenommen] #hl[beschlossen] am*], [#last-changed],
  [*Vom Präsidium genehmigt am*], [#accepted-university],
)

// Text der Titelseite. Die Vorlage setzt die erste Überschrift, siehe
// fo.typ.
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
    Auf Grund von § 65a Abs. 1 Satz 1, 2. Halbsatz und #removed[Abs. 3 Satz 2]
    #hl[§ 65b Abs. 1] des Landeshochschulgesetzes (LHG) #removed[vom 1. Januar 2005 (GBl. S. 1), in
    der Fassung vom 8. April 2014 (GBl. S. 99 ff.),] #hl[in der Fassung vom
    1.~April 2014 (GBl. S. 99), zuletzt geändert durch Artikel 5 des Gesetzes
    vom 11. Dezember 2025 (GBl. 2025 Nr. 139),] sowie der
    §§ #removed[29] #hl[30] ff. der
    Organisationssatzung der Studierendenschaft der Hochschule Reutlingen
    (OrgS) vom #orgs-date, hat das Studierendenparlament der
    Studierendenschaft der Hochschule Reutlingen am #last-changed die
    nachstehende #removed[Satzung] #hl[Finanzordnung als Satzung] beschlossen.

    Das Präsidium der Hochschule Reutlingen hat seine Genehmigung gemäß
    § 65b Abs. 6 Satz 3 des Landeshochschulgesetzes (LHG) am
    #accepted-university erteilt.
  ]

  // Die Vorfassung hatte hier eine Präambel zur männlichen Sprachform.
  // Diese Fassung gendert mit Doppelpunkt. Die Präambel entfällt.
  if show-changes {
    title-heading[#removed[Präambel]]
    removed[
      Im Folgenden wird aus Gründen der besseren Lesbarkeit ausschließlich die
      männliche Form verwendet. Es können alle Amts-, Status- und
      Funktionsbezeichnungen, die in dieser Ordnung in der männlichen
      Sprachform verwendet werden, in der entsprechenden weiblichen Sprachform
      geführt werden.
    ]
  }

  place(bottom + left, data)
}
