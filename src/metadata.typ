// Document metadata: dates, title page fields and the title page text.

#import "satzung.typ": hl

// Date of the STUPA decision on this version.
#let last-changed = "5. November 2026"
#let last-changed-short = "5.11.2026"

// Date of the approval by the Präsidium. Keep the placeholder until the
// Präsidium approves this version.
#let accepted-university = "XX.XX.20XX"

#let title = [Organisationssatzung der \ Studierendenschaft der Hochschule Reutlingen]

// The data table of the title page. The labels are too wide for the label
// column of the template table, so the title page text carries its own table.
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

// The text of the title page. The template prints its first heading, see
// main.typ.
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
    Baden-Württemberg (Landeshochschulgesetz – LHG) #hl[in der Fassung vom
    1.~April 2014 (GBl. S. 99), zuletzt geändert durch Artikel 5 des Gesetzes
    vom 11. Dezember 2025 (GBl. 2025 Nr. 139),] hat die
    Studierendenschaft der Hochschule Reutlingen in der Urabstimmung vom
    16.~April 2013, zuletzt geändert am #last-changed durch Beschluss des
    Studierendenparlamentes, die nachfolgende Organisationssatzung
    beschlossen.

    Die Hochschule Reutlingen hat die Organisationssatzung durch Beschluss des
    Präsidiums am #accepted-university genehmigt.
  ]

  title-heading[Anlass der Änderung]
  [
    Die Änderung vom #last-changed hat den primären Zweck, die
    Organisationssatzung an die infolge der neuen Fakultät „NXT“ geänderten
    Vertreter:innen-Anzahl anzupassen. Darüber hinaus wurden mehrere Fehler
    behoben und die Formulierung vereinfacht. Es wurde die Möglichkeit
    geschaffen, Arbeitskreisleitungen für ihr Engagement zu belohnen. Die Rolle
    der Fachschaften wurde genauer definiert. Den Arbeitskreisen und
    Fachschaften wird eine umfangreichere finanzielle Selbstbestimmung
    ermöglicht. Es wird eine Stimmrechtsübertragung ermöglicht.
  ]

  place(bottom + left, data)
}
