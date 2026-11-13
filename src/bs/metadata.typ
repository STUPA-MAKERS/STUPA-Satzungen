// Document metadata of the Beitragssatzung: dates, title page fields and the
// title page text.

// Date of the STUPA decision on this version. The text is the one of the
// version of 3 December 2018; the STUPA decides on it again and the
// Präsidium approves it again together with the other statutes.
#let last-changed = "XX.XX.20XX"
#let last-changed-short = "XX.XX.20XX"

// Date of the approval by the Präsidium. Keep the placeholder until the
// Präsidium approves this version.
#let accepted-university = "XX.XX.20XX"

// Date of the version of the Organisationssatzung that this Satzung cites.
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

// The text of the title page. The template prints its first heading, see
// bs.typ.
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
    Auf Grund von §§ 65a Abs. 1 Satz 1 und Abs. 5 des Landeshochschulgesetzes
    (LHG) in der Fassung vom 1.~April 2014 (GBl. S. 99), zuletzt geändert
    durch Artikel 5 des Gesetzes vom 11. Dezember 2025 (GBl. 2025 Nr. 139),
    sowie des § 31 Abs. 2 der Organisationssatzung der Studierendenschaft der
    Hochschule Reutlingen vom #orgs-date hat das Studierendenparlament am
    #last-changed die nachstehende Beitragssatzung beschlossen.

    Das Präsidium der Hochschule Reutlingen hat die Beitragssatzung am
    #accepted-university gemäß § 65b Abs. 6 S. 3 des
    Landeshochschulgesetzes genehmigt.
  ]

  title-heading[Präambel]
  [
    Im Folgenden wird aus Gründen der besseren Lesbarkeit ausschließlich die
    männliche Form verwendet. Es können alle Amts-, Status- und
    Funktionsbezeichnungen, die in dieser Satzung in der männlichen
    Sprachform verwendet werden, in der entsprechenden weiblichen Sprachform
    geführt werden.
  ]

  place(bottom + left, data)
}
