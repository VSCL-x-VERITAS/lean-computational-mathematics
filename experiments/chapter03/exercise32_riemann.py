"""LeVeque Exercise 3.2: solve and plot a real diagonalizable 2x2 Riemann problem.

Run with ``--examples OUTPUT_DIR`` for all six Exercise 3.1 inputs, or with
``--input problem.json --output plot.svg`` for a further input. The JSON
object has keys ``A`` (two rows), ``left``, ``right``, and optional ``time``.
Complex-spectrum and defective matrices are rejected because the requested
real hyperbolic eigenmode solution does not apply to them.
"""

from __future__ import annotations

import argparse
import json
import math
from html import escape
from pathlib import Path


EXAMPLES = {
    "a": {"A": [[0, 4], [1, 0]], "left": [0, 1], "right": [1, 1]},
    "b": {"A": [[0, 4], [1, 0]], "left": [1, 1], "right": [0, 1]},
    "c": {"A": [[0, 9], [1, 0]], "left": [1, 0], "right": [4, 0]},
    "d": {"A": [[1, 1], [1, 1]], "left": [1, 0], "right": [2, 0]},
    "e": {"A": [[2, 0], [0, 2]], "left": [0, 1], "right": [1, 0]},
    "f": {"A": [[2, 1], [0.0001, 2]], "left": [0, 1], "right": [1, 0]},
}


def _vector_for(a: float, b: float, c: float, d: float, speed: float) -> tuple[float, float]:
    first = (b, speed - a)
    second = (speed - d, c)
    vector = max((first, second), key=lambda v: max(map(abs, v)))
    scale = max(map(abs, vector))
    if scale == 0:
        raise ValueError("matrix has no determined eigenvector")
    return vector[0] / scale, vector[1] / scale


def solve(problem: dict) -> dict:
    rows = problem["A"]
    left, right = problem["left"], problem["right"]
    if len(rows) != 2 or any(len(row) != 2 for row in rows) or len(left) != 2 or len(right) != 2:
        raise ValueError("A must be 2x2 and left/right must have two components")
    a, b = map(float, rows[0])
    c, d = map(float, rows[1])
    ql, qr = tuple(map(float, left)), tuple(map(float, right))
    time = float(problem.get("time", 1.0))
    if not all(map(math.isfinite, (a, b, c, d, *ql, *qr, time))) or time <= 0:
        raise ValueError("all inputs must be finite and plotting time positive")
    discriminant = (a - d) ** 2 + 4 * b * c
    tolerance = 1e-12 * max(1.0, a * a, b * b, c * c, d * d)
    if discriminant < -tolerance:
        raise ValueError("matrix has complex characteristic speeds")
    if abs(discriminant) <= tolerance:
        speed = (a + d) / 2
        if max(abs(a - speed), abs(b), abs(c), abs(d - speed)) > 1e-10 * max(1, abs(speed)):
            raise ValueError("repeated speed has no full real eigenbasis")
        return {"speeds": [speed], "states": [ql, qr], "strengths": None, "time": time}
    root = math.sqrt(discriminant)
    speeds = ((a + d - root) / 2, (a + d + root) / 2)
    r0 = _vector_for(a, b, c, d, speeds[0])
    r1 = _vector_for(a, b, c, d, speeds[1])
    determinant = r0[0] * r1[1] - r0[1] * r1[0]
    if abs(determinant) <= 1e-14:
        raise ValueError("computed eigenbasis is singular at float precision")
    jump = (qr[0] - ql[0], qr[1] - ql[1])
    strengths = (
        (jump[0] * r1[1] - jump[1] * r1[0]) / determinant,
        (r0[0] * jump[1] - r0[1] * jump[0]) / determinant,
    )
    middle = (ql[0] + strengths[0] * r0[0], ql[1] + strengths[0] * r0[1])
    reconstructed = (middle[0] + strengths[1] * r1[0], middle[1] + strengths[1] * r1[1])
    if max(abs(reconstructed[i] - qr[i]) for i in range(2)) > 1e-8 * max(1, *map(abs, qr)):
        raise ArithmeticError("eigenmode reconstruction lost precision")
    return {
        "speeds": list(speeds), "vectors": [r0, r1],
        "strengths": strengths, "states": [ql, middle, qr], "time": time,
    }


