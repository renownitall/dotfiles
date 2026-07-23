#!/usr/bin/env python3
"""
Generate the Cozy Slate palette image and verify palette coverage.

Default:
    python assets/generate_palette.py

This writes:
    assets/palette.svg
    assets/palette.png   (if an SVG -> PNG converter is available)

Check whether colors used in the dotfiles are missing from the curated palette:
    python assets/generate_palette.py --check

Generate a cleaner version without hex labels:
    python assets/generate_palette.py --no-labels

Force a specific font file:
    python assets/generate_palette.py --font /usr/share/fonts/TTF/IBMPlexMono-Regular.ttf

Generate a 2x PNG:
    python assets/generate_palette.py --scale 2
"""

import argparse
import base64
import math
import re
import shutil
import subprocess
import sys
from pathlib import Path
from xml.sax.saxutils import escape


PALETTE_GROUPS = [
    (
        "Base & Surfaces",
        [
            "#000000",
            "#222222",
            "#282828",
            "#323232",
            "#3c3c3c",
            "#4a4a4a",
            "#565656",
        ],
    ),
    (
        "Text & Overlays",
        [
            "#ffffff",
            "#eaeaea",
            "#abb2bf",
            "#9e9e9e",
            "#7a8388",
            "#727a82",
            "#7e868e",
        ],
    ),
    (
        "Cool Accents",
        [
            "#4c7899",
            "#5a8bb0",
            "#72a3c5",
            "#285577",
            "#56b6c2",
            "#6ec8d4",
        ],
    ),
    (
        "Warm Accents",
        [
            "#dba870",
            "#d19a66",
            "#e89a8a",
            "#c08040",
            "#e5c07b",
            "#ecd08e",
        ],
    ),
    (
        "Greens",
        [
            "#98c379",
            "#a8d48a",
        ],
    ),
    (
        "Reds & Errors",
        [
            "#e06c75",
            "#e88991",
            "#b83030",
            "#6e2028",
        ],
    ),
    (
        "Purples",
        [
            "#c678dd",
            "#d494e8",
        ],
    ),
    (
        "UI Specific",
        [
            "#3d6480",
            "#4c566a",
        ],
    ),
    (
        "Diff Backgrounds",
        [
            "#28442f",
            "#283d4d",
            "#4a2a2d",
        ],
    ),
    (
        "Alpha over Base",
        [
            "#28557780",
            "#4a4a4a80",
            "#6e202880",
            "#00000000",
            "#eaeaeacc",
            "#eaeaea14",
            "#dba87026",
            "#e06c7526",
        ],
    ),
]


HEX_RE = re.compile(r"#([0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{4}|[0-9a-fA-F]{3})\b")
BARE_HEX_RE = re.compile(r"\b([0-9a-fA-F]{8}|[0-9a-fA-F]{6})\b")
RGBA_RE = re.compile(
    r"rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9]*\.?[0-9]+)\s*\)",
    re.IGNORECASE,
)
RGB_TRIPLE_RE = re.compile(r"\b(\d{1,3})\s+(\d{1,3})\s+(\d{1,3})\b")


def normalize_hex(value):
    h = value.lower().lstrip("#")

    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    elif len(h) == 4:
        h = "".join(c * 2 for c in h)

    # Treat fully opaque 8-digit hex as normal 6-digit hex.
    if len(h) == 8 and h.endswith("ff"):
        h = h[:6]

    if len(h) not in (6, 8):
        return ""

    return "#" + h


def normalize_rgba(match):
    r = int(match.group(1))
    g = int(match.group(2))
    b = int(match.group(3))
    a = float(match.group(4))

    if any(v < 0 or v > 255 for v in (r, g, b)):
        return ""

    a = max(0.0, min(1.0, a))
    aa = int(round(a * 255))

    if aa == 255:
        return f"#{r:02x}{g:02x}{b:02x}"

    return f"#{r:02x}{g:02x}{b:02x}{aa:02x}"


def normalize_rgb_triple(match):
    values = tuple(int(match.group(i)) for i in range(1, 4))

    if any(v < 0 or v > 255 for v in values):
        return ""

    return "#%02x%02x%02x" % values


