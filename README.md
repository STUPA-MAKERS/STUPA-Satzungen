# STUPA-Satzungen

[![Build](https://github.com/STUPA-MAKERS/STUPA-Satzungen/actions/workflows/continuous-release.yml/badge.svg)](https://github.com/STUPA-MAKERS/STUPA-Satzungen/actions/workflows/continuous-release.yml)

Die Satzungen der Studierendenschaft der Hochschule Reutlingen in Typst:

- Organisationssatzung
- Finanzordnung
- Beitragssatzung
- QSM-Ordnung
- Arbeitskreisordnung

Die aktuellen PDFs stehen im Release
[Aktueller Stand](../../releases/tag/latest).

## Bauen

Voraussetzungen: Typst ab 0.15, GNU make, Python 3 mit `pypdf`
(`pip install pypdf`).

```sh
git clone --recurse-submodules <Repository>
make            # baut alle PDFs nach build/
make watch      # baut die Organisationssatzung nach jeder Änderung neu
make marks      # setzt die Änderungsmarkierungen neu
make check      # prüft die Änderungsmarkierungen
make clean      # löscht build/
```

Das Layout und die Schriften kommen aus dem Submodul
[hsrtreport-typst](https://github.com/frederikbeimgraben/hsrtreport-typst).
Wenn das Submodul fehlt, lädt `make` es.

## Dateien

| Pfad | Inhalt |
| --- | --- |
| `src/main.typ`, `src/metadata.typ`, `src/chapters/` | Organisationssatzung |
| `src/fo.typ`, `src/fo/` | Finanzordnung |
| `src/bs.typ`, `src/bs/` | Beitragssatzung |
| `src/qsmo.typ`, `src/qsmo/` | QSM-Ordnung |
| `src/ako.typ`, `src/ako/` | Arbeitskreisordnung |
| `src/satzung.typ` | Layout für alle Satzungen |
| `src/hsrtreport/` | Vorlage (Submodul) |
| `baseline/` | Vorfassung jeder Satzung als Text |
| `tools/aenderungen.py` | Setzt die Änderungsmarkierungen |
| `tools/felder.py` | Schreibt die Datumsfelder in die PDFs |

Jede Satzung hat eine Hauptdatei, eine Datei `metadata.typ` für Titelseite und
Daten und eine Datei je Abschnitt.

## Text schreiben

| Schreibweise | Ergebnis |
| --- | --- |
| `= Titel` | Abschnitt (I., II., ...) |
| `== Titel` | Unterabschnitt ("Erster Unterabschnitt: Titel") |
| `=== Titel <name>` | Paragraph. Die Nummern laufen durch die ganze Satzung. |
| `+ Text` | Absatz (1), (2), ... Eingerückt: Buchstabe a), b), ... |
| `@name` | Verweis auf einen Paragraphen ("§ 10") |

## Änderungen anzeigen

`make` baut jede Satzung zweimal:

- `build/<Name>.pdf` ist die saubere Fassung.
- `build/<Name>_Aenderungen.pdf` zeigt die Änderungen zur Vorfassung. Neuer
  Text ist gelb. Gestrichener Text ist gelb und durchgestrichen.

Die Markierungen im Quelltext sind `#hl[...]` für neuen Text und
`#removed[...]` für gestrichenen Text. Setze sie in den Kapiteln nicht von
Hand.

1. Ändere den Text.
2. Starte `make marks`. Das Skript vergleicht den Text mit
   `baseline/<Name>.txt` und setzt die Markierungen.
3. Committe das Ergebnis.

Die Workflows starten `make check`. Der Build bricht ab, wenn die
Markierungen nicht aktuell sind.

Ausnahmen:

- Eine Satzung ohne Datei in `baseline/` ist neu. Sie hat keine Markierungen.
- Auf Titelseiten und Unterschriftenseiten setzt du die Markierungen von Hand.

## Datumsfelder

Jede Datei `metadata.typ` enthält zwei Daten:

| Variable | Schlüssel | Bedeutung |
| --- | --- | --- |
| `last-changed` | `beschluss` | Beschluss des STUPA |
| `accepted-university` | `genehmigung` | Genehmigung durch das Präsidium |

Solange der Wert ein Platzhalter mit `XX` ist, hat das PDF an jeder Stelle ein
Formularfeld. Alle Felder mit dem gleichen Schlüssel haben den gleichen
Inhalt. Fülle im PDF-Programm ein Feld aus. Das Programm füllt alle anderen
Stellen.

Die Schlüssel sind in allen Satzungen gleich. Ein Skript kann damit alle PDFs
in einem Schritt füllen.

## Neue Fassung in Kraft

1. Trage beide Daten in der Datei `metadata.typ` der Satzung ein. Die PDFs
   zeigen dann festen Text statt der Felder.
2. Schreibe den Text als neue Vorfassung und setze die Markierungen neu:

   ```sh
   python3 tools/aenderungen.py --baseline Organisationssatzung > baseline/Organisationssatzung.txt
   make marks
   ```

3. Setze ein Tag `v*.*.*`. Der Workflow erstellt ein Release mit allen PDFs.

## Lizenz

Der Text steht unter CC BY-SA 4.0, siehe [LICENSE](LICENSE). Schriften und
Logos der Vorlage gehören ihren Inhabern.