def _panel(x0: float, y0: float, width: float, height: float,
           points: list[tuple[float, float]], title: str, color: str) -> str:
    xs = [point[0] for point in points]
    ys = [point[1] for point in points]
    xmin, xmax = min(xs), max(xs)
    ymin, ymax = min(ys), max(ys)
    xpad = max(0.1, (xmax - xmin) * 0.1)
    ypad = max(0.1, (ymax - ymin) * 0.1)
    xmin, xmax = xmin - xpad, xmax + xpad
    ymin, ymax = ymin - ypad, ymax + ypad
    def px(x: float) -> float:
        return x0 + 36 + (x - xmin) / (xmax - xmin) * (width - 52)
    def py(y: float) -> float:
        return y0 + height - 34 - (y - ymin) / (ymax - ymin) * (height - 66)
    route = " ".join(f"{px(x):.2f},{py(y):.2f}" for x, y in points)
    return (
        f'<rect x="{x0}" y="{y0}" width="{width}" height="{height}" fill="white" stroke="#b9c4d0"/>'
        f'<text x="{x0 + 16}" y="{y0 + 24}" font-size="16">{escape(title)}</text>'
        f'<polyline points="{route}" fill="none" stroke="{color}" stroke-width="3"/>'
        + "".join(f'<circle cx="{px(x):.2f}" cy="{py(y):.2f}" r="3" fill="{color}"/>' for x, y in points)
        + f'<text x="{x0 + 12}" y="{y0 + height - 9}" font-size="11">x: {xmin:.3g} to {xmax:.3g}; y: {ymin:.3g} to {ymax:.3g}</text>'
    )


def svg_plot(result: dict, label: str = "Riemann problem") -> str:
    states = result["states"]
    rays = [speed * result["time"] for speed in result["speeds"]]
    span = max(1.0, max(map(abs, rays)))
    xleft, xright = min(rays) - span, max(rays) + span
    phase = [(state[0], state[1]) for state in states]
    profiles = []
    for component in (0, 1):
        points = [(xleft, states[0][component])]
        for index, ray in enumerate(rays):
            points.extend([(ray, states[index][component]), (ray, states[index + 1][component])])
        points.append((xright, states[-1][component]))
        profiles.append(points)
    body = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="440" viewBox="0 0 1200 440">',
        '<rect width="1200" height="440" fill="#f2f5f8"/>',
        f'<text x="20" y="30" font-size="22">{escape(label)} at t={result["time"]:g}</text>',
        _panel(15, 50, 380, 370, phase, "Phase plane: q₂ versus q₁", "#116b7a"),
        _panel(410, 50, 380, 370, profiles[0], "q₁(x,t)", "#b35b1e"),
        _panel(805, 50, 380, 370, profiles[1], "q₂(x,t)", "#514a91"),
        '</svg>',
    ]
    return "\n".join(body) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--examples", type=Path, metavar="DIRECTORY")
    group.add_argument("--input", type=Path, metavar="JSON")
    parser.add_argument("--output", type=Path, help="SVG output when --input is used")
    args = parser.parse_args()
    if args.examples:
        args.examples.mkdir(parents=True, exist_ok=True)
        for name, problem in EXAMPLES.items():
            result = solve(problem)
            (args.examples / f"exercise31{name}.svg").write_text(
                svg_plot(result, f"Exercise 3.1({name})"), encoding="utf-8")
            (args.examples / f"exercise31{name}.json").write_text(
                json.dumps(result, indent=2) + "\n", encoding="utf-8")
            print(name, "speeds", result["speeds"], "states", result["states"])
    else:
        if args.output is None:
            parser.error("--output is required with --input")
        problem = json.loads(args.input.read_text(encoding="utf-8"))
        args.output.write_text(svg_plot(solve(problem), args.input.stem), encoding="utf-8")


if __name__ == "__main__":
    main()
