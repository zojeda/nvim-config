#!/usr/bin/env python3
"""Regenerate cheatsheet.md from cheatsheet.html, the source of the printable sheet.

    python3 docs/build.py

The PDF is printed from the same HTML with a browser: A4 landscape, no headers or footers.
"""
import html
import re
from pathlib import Path

HERE = Path(__file__).parent


def inline(fragment: str) -> str:
    """Turn the small amount of inline HTML used in the sheet into Markdown."""
    # Keys such as < and > stay escaped until the other tags are gone.
    fragment = re.sub(r"<kbd[^>]*>(.*?)</kbd>", "\x00\\1\x01", fragment, flags=re.S)
    fragment = re.sub(r"<[^>]+>", "", fragment)
    fragment = html.unescape(fragment).replace("\x00", "`").replace("\x01", "`")
    return " ".join(fragment.split())


def main() -> None:
    page = (HERE / "cheatsheet.html").read_text(encoding="utf-8")
    title = inline(re.search(r"<title>(.*?)</title>", page, re.S).group(1))
    legend = inline(re.search(r'<p class="legend">(.*?)</p>', page, re.S).group(1))
    footer = re.search(r"<footer>(.*?)</footer>", page, re.S).group(1)
    notes = [inline(note) for note in re.findall(r"<span>(.*?)</span>", footer, re.S)]

    out = [
        f"# {title}",
        "",
        legend,
        "",
        "Printable version: [cheatsheet.pdf](cheatsheet.pdf), one A4 landscape page.",
    ]
    for section in re.findall(r"<section[^>]*>(.*?)</section>", page, re.S):
        heading = inline(re.search(r"<h2>(.*?)</h2>", section, re.S).group(1))
        out += ["", f"## {heading}", ""]
        note = re.search(r'<p class="note">(.*?)</p>', section, re.S)
        if note:
            out += [inline(note.group(1)), ""]
        out += ["| Keys | Action |", "|---|---|"]
        for keys, action in re.findall(r"<dt[^>]*>(.*?)</dt>\s*<dd>(.*?)</dd>", section, re.S):
            keys, action = inline(keys), inline(action)
            assert "|" not in keys + action, f"a pipe would break the table: {keys} {action}"
            out.append(f"| {keys} | {action} |")

    out += ["", "## Notes", ""] + [f"- {note}" for note in notes]
    (HERE / "cheatsheet.md").write_text("\n".join(out) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
