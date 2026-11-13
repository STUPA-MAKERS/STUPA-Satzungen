#import "../satzung.typ": *
#import "metadata.typ": accepted-university

// Unterschriftenseite. Sie gehört nicht zum nummerierten Text.
#pagebreak(weak: true)

#let signature-block(label, role) = block(breakable: false, above: 2.5cm, {
  label
  v(2.5cm)
  grid(
    columns: (5cm, 1fr),
    column-gutter: 1.5cm,
    row-gutter: 0.4em,
    line(length: 100%, stroke: 0.5pt), line(length: 100%, stroke: 0.5pt),
    text(size: sizes.small)[Ort, Datum], text(size: sizes.small)[Unterschrift],
    [], strong(role),
  )
})

#text(font: heading-font, size: sizes.LARGE, weight: "bold")[Ausfertigung und Genehmigung]

#signature-block(
  [*Ausgefertigt.*],
  [Die:Der Vorsitzende der Studierendenschaft der Hochschule Reutlingen],
)

#signature-block(
  [*Genehmigt* durch Beschluss des Präsidiums vom #accepted-university.],
  [Die:Der Kanzler:in der Hochschule Reutlingen],
)
