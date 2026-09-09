"""POSIX Lean command adapter: exact two Mathlib snapshots get package options.

All other source compilations and the dossier --run preserve lake env lean.
No input rewriting, stdout filtering, environment changes or semantic override.
"""
from pathlib import Path
import hashlib
import os
import subprocess
import sys

ROOT = next(path for path in Path(__file__).resolve().parents if (path / 'lean-toolchain').is_file())
PACKAGE = '.lake/packages/mathlib/lakefile.lean'
PACKAGE_SHA256 = '25966b1899a1aab3fa530abf39360189eb48ccc6e048f0bf9a1725f4c38346c4'
SOURCES = {
    'Mathlib/Analysis/Calculus/ContDiff/Defs.lean': '793a1ca70881ed469c78feeb0724766b6a2d933e51a8fad5b9c87e67228c5711',
    'Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean': 'a507aab3122399fda58585255b66e44094ce06494ecec66dd279a7769e9740aa',
}
OPTIONS = ['-DautoImplicit=false', '-DmaxSynthPendingDepth=3', '-Dpp.unicode.fun=true']


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def command(arguments):
    require(sha(ROOT / PACKAGE) == PACKAGE_SHA256, 'Mathlib package configuration changed')
    options = []
    if len(arguments) == 5 and arguments[0] == '--root' and arguments[2] == '-o':
        build, output, source = map(lambda value: Path(value).resolve(), (arguments[1], arguments[3], arguments[4]))
        require(source.is_relative_to(build) and output.is_relative_to(build), 'Staged paths escape the declared build root')
        relative = source.relative_to(build).as_posix()
        if relative in SOURCES:
            require(output == source.with_suffix('.olean'), 'Unexpected exact-module output path')
            require(not source.is_symlink() and sha(source) == SOURCES[relative], 'Mirrored Mathlib source differs')
            upstream = ROOT / '.lake/packages/mathlib' / relative
            require(sha(upstream) == SOURCES[relative], 'Pinned upstream Mathlib source differs')
            options = OPTIONS
    elif arguments and arguments[0] == '--run':
        require(len(arguments) == 5, 'Unexpected dossier argument count')
    else:
        raise ValueError('Only unchanged released compile or dossier argument forms are supported')
    return ['lake', 'env', 'lean', *options, *arguments]


def main():
    require(os.name != 'nt', 'The configured adapter runs in the released POSIX environment')
    require(Path.cwd().resolve() == ROOT.resolve(), 'Expected unchanged repository working directory')
    # subprocess inherits all streams and the exact environment, including LEAN_PATH.
    # No writes except Lean's explicitly requested scratch compilation outputs.
    return subprocess.run(command(sys.argv[1:]), cwd=ROOT).returncode


if __name__ == '__main__':
    raise SystemExit(main())
