// Shared helpers of the QSM-Ordnung.

#import "../satzung.typ": *

// Marks a point that the STUPA still has to decide (dates, amounts, bodies).
// It uses the same switch as `hl`: set `show-changes` in satzung.typ to false
// for the final version.
#let offen(body) = hl(body)