def allows_bare_hex(path):
    parts = set(path.parts)
    return path.name in {"foot.ini", "fuzzel.ini"} or (
        "swaylock" in parts and path.name == "config"
    )


def scan_colors(root):
    found = set()

    scan_root = root / "home"
    if not scan_root.is_dir():
        scan_root = root

    for path in scan_root.rglob("*"):
        if not path.is_file():
            continue

        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue

        for match in HEX_RE.finditer(text):
            color = normalize_hex(match.group(1))
            if color:
                found.add(color)

        for match in RGBA_RE.finditer(text):
            color = normalize_rgba(match)
            if color:
                found.add(color)

        if allows_bare_hex(path):
            for match in BARE_HEX_RE.finditer(text):
                color = normalize_hex(match.group(1))
                if color:
                    found.add(color)

        if path.name == "cozy_slate.kdl":
            for match in RGB_TRIPLE_RE.finditer(text):
                color = normalize_rgb_triple(match)
                if color:
                    found.add(color)

    return found


def curated_colors():
    return {color.lower() for _, colors in PALETTE_GROUPS for color in colors}


def check(root):
    found = scan_colors(root)
    curated = curated_colors()
    missing = sorted(found - curated)

    if missing:
        print("Colors found in the repo but missing from the curated palette:")
        for color in missing:
            print(f"  {color}")
        return 1

    print(f"OK: scanned {len(found)} colors; all are present in the curated palette.")
    return 0


def hex_to_rgba(value):
    h = value.lower().lstrip("#")

    if len(h) == 8:
        r = int(h[0:2], 16)
        g = int(h[2:4], 16)
        b = int(h[4:6], 16)
        a = int(h[6:8], 16) / 255.0
        return r, g, b, a

    r = int(h[0:2], 16)
    g = int(h[2:4], 16)
    b = int(h[4:6], 16)
    return r, g, b, 1.0


FONT_ROOTS = [
    Path("/usr/share/fonts"),
    Path("/usr/local/share/fonts"),
    Path.home() / ".local" / "share" / "fonts",
]

FONT_EXACT_NAMES = [
    "IBMPlexMono-Regular.ttf",
    "IBMPlexMono-Regular.otf",
    "IBMPlexMonoNerdFont-Regular.ttf",
    "IBMPlexMonoNerdFontMono-Regular.ttf",
]


def search_font_files():
    for name in FONT_EXACT_NAMES:
        for root in FONT_ROOTS:
            if not root.is_dir():
                continue
            try:
                matches = sorted(root.rglob(name))
            except PermissionError:
                continue
            if matches:
                return matches[0]

    for root in FONT_ROOTS:
        if not root.is_dir():
            continue
        try:
            matches = sorted(root.rglob("*PlexMono*Regular*.ttf"))
            if matches:
                return matches[0]
            matches = sorted(root.rglob("*PlexMono*Regular*.otf"))
            if matches:
                return matches[0]
        except PermissionError:
            continue

    return None


