// Document metadata of the Finanzordnung: dates, title page fields and the
// title page text.

#import "common.typ": hl, removed

// Date of the STUPA decision on this version.
#let last-changed = "XX. Monat 20XX"
#let last-changed-short = "XX. Monat 20XX"

// Date of the approval by the Präsidium. Keep the placeholder until the
// Präsidium approves this version.
#let accepted-university = "XX. Monat 20XX"

// Date of the version of the Organisationssatzung that this Ordnung cites.
#let orgs-date = "XX. Monat 20XX"

#let title = [Finanzordnung der \ Studierendenschaft der Hochschule Reutlingen]
#let short-title = [Finanzordnung der Studierendenschaft]

#let data = table(
  columns: (auto, 1fr),
  column-gutter: 12pt,
  stroke: none,
  inset: (x: 0pt, y: 0.7pt),
  [*Vorangegangene Fassung vom*], [#"12. Dezember 2018"],
  [*Vom STUPA angenommen am*], [#last-changed],
  [*Vom Präsidium genehmigt am*], [#accepted-university],
)

// The text of the title page. The template prints its first heading, see
// fo.typ.
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
    Auf Grund von § 65a Abs. 1 Satz 1, 2. Halbsatz und Abs. 3 Satz 2 des
    Landeshochschulgesetzes (LHG) #removed[vom 1. Januar 2005 (GBl. S. 1), in
    der Fassung vom 8. April 2014 (GBl. S. 99 ff.),] #hl[in der Fassung vom
    1.~April 2014 (GBl. S. 99), zuletzt geändert durch Artikel 5 des Gesetzes
    vom 11. Dezember 2025 (GBl. 2025 Nr. 139),] sowie der
    §§ #removed[29] #hl[30] ff. der
    Organisationssatzung der Studierendenschaft der Hochschule Reutlingen
    (OrgS) vom #orgs-date, hat das Studierendenparlament der
    Studierendenschaft der Hochschule Reutlingen am #last-changed die
    nachstehende Satzung beschlossen.

    Das Präsidium der Hochschule Reutlingen hat seine Genehmigung gemäß
    § 65b Abs. 6 Satz 3 des Landeshochschulgesetzes (LHG) am
    #accepted-university erteilt.
  ]

  title-heading[Präambel]
  [
    Im Folgenden wird aus Gründen der besseren Lesbarkeit ausschließlich die
    männliche Form verwendet. Es können alle Amts-, Status- und
    Funktionsbezeichnungen, die in dieser Ordnung in der männlichen
    Sprachform verwendet werden, in der entsprechenden weiblichen Sprachform
    geführt werden.
  ]

  place(bottom + left, data)
}
