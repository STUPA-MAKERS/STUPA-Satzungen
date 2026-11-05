# Organisationssatzung STUPA

[![Build](https://github.com/frederikbeimgraben/OSatzungSTUPA/actions/workflows/continuous-release.yml/badge.svg)](https://github.com/frederikbeimgraben/OSatzungSTUPA/actions/workflows/continuous-release.yml)

The Organisationssatzung (organization statute) of the student body of
Reutlingen University, written in Typst. The layout comes from the
[hsrtreport-typst](https://github.com/frederikbeimgraben/hsrtreport-typst)
template.

The latest PDF is in the release
[Latest Development Build](../../releases/tag/latest).

## Build

You need Typst 0.15 or later and GNU make.

```sh
git clone --recurse-submodules <repository>
make            # write build/Organisationssatzung.pdf
make watch      # compile again after each change
make clean      # remove build/
```

If you cloned without `--recurse-submodules`, `make` fetches the template.
The fonts come with the template, so you do not install fonts.

## Files

| Path | Content |
| --- | --- |
| `src/main.typ` | Main file |
| `src/metadata.typ` | Dates, title page data and title page text |
| `src/satzung.typ` | Layout of the statute: headings, § numbers, running head, table of contents |
| `src/chapters/` | One file for each Abschnitt |
| `src/hsrtreport/` | The template (git submodule) |

## Write the statute

- `=` starts an Abschnitt (I., II., ...).
- `==` starts an Unterabschnitt. The document adds "Erster Unterabschnitt:" and
  so on.
- `===` starts a paragraph. The § numbers continue through the full statute.
- `+` makes an Absatz (1), (2), ... Inside an Absatz, `+` makes the items a),
  b), ...
- Write `@label` to refer to a paragraph. The reference shows "§ 10".
- `#hl[...]` marks text that changed since the previous version. Set
  `show-changes` in `src/satzung.typ` to `false` for the final version.

Before the Präsidium approves the version, the title page shows `XX.XX.20XX`.
After the approval, write the date into `accepted-university` in
`src/metadata.typ`.

## License

The text is licensed under CC BY-SA 4.0, see [LICENSE](LICENSE). The fonts
and logos in the template belong to their owners.