def fc_match_font():
    if not shutil.which("fc-match"):
        return None

    try:
        proc = subprocess.run(
            ["fc-match", "-f", "%{file}", "IBM Plex Mono:style=Regular"],
            capture_output=True,
            text=True,
            check=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return None

    out = proc.stdout.strip()
    if not out:
        return None

    candidate = Path(out)
    if not candidate.is_file():
        return None

    name = candidate.name.lower()
    if "ibmplexmono" in name or "plexmono" in name:
        return candidate

    return None


def resolve_font(explicit):
    if explicit:
        p = Path(explicit).expanduser()
        return p if p.is_file() else None

    return search_font_files() or fc_match_font()


def build_font_face(font_path):
    data = base64.b64encode(font_path.read_bytes()).decode("ascii")
    suffix = font_path.suffix.lower()

    if suffix == ".ttf":
        mime = "font/ttf"
        fmt = "truetype"
    elif suffix == ".otf":
        mime = "font/otf"
        fmt = "opentype"
    else:
        mime = "application/octet-stream"
        fmt = None

    src = f"url(data:{mime};base64,{data})"
    if fmt:
        src += f" format('{fmt}')"

    css = f"@font-face {{ font-family: 'CozyPaletteMono'; src: {src}; }}"
    family = "CozyPaletteMono, 'IBM Plex Mono', monospace"

    return css, family


def generate_svg(labels=True, font_css=None, font_family="'IBM Plex Mono', monospace"):
    margin = 24
    title_h = 52
    square = 44
    gap = 10
    cols = 10
    label_h = 14 if labels else 0
    group_gap = 12

    width = margin * 2 + cols * square + (cols - 1) * gap

    # Compute height.
    y = margin + title_h
    for _, colors in PALETTE_GROUPS:
        y += 20
        rows = math.ceil(len(colors) / cols)
        y += rows * (square + label_h + gap) + group_gap
    height = y + margin

    parts = []
    parts.append('<?xml version="1.0" encoding="UTF-8"?>')
    parts.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" '
        f'width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}" '
        f'shape-rendering="crispEdges">'
    )

    if font_css:
        parts.append(
            f'<defs><style type="text/css"><![CDATA[{font_css}]]></style></defs>'
        )

    # Background and border.
    parts.append(
        f'<rect x="0" y="0" width="{width}" height="{height}" fill="#323232"/>'
    )
    parts.append(
        f'<rect x="1" y="1" width="{width - 2}" height="{height - 2}" '
        f'fill="none" stroke="#4c7899" stroke-width="2"/>'
    )

    # Title.
    font = f'font-family="{font_family}"'
    parts.append(
        f'<text x="{margin}" y="{margin + 22}" {font} '
        f'font-size="18" fill="#eaeaea">Cozy Slate</text>'
    )
    parts.append(
        f'<text x="{margin}" y="{margin + 40}" {font} '
        f'font-size="10" fill="#9e9e9e">palette</text>'
    )

    y = margin + title_h

    for group_title, colors in PALETTE_GROUPS:
        parts.append(
            f'<text x="{margin}" y="{y + 12}" {font} '
            f'font-size="12" fill="#eaeaea">{escape(group_title)}</text>'
        )
        y += 20

        rows = math.ceil(len(colors) / cols)

        for i, color in enumerate(colors):
            row = i // cols
            col = i % cols

            x = margin + col * (square + gap)
            ry = y + row * (square + label_h + gap)

            r, g, b, a = hex_to_rgba(color)
            fill = f"#{r:02x}{g:02x}{b:02x}"
            title = escape(color)

            if a < 1.0:
                # Draw alpha colors over the base background.
                parts.append(
                    f'<rect x="{x}" y="{ry}" width="{square}" height="{square}" '
                    f'fill="#323232" stroke="#4c7899" stroke-opacity="0.25"/>'
                )
                parts.append(
                    f'<rect x="{x}" y="{ry}" width="{square}" height="{square}" '
                    f'fill="{fill}" fill-opacity="{a:.3f}">'
                    f"<title>{title}</title></rect>"
                )
            else:
                parts.append(
                    f'<rect x="{x}" y="{ry}" width="{square}" height="{square}" '
                    f'fill="{fill}" stroke="#4c7899" stroke-opacity="0.25">'
                    f"<title>{title}</title></rect>"
                )

            if labels:
                tx = x + square // 2
                ty = ry + square + 10
                parts.append(
                    f'<text x="{tx}" y="{ty}" {font} font-size="7" '
                    f'text-anchor="middle" fill="#9e9e9e">{escape(color)}</text>'
                )

        y += rows * (square + label_h + gap) + group_gap

    parts.append("</svg>")
    return "\n".join(parts)


def find_converter(preferred="auto"):
    if preferred != "auto":
        if preferred == "cairosvg":
            try:
                import cairosvg  # noqa: F401

                return preferred
            except Exception:
                return None

        if shutil.which(preferred):
            return preferred

        return None

    for name in ("resvg", "rsvg-convert", "inkscape", "convert"):
        if shutil.which(name):
            return name

    try:
        import cairosvg  # noqa: F401

        return "cairosvg"
    except Exception:
        return None


