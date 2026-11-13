// Daten der Organisationssatzung: Datumsangaben, Felder und Text der
// Titelseite.

#import "satzung.typ": hl, datum

// Datum des STUPA-Beschlusses zu dieser Fassung.
#let last-changed = datum("beschluss", "XX.XX.20XX")
#let last-changed-short = datum("beschluss", "XX.XX.20XX", kurz: true)

// Datum der Genehmigung durch das Präsidium. Lass den Platzhalter stehen,
// bis das Präsidium diese Fassung genehmigt.
#let accepted-university = datum("genehmigung", "XX.XX.20XX")

#let title = [Organisationssatzung der \ Studierendenschaft der Hochschule Reutlingen]

// Datentabelle der Titelseite. Die Bezeichnungen sind zu breit für die
// Tabelle der Vorlage. Deshalb enthält der Text der Titelseite eine eigene
// Tabelle.
#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Urabstimmung vom*], [#"16. April 2013"],
  [*Vorangegangene Fassung vom*], [#"12. Dezember 2018"],
  [*Vom STUPA beschlossen am*], [#last-changed],
  [*Vom Präsidium genehmigt am*], [#accepted-university],
)

// Text der Titelseite. Die Vorlage setzt die erste Überschrift, siehe
// main.typ.
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
    Baden-Württemberg (Landeshochschulgesetz – LHG) hat die
    Studierendenschaft der Hochschule Reutlingen in der Urabstimmung vom
    16.~April 2013 die nachfolgende Organisationssatzung beschlossen.
    #hl[Das Studierendenparlament hat sie zuletzt am #last-changed auf Grund
    von § 65a Abs. 1 S. 3 LHG in der Fassung vom 1.~April 2014 (GBl. S. 99),
    zuletzt geändert durch Artikel 5 des Gesetzes vom 11. Dezember 2025
    (GBl. 2025 Nr. 139), geändert.]

    Die Hochschule Reutlingen hat die Organisationssatzung durch Beschluss des
    Präsidiums am #accepted-university genehmigt.
  ]

  title-heading[Anlass der Änderung]
  [
    Die Änderung vom #last-changed hat den primären Zweck, die
    Organisationssatzung an die infolge der neuen Fakultät „NXT“ geänderten
    Vertreter:innen-Anzahl anzupassen. Darüber hinaus wurden mehrere Fehler
    behoben und die Formulierung vereinfacht. Es wurde die Möglichkeit
    geschaffen, Arbeitskreisleitungen eine angemessene Aufwandsentschädigung zu
    gewähren. Die Rolle
    der Fachschaften wurde genauer definiert. Den Arbeitskreisen und
    Fachschaften wird eine umfangreichere finanzielle Selbstbestimmung
    ermöglicht. Es wird eine Stimmrechtsübertragung ermöglicht. Die Satzung
    wurde außerdem an die geltende Fassung der §§ 65 bis 65b LHG angepasst.
  ]

  place(bottom + left, data)
}
