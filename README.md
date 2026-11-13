# Organisationssatzung STUPA

[![Build](https://github.com/frederikbeimgraben/OSatzungSTUPA/actions/workflows/continuous-release.yml/badge.svg)](https://github.com/frederikbeimgraben/OSatzungSTUPA/actions/workflows/continuous-release.yml)

The statutes of the student body of Reutlingen University, written in Typst:

- the Organisationssatzung (organization statute),
- the Finanzordnung (budget and accounting rules),
- the Beitragssatzung (student body fee),
- the QSM-Ordnung (how the student body makes its proposal for the
  Qualitätssicherungsmittel).

The layout comes from the
[hsrtreport-typst](https://github.com/frederikbeimgraben/hsrtreport-typst)
template.

The latest PDFs are in the release
[Latest Development Build](../../releases/tag/latest).

## Build

You need Typst 0.15 or later and GNU make.

```sh
git clone --recurse-submodules <repository>
make            # write two PDFs for each statute into build/
make watch      # compile the Organisationssatzung again after each change
make marks      # set the change marks again (needs Python 3)
make check      # fail if the change marks are out of date
make clean      # remove build/
```

If you cloned without `--recurse-submodules`, `make` fetches the template.
The fonts come with the template, so you do not install fonts.

## Files

| Path | Content |
| --- | --- |
| `src/main.typ` | Main file of the Organisationssatzung |
| `src/metadata.typ` | Dates, title page data and title page text |
| `src/satzung.typ` | Layout of all documents: headings, § numbers, running head, table of contents |
| `src/chapters/` | One file for each Abschnitt |
| `src/qsmo.typ` | Main file of the QSM-Ordnung |
| `src/qsmo/` | Metadata and one file for each Abschnitt of the QSM-Ordnung |
| `src/fo.typ` | Main file of the Finanzordnung |
| `src/fo/` | Metadata and one file for each Abschnitt of the Finanzordnung |
| `src/bs.typ` | Main file of the Beitragssatzung |
| `src/bs/` | Metadata and the text of the Beitragssatzung |
| `src/hsrtreport/` | The template (git submodule) |
| `baseline/` | The previous version of each statute as plain text |
| `tools/aenderungen.py` | Sets the change marks from the baseline |

## Write the statute

- `=` starts an Abschnitt (I., II., ...).
- `==` starts an Unterabschnitt. The document adds "Erster Unterabschnitt:" and
  so on.
- `===` starts a paragraph. The § numbers continue through the full statute.
- `+` makes an Absatz (1), (2), ... Inside an Absatz, `+` makes the items a),
  b), ...
- Write `@label` to refer to a paragraph. The reference shows "§ 10".

## Changes from the previous version

`make` writes each statute twice:

- `build/<Name>.pdf` is the clean version.
- `build/<Name>_Aenderungen.pdf` shows the changes from the previous version.
  New text is highlighted, deleted text is highlighted and struck through.
  The footer says "Änderungsfassung".

In the source, `#hl[...]` marks new text and `#removed[...]` holds deleted
text. Do not write these marks in the chapters by hand. `make marks` runs
`tools/aenderungen.py`, which compares the chapters word by word with the
previous version in `baseline/<Name>.txt` and sets the marks. Edit the text,
run `make marks`, and commit the result. The workflows run `make check`.

A statute without a file in `baseline/` is new and has no marks (the
QSM-Ordnung). The marks on a title page and a signature page are set by hand.

When a version is in force, make it the new baseline:

```sh
python3 tools/aenderungen.py --baseline Organisationssatzung > baseline/Organisationssatzung.txt
make marks
```

Before the Präsidium approves the version, the title page shows `XX.XX.20XX`.
After the approval, write the date into `accepted-university` in
`src/metadata.typ`.

## License

The text is licensed under CC BY-SA 4.0, see [LICENSE](LICENSE). The fonts
and logos in the template belong to their owners.
