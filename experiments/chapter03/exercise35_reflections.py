"""LeVeque Exercise 3.5: exact step plots for the reflected acoustic pulse.

The sound speed and density remain user parameters. The default values 1,1
give a readable example; all six source times are plotted at the chosen speed.
"""

from __future__ import annotations

import argparse
import math
from pathlib import Path

TIMES = (0.0, 0.5, 1.0, 1.5, 2.0, 3.0)


def reflected_pulse(x: float) -> float:
    phase = x % 8.0
    return float(1.0 <= phase <= 2.0 or 6.0 <= phase <= 7.0)


def state(x: float, time: float, density: float, speed: float) -> tuple[float, float]:
    left = reflected_pulse(x + speed * time)
    right = reflected_pulse(x - speed * time)
    return (left + right) / 2.0, (right - left) / (2.0 * density * speed)


def breakpoints(time: float, speed: float) -> list[float]:
    points = [0.0, 4.0]
    for k in range(-math.ceil(speed * time / 8) - 2,
                   math.ceil(speed * time / 8) + 3):
        for edge in (1.0, 2.0, 6.0, 7.0):
            for shift in (-speed * time, speed * time):
                x = edge + 8 * k + shift
                if 0 < x < 4:
                    points.append(x)
    return sorted(set(points))


def step_points(time: float, density: float, speed: float, component: int) -> list[tuple[float, float]]:
    cuts = breakpoints(time, speed)
    values = [state((a + b) / 2, time, density, speed)[component]
              for a, b in zip(cuts, cuts[1:])]
    points = [(cuts[0], values[0])]
    for index in range(1, len(cuts) - 1):
        points.extend([(cuts[index], values[index - 1]), (cuts[index], values[index])])
    points.append((cuts[-1], values[-1]))
    return points


def render(density: float, speed: float) -> str:
    width, height = 1150, 1290
    text = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#f5f7fa"/>',
        f'<text x="28" y="34" font-size="22">Exercise 3.5: reflected pressure and velocity, density={density:g}, c={speed:g}</text>',
    ]
    for row, time in enumerate(TIMES):
        y0 = 55 + row * 200
        for component, title, color in ((0, "pressure p", "#176f80"),
                                        (1, "velocity u", "#a34c35")):
            x0 = 20 + component * 565
            points = step_points(time, density, speed, component)
            values = [y for _, y in points]
            ymin, ymax = min(values), max(values)
            pad = max(0.15, 0.15 * (ymax - ymin))
            ymin, ymax = ymin - pad, ymax + pad
            def px(x: float) -> float:
                return x0 + 40 + x / 4 * 495
            def py(y: float) -> float:
                return y0 + 167 - (y - ymin) / (ymax - ymin) * 125
            route = " ".join(f"{px(x):.2f},{py(y):.2f}" for x, y in points)
            text.extend([
                f'<rect x="{x0}" y="{y0}" width="550" height="187" fill="white" stroke="#b9c4d0"/>',
                f'<text x="{x0 + 12}" y="{y0 + 23}" font-size="16">t={time:g}, {title}</text>',
                f'<polyline points="{route}" fill="none" stroke="{color}" stroke-width="2.5"/>',
                f'<text x="{x0 + 12}" y="{y0 + 179}" font-size="11">x in [0,4], value range {min(values):.3g} to {max(values):.3g}</text>',
            ])
    text.append('</svg>')
    return "\n".join(text) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--density", type=float, default=1.0)
    parser.add_argument("--sound-speed", type=float, default=1.0)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not math.isfinite(args.density) or not math.isfinite(args.sound_speed) or args.density <= 0 or args.sound_speed <= 0:
        parser.error("density and sound speed must be positive finite numbers")
    args.output.write_text(render(args.density, args.sound_speed), encoding="utf-8")
    print(f"wrote {args.output}; times={TIMES}")


if __name__ == "__main__":
    main()
