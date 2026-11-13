#!/usr/bin/env python3
"""Write the change marks of the statutes from a comparison with the baseline.

Each statute has a baseline: the text of the previous version, one paragraph
for each line, in `baseline/<name>.txt`. This tool compares the baseline with
the Typst sources word by word and writes the marks into the sources:

    #hl[...]        text that is new in this version
    #removed[...]   text of the previous version that this version deletes

Authors do not write these marks. Change the text, then run

    python3 tools/aenderungen.py            # write the marks again
    python3 tools/aenderungen.py --check    # fail if the marks are not current
    python3 tools/aenderungen.py --baseline Finanzordnung
                                            # print the current text as baseline

A statute without a baseline file is new. It gets no marks.

Baseline format: `= `, `== ` and `=== ` start a heading. A paragraph can start
with its number and a tab, for example "(1)<TAB>text". The number is shown
when the paragraph is deleted, it is not compared.
"""

import argparse
import difflib
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# The statutes, each with the source files that hold its numbered text, in
# the order of the document. Title pages and signature pages are not compared.
DOCUMENTS = {
    "Organisationssatzung": [
        "src/chapters/01_allgemeines.typ",
        "src/chapters/02_zentrale_orga.typ",
        "src/chapters/03_dezentrale_orga.typ",
        "src/chapters/04_vollversammlung.typ",
        "src/chapters/05_vermoegen.typ",
        "src/chapters/06_schlussbest.typ",
    ],
    "Finanzordnung": [
        "src/fo/chapters/01_allgemeines.typ",
        "src/fo/chapters/02_haushaltsplan.typ",
        "src/fo/chapters/03_feststellung.typ",
        "src/fo/chapters/04_ausfuehrung.typ",
        "src/fo/chapters/05_kassenfuehrung.typ",
        "src/fo/chapters/06_verwendung.typ",
        "src/fo/chapters/07_schlussbest.typ",
    ],
    "Beitragssatzung": ["src/bs/satzung-text.typ"],
    "QSM-Ordnung": [
        "src/qsmo/chapters/01_allgemeines.typ",
        "src/qsmo/chapters/02_verwendung.typ",
        "src/qsmo/chapters/03_verfahren.typ",
        "src/qsmo/chapters/04_schlussbest.typ",
    ],
}

MARKS = ("#hl[", "#removed[")
LABEL = r"[\w\-.:]*\w"
HEADING = re.compile(r"^(=+) (.*?)(\s*<" + LABEL + r">)?\s*$")
PROSE = re.compile(r"^(\s*(?:[+-] )?)(.*)$")
# Pieces of a text line that stay in one piece: a link, a footnote and a
# reference to a paragraph.
ATOM = re.compile(
    r'#link\("[^"]*"\)\[[^\]]*\]|#footnote\[[^\]]*\]|@' + LABEL
)


def strip_marks(text):
    """Return the text without marks: `#hl[x]` becomes `x`, `#removed[x]`
    becomes nothing."""
    out = []
    i = 0
    while i < len(text):
        mark = next((m for m in MARKS if text.startswith(m, i)), None)
        if mark is None:
            out.append(text[i])
            i += 1
            continue
        start = i + len(mark)
        depth = 1
        k = start
        while depth:
            if text[k] == "\\":
                k += 2
                continue
            depth += (text[k] == "[") - (text[k] == "]")
            k += 1
        if mark == "#hl[":
            out.append(strip_marks(text[start : k - 1]))
        else:
            # The mark goes with the space that set it apart.
            at_start = not out or out[-1] in " \n"
            if text.startswith(" ", k) and at_start:
                k += 1
            elif out and out[-1] == " " and (k == len(text) or text[k] == "\n"):
                out.pop()
        i = k
    return "".join(out)


def norm(word):
    """The form of a word that the comparison uses."""
    return word.replace("‐", "-").replace(" ", " ").replace("\\", "")


class Token:
    """One piece of a text line. `keys` are the words that it compares as."""

    def __init__(self, text, sep, keys):
        self.text, self.sep, self.keys = text, sep, keys
        self.new = False  # the piece is new in this version
        self.follows = False  # the piece is marked like the piece before it
        self.before = []  # deleted text that stood before this piece
        self.after = []  # deleted text that stood after this piece


