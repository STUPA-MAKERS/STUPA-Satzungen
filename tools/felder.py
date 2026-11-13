#!/usr/bin/env python3
"""Schreibt die Formularfelder für Datumsangaben in ein PDF.

Typst kann keine Formularfelder schreiben. `datum()` in `src/satzung.typ`
lässt deshalb Platz frei und merkt sich die Stelle. `typst eval` gibt die
Stellen als JSON aus. Dieses Skript liest das JSON und schreibt an jede Stelle
ein Textfeld.

    typst eval ... 'query(<datumsfeld>).map(it => it.value)' --in src/fo.typ \\
        | python3 tools/felder.py build/Finanzordnung.pdf

Alle Felder mit dem gleichen Schlüssel (`beschluss`, `genehmigung`) sind ein
Feld mit mehreren Stellen. Ein Eintrag füllt alle Stellen.
"""

import json
import sys

from pypdf import PdfReader, PdfWriter
from pypdf.generic import (
    ArrayObject,
    BooleanObject,
    DictionaryObject,
    FloatObject,
    NameObject,
    NumberObject,
    TextStringObject,
)

# Beschriftung der Felder für Programme, die das PDF vorlesen.
LABELS = {
    "beschluss": "Datum des Beschlusses des Studierendenparlamentes",
    "genehmigung": "Datum der Genehmigung durch das Präsidium",
}


def name(value):
    return NameObject("/" + value)


def add_fields(path, places):
    """Schreibt die Felder in das PDF. Gibt die Zahl der Stellen und der
    Felder zurück."""
    writer = PdfWriter(clone_from=PdfReader(path))
    font = writer._add_object(
        DictionaryObject(
            {
                name("Type"): name("Font"),
                name("Subtype"): name("Type1"),
                name("BaseFont"): name("Helvetica"),
                name("Encoding"): name("WinAnsiEncoding"),
            }
        )
    )
    fields = {}
    for place in places:
        key = place["key"]
        if key not in fields:
            fields[key] = writer._add_object(
                DictionaryObject(
                    {
                        name("FT"): name("Tx"),
                        name("T"): TextStringObject(key),
                        name("TU"): TextStringObject(LABELS.get(key, key)),
                        name("V"): TextStringObject(""),
                        name("Kids"): ArrayObject(),
                    }
                )
            )
        page = writer.pages[place["page"] - 1]
        # Typst misst von oben, PDF misst von unten.
        top = float(page.mediabox.top) - place["y"]
        rect = [place["x"], top - place["height"], place["x"] + place["width"], top]
        widget = writer._add_object(
            DictionaryObject(
                {
                    name("Type"): name("Annot"),
                    name("Subtype"): name("Widget"),
                    name("Parent"): fields[key],
                    name("P"): page.indirect_reference,
                    name("Rect"): ArrayObject(FloatObject(round(v, 2)) for v in rect),
                    name("F"): NumberObject(4),  # das Feld wird gedruckt
                    name("DA"): TextStringObject(f"/Helv {place['size']:g} Tf 0 g"),
                }
            )
        )
        fields[key].get_object()[name("Kids")].append(widget)
        if "/Annots" not in page:
            page[name("Annots")] = ArrayObject()
        page["/Annots"].append(widget)

    if fields:
        writer._root_object[name("AcroForm")] = DictionaryObject(
            {
                name("Fields"): ArrayObject(fields.values()),
                name("NeedAppearances"): BooleanObject(True),
                name("DA"): TextStringObject("/Helv 10 Tf 0 g"),
                name("DR"): DictionaryObject(
                    {name("Font"): DictionaryObject({name("Helv"): font})}
                ),
            }
        )
        writer.write(path)
    return len(places), len(fields)


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    stellen, felder = add_fields(sys.argv[1], json.load(sys.stdin))
    print(f"{sys.argv[1]}: {felder} Felder an {stellen} Stellen")


if __name__ == "__main__":
    main()
