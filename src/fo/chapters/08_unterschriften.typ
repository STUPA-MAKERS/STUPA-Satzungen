#import "../common.typ": *
#import "../metadata.typ": last-changed

// Unterschriftenblock. Er gehört nicht zum nummerierten Text. Er steht auf
// der Seite der Schlussbestimmungen, wie in der Vorfassung.
#block(breakable: false, above: 2.5cm, {
  text(font: heading-font, size: sizes.LARGE, weight: "bold")[Bestätigung durch den Vorsitzenden]
  parbreak()
  [Hiermit bestätigt der Vorsitzende der Verfassten Studierendenschaft die Verabschiedung der Finanzordnung durch das STUPA am #last-changed.]
  v(2.5cm)
  grid(
    columns: (5cm, 1fr),
    column-gutter: 1.5cm,
    row-gutter: 0.4em,
    line(length: 100%, stroke: 0.5pt), line(length: 100%, stroke: 0.5pt),
    text(size: sizes.small)[Ort, Datum], text(size: sizes.small)[Unterschrift Vorsitzender],
  )
})