def tokens_of(text, numbers):
    """Split the text of a source line into tokens."""
    tokens = []
    pos = 0
    pieces = []
    for match in ATOM.finditer(text):
        pieces.append((text[pos : match.start()], False))
        pieces.append((match.group(), True))
        pos = match.end()
    pieces.append((text[pos:], False))

    sep = ""
    pending = None  # an atom that still takes the characters after it
    for piece, is_atom in pieces:
        if is_atom:
            if piece.startswith("@"):
                number = numbers.get(piece[1:])
                keys = ["§ " + str(number)] if number else [piece]
            elif piece.startswith("#link"):
                keys = piece[piece.index(")[") + 2 : -1].split()
            else:
                keys = []
            if pending:
                tokens.append(pending)
            pending = Token(piece, sep, keys)
            sep = ""
            continue
        for part in re.findall(r"\s+|~|[^\s~]+", piece):
            if part.isspace() or part == "~":
                if pending:
                    tokens.append(pending)
                    pending = None
                sep = "~" if part == "~" else " "
            elif pending and not sep:
                # Punctuation that follows an atom directly.
                pending.text += part
                if pending.keys:
                    pending.keys[-1] += norm(part)
                else:
                    pending.keys.append(norm(part))
            else:
                if pending:
                    tokens.append(pending)
                    pending = None
                tokens.append(Token(part, sep, [norm(part)]))
                sep = ""
    if pending:
        tokens.append(pending)
    # "§ 5" compares as one word, so that a changed number shows as
    # "§ 4" replaced by "§ 5".
    for token, number in zip(tokens, tokens[1:]):
        if token.keys == ["§"] and number.sep and number.keys and number.keys[0][:1].isdigit():
            token.keys = ["§ " + number.keys[0]]
            number.keys = number.keys[1:]
            number.follows = True
    return tokens


class Line:
    """A source line. `tokens` is None for a line that is not text."""

    def __init__(self, raw, numbers):
        self.raw, self.tokens, self.prefix, self.suffix = raw, None, "", ""
        heading = HEADING.match(raw)
        if heading:
            self.prefix = heading.group(1) + " "
            self.suffix = heading.group(3) or ""
            self.tokens = tokens_of(heading.group(2), numbers)
            return
        stripped = raw.strip()
        if not stripped or stripped.startswith(("//", "]", "#[", "#set ", "#let ")):
            return
        if stripped.startswith("#") and not ATOM.match(stripped):
            return
        prose = PROSE.match(raw)
        self.prefix = prose.group(1)
        self.tokens = tokens_of(prose.group(2), numbers)


def paragraph_numbers(texts):
    """Map each label of a paragraph heading to its § number."""
    numbers = {}
    count = 0
    for text in texts:
        for line in text.splitlines():
            heading = HEADING.match(line)
            if heading and heading.group(1) == "===":
                count += 1
                if heading.group(3):
                    numbers[heading.group(3).strip()[1:-1]] = count
    return numbers


def read_baseline(path):
    """Return the words of the baseline, each with its key for the
    comparison and the text that a deletion shows."""
    words = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        shown = ""
        heading = re.match(r"^=+ ", line)
        if heading:
            line = line[heading.end() :]
        elif "\t" in line:
            shown, line = line.split("\t", 1)
            shown += " "
        parts = line.split()
        merged = []
        for part in parts:
            if merged and merged[-1] == "§" and part[:1].isdigit():
                merged[-1] = "§ " + part
            else:
                merged.append(part)
        for i, word in enumerate(merged):
            # (key, shown text, number of the paragraph, words to its end,
            # the word is part of a heading)
            words.append(
                (norm(word), word, shown if i == 0 else None, len(merged) - i, bool(heading))
            )
    return words


def escape(text):
    """Escape plain text for Typst markup."""
    text = re.sub(r"([\\*_#$@<\[\]`~])", r"\\\1", text)
    return text.replace("//", "/\\/")


def merge_strays(opcodes):
    """Verbindet einen kurzen gleichen Lauf zwischen zwei großen Änderungen
    mit diesen Änderungen.

    Wenige gleiche Wörter in einem ganz neuen Absatz sind Zufall. Ohne diese
    Regel zerreißen sie den alten und den neuen Absatz in Stücke.
    """
    opcodes = [list(op) for op in opcodes]
    out = []

    def size(op):
        return (op[2] - op[1]) + (op[4] - op[3])

    for index, op in enumerate(opcodes):
        tag, i1, i2, j1, j2 = op
        before = out[-1] if out else None
        after = opcodes[index + 1] if index + 1 < len(opcodes) else None
        stray = (
            tag == "equal"
            and i2 - i1 <= 4
            and before is not None
            and after is not None
            and before[0] != "equal"
            and after[0] != "equal"
            and size(before) >= 4
            and size(after) >= 4
            and size(before) + size(after) >= 24
        )
        if stray or (tag != "equal" and before is not None and before[0] != "equal"):
            before[0] = "replace"
            before[2], before[4] = i2, j2
        else:
            out.append(op)
    return out


