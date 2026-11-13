#import "../satzung.typ": *
#import "metadata.typ": accepted-university

// The Beitragssatzung has no Abschnitte, only paragraphs.

=== Beitragszweck <bs-beitragszweck>
Die Verfasste Studierendenschaft (Studierendenschaft) der Hochschule Reutlingen nimmt als eine rechtsfähige Körperschaft des öffentlichen Rechts und Gliedkörperschaft der Hochschule Reutlingen unbeschadet der Zuständigkeiten der Hochschule und des Studierendenwerks Tübingen Hohenheim Aufgaben nach § 65 Abs. 2 LHG wahr. Um ihre gesetzlichen Aufgaben erfüllen zu können, erhebt die Studierendenschaft gemäß § 65a Abs. 5 Sätze 2 bis 5 LHG unter Berücksichtigung sozialer Belange von ihren Mitgliedern Beiträge nach Maßgabe dieser Beitragssatzung.

=== Beitragspflicht <bs-beitragspflicht>
Die Studierendenschaft der Hochschule erhebt zur Erfüllung ihrer Aufgaben von allen immatrikulierten Studierenden (§ 60 Abs. 1 S. 1 LHG) einen Studierendenschaftsbeitrag. Der Beitragspflicht unterliegen auch die vom Studium beurlaubten Studierenden.

=== Beitragshöhe <bs-beitragshoehe>
Der zu zahlende Studierendenschaftsbeitrag beträgt ab dem Sommersemester 2019 für jedes Semester 14,50 Euro#footnote[Basierend auf dem Wirtschaftsplan des Studierendenparlaments der Hochschule Reutlingen].

=== Fälligkeit des Beitrags, Einzug durch die Hochschule <bs-faelligkeit>
Der Studierendenschaftsbeitrag ist bei Studierenden zur Neuaufnahme in die Hochschule mit dem Immatrikulationsantrag beziehungsweise bei bereits eingeschriebenen Studierenden mit der Rückmeldung fällig, ohne dass es eines Gebührenbescheides bedarf. Er ist gemäß § 65a Abs. 5 S. 5 LHG an die Hochschule Reutlingen zu zahlen, die den Beitrag an die Studierendenschaft abführt.

=== Befreiung, Erlass, Ermäßigung, Stundung <bs-befreiung>
+ Befreiungen vom Studierendenschaftsbeitrag sind nicht vorgesehen. Der Studierendenschaftsbeitrag kann nicht erlassen, ermäßigt oder gestundet werden.
+ Bei einer Exmatrikulation binnen eines Monats nach Beginn der Vorlesungszeit an der Hochschule Reutlingen entfällt die Beitragspflicht nach §§ 2, 3 rückwirkend. Der Studierendenschaftsbeitrag wird auf Antrag für dieses Semester erstattet; ein Anspruch auf einen anteiligen Erlass und eine anteilige Rückerstattung nach Ablauf der Frist in Satz 1 besteht nicht. Der Erstattungsantrag ist binnen einer Frist von einem Monat nach dem Tag der Exmatrikulation an die Studierendenschaft zu richten; nach Ablauf dieser Frist besteht ein Anspruch auf Rückerstattung nur noch bei Vorliegen der Voraussetzungen für die Wiedereinsetzung in den vorigen Stand (§ 32 LVwVfG). Der AStA ist berechtigt, im Einvernehmen mit der Hochschule die Durchführung des Rückerstattungsverfahrens auf die Hochschule zu delegieren; Einzelheiten dazu sind in einer Verwaltungsvereinbarung mit der Hochschule zu regeln.

=== Inkrafttreten <bs-inkrafttreten>
Diese Beitragssatzung tritt am Tag nach ihrer öffentlichen Bekanntmachung an der Hochschule Reutlingen in Kraft. Der Studierendenschaftsbeitrag ist erstmals mit der Immatrikulation oder Rückmeldung zum Sommersemester 2019 an die Hochschule Reutlingen zu bezahlen.

// Signature page. It is not part of the numbered text.
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