def convert_to_png(converter, svg_path, png_path, scale):
    if scale <= 0:
        raise ValueError("scale must be positive")

    if converter == "cairosvg":
        import cairosvg

        cairosvg.svg2png(
            url=str(svg_path),
            write_to=str(png_path),
            scale=scale,
        )
        return

    if converter == "resvg":
        cmd = ["resvg"]
        if scale != 1:
            cmd += ["--zoom", f"{scale:g}"]
        cmd += [str(svg_path), str(png_path)]

    elif converter == "rsvg-convert":
        cmd = ["rsvg-convert", "-f", "png"]
        if scale != 1:
            cmd += [f"--zoom={scale:g}"]
        cmd += ["-o", str(png_path), str(svg_path)]

    elif converter == "inkscape":
        dpi = int(96 * scale)
        cmd = [
            "inkscape",
            str(svg_path),
            "--export-type=png",
            f"--export-filename={png_path}",
            f"--export-dpi={dpi}",
        ]

    elif converter == "convert":
        cmd = ["convert"]
        if scale != 1:
            cmd += ["-density", str(int(96 * scale))]
        cmd += [str(svg_path), str(png_path)]

    else:
        raise ValueError(f"unknown converter: {converter}")

    subprocess.run(cmd, check=True, capture_output=True, text=True)


def main():
    parser = argparse.ArgumentParser(
        description="Generate or check the Cozy Slate palette image."
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output SVG path. Default: assets/palette.svg",
    )
    parser.add_argument(
        "--root",
        type=Path,
        help="Repository root. Default: parent directory of this script.",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Check repo colors against the curated palette and exit.",
    )
    parser.add_argument(
        "--no-labels",
        dest="labels",
        action="store_false",
        help="Do not draw hex labels under the swatches.",
    )
    parser.add_argument(
        "--font",
        type=Path,
        help="Path to IBM Plex Mono .ttf/.otf. If omitted, the script searches common font paths.",
    )
    parser.add_argument(
        "--no-embed-font",
        dest="embed_font",
        action="store_false",
        help="Do not embed the font in the SVG.",
    )
    parser.add_argument(
        "--no-png",
        dest="png",
        action="store_false",
        help="Do not export a PNG after generating the SVG.",
    )
    parser.add_argument(
        "--png-output",
        type=Path,
        help="Output PNG path. Default: same as SVG output with .png extension.",
    )
    parser.add_argument(
        "--scale",
        type=float,
        default=1.0,
        help="PNG scale factor. Default: 1. Use 2 for a retina-friendly image.",
    )
    parser.add_argument(
        "--converter",
        choices=["auto", "resvg", "rsvg-convert", "inkscape", "convert", "cairosvg"],
        default="auto",
        help="SVG -> PNG converter to use.",
    )
    args = parser.parse_args()

    if args.scale <= 0:
        parser.error("--scale must be positive")

    root = args.root or Path(__file__).resolve().parent.parent

    if args.check:
        sys.exit(check(root))

    font_css = None
    font_family = "'IBM Plex Mono', monospace"

    if args.embed_font:
        font_path = resolve_font(args.font)

        if font_path is None:
            if args.font:
                sys.exit(f"Font not found: {args.font}")
            print(
                "warning: IBM Plex Mono font not found; falling back to generic monospace",
                file=sys.stderr,
            )
        else:
            font_css, font_family = build_font_face(font_path)

    output = args.output or Path(__file__).resolve().parent / "palette.svg"
    output.parent.mkdir(parents=True, exist_ok=True)

    svg = generate_svg(
        labels=args.labels,
        font_css=font_css,
        font_family=font_family,
    )
    output.write_text(svg, encoding="utf-8")
    print(f"Wrote {output}")

    if args.png:
        png_output = args.png_output or output.with_suffix(".png")
        converter = find_converter(args.converter)

        if converter is None:
            message = (
                "warning: no SVG -> PNG converter found; "
                "install resvg, librsvg, inkscape, imagemagick, or python-cairosvg"
            )
            if args.converter != "auto":
                sys.exit(message)
            print(message, file=sys.stderr)
        else:
            try:
                convert_to_png(converter, output, png_output, args.scale)
                print(f"Wrote {png_output}")
            except subprocess.CalledProcessError as exc:
                print(
                    f"warning: PNG conversion failed using {converter}",
                    file=sys.stderr,
                )
                if exc.stderr:
                    print(exc.stderr.strip(), file=sys.stderr)
            except Exception as exc:
                print(f"warning: PNG conversion failed: {exc}", file=sys.stderr)


if __name__ == "__main__":
    main()