def mark(texts, baseline):
    """Return the texts with the marks of a comparison with the baseline."""
    numbers = paragraph_numbers(texts)
    files = [[Line(raw, numbers) for raw in text.split("\n")] for text in texts]
    tokens = [t for lines in files for line in lines if line.tokens for t in line.tokens]
    first = {id(line.tokens[0]) for lines in files for line in lines if line.tokens}
    headings = {
        id(line.tokens[0])
        for lines in files
        for line in lines
        if line.tokens and line.prefix.startswith("=")
    }
    keys, owner = [], []
    for index, token in enumerate(tokens):
        for key in token.keys:
            keys.append(key)
            owner.append(index)

    old = [word[0] for word in baseline]
    matcher = difflib.SequenceMatcher(None, old, keys, autojunk=False)
    for tag, i1, i2, j1, j2 in merge_strays(matcher.get_opcodes()):
        if tag == "equal":
            continue
        for j in range(j1, j2):
            tokens[owner[j]].new = True
        if i2 > i1:
            # A paragraph that is deleted as a whole shows its number.
            removed = " ".join(
                (number if number and i + rest <= i2 else "") + shown
                for i, (_, shown, number, rest, _) in enumerate(baseline[i1:i2], i1)
            )
            starts_paragraph = baseline[i1][2] is not None
            index = owner[j1] if j1 < len(keys) else len(tokens)
            # The end of a paragraph stays with its paragraph.
            at_line_start = index == len(tokens) or id(tokens[index]) in first
            # Deleted text of a paragraph does not go into the heading that
            # follows it.
            into_heading = (
                index < len(tokens) and id(tokens[index]) in headings and not baseline[i1][4]
            )
            if index > 0 and at_line_start and (not starts_paragraph or into_heading):
                tokens[index - 1].after.append(removed)
            elif index == len(tokens):
                tokens[-1].after.append(removed)
            else:
                tokens[index].before.append(removed)

    for before, token in zip(tokens, tokens[1:]):
        if token.follows:
            token.new = before.new

    out = []
    for lines in files:
        rendered = []
        for line in lines:
            if line.tokens is None:
                rendered.append(line.raw)
                continue
            parts = [line.prefix]
            open_hl = False
            for i, token in enumerate(line.tokens):
                sep = token.sep if i else ""
                if open_hl and (not token.new or token.before):
                    parts.append("]")
                    open_hl = False
                parts.append(sep)
                for removed in token.before:
                    parts.append("#removed[" + escape(removed) + "] ")
                if token.new and not open_hl:
                    parts.append("#hl[")
                    open_hl = True
                parts.append(token.text)
                if token.after:
                    if open_hl:
                        parts.append("]")
                        open_hl = False
                    for removed in token.after:
                        parts.append(" #removed[" + escape(removed) + "]")
            if open_hl:
                parts.append("]")
            rendered.append("".join(parts) + line.suffix)
        out.append("\n".join(rendered))
    return out


def export(texts):
    """Return the texts as a baseline."""
    numbers = paragraph_numbers(texts)
    out = []
    counters = []
    for text in texts:
        for raw in text.split("\n"):
            line = Line(raw, numbers)
            if line.tokens is None:
                continue
            words = []
            for token in line.tokens:
                if token.text.startswith("#footnote"):
                    # Only the punctuation after the footnote is compared.
                    words.extend(token.keys)
                    continue
                if token.text.startswith(("@", "#link")):
                    words.append(" ".join(token.keys))
                else:
                    words.append(token.text)
            body = " ".join(words)
            if HEADING.match(raw):
                counters = []
                out.append(line.prefix + body)
                continue
            if line.prefix.strip() != "+":
                out.append(body)
                continue
            depth = 1 if len(line.prefix) - len(line.prefix.lstrip()) == 0 else 2
            counters = counters[:depth] + [0] * (depth - len(counters))
            counters[depth - 1] += 1
            number = counters[depth - 1]
            shown = f"({number})" if depth == 1 else chr(ord("a") + number - 1) + ")"
            out.append(shown + "\t" + body)
    return "\n".join(out) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--check", action="store_true", help="fail if a source file would change")
    parser.add_argument("--baseline", metavar="NAME", help="print the current text of a statute as baseline")
    args = parser.parse_args()

    if args.baseline:
        paths = [ROOT / p for p in DOCUMENTS[args.baseline]]
        sys.stdout.write(export([strip_marks(p.read_text(encoding="utf-8")) for p in paths]))
        return 0

    stale = []
    for name, files in DOCUMENTS.items():
        paths = [ROOT / p for p in files]
        current = [p.read_text(encoding="utf-8") for p in paths]
        clean = [strip_marks(text) for text in current]
        baseline = ROOT / "baseline" / f"{name}.txt"
        marked = mark(clean, read_baseline(baseline)) if baseline.exists() else clean
        for path, before, after in zip(paths, current, marked):
            if before != after:
                stale.append(path.relative_to(ROOT))
                if not args.check:
                    path.write_text(after, encoding="utf-8")
    for path in stale:
        print(("not current: " if args.check else "updated: ") + str(path))
    return 1 if args.check and stale else 0


if __name__ == "__main__":
    sys.exit(main())
