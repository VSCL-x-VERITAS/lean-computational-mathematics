"""Capture actual guard tests and preparation only; never execute the handoff."""
from pathlib import Path
import importlib.util
F=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('retry_recover',F/'recover.py')
mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
mod.step(F,'guard-tests',mod.native(F/'test_recover.py'))
mod.step(F,'handoff-preparation',mod.native(F/'recover.py','prepare','--destination',F/'handoff-plan'))
