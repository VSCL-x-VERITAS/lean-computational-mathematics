"""Native isolated replay of one exact Mathlib source with its three package options."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess, sys, time

def install_native_long_path_io():
 """Use extended Windows paths only at I/O; preserve all logical Path strings."""
 import io
 if getattr(Path,'_audit_extended_io_installed',False):return
 assert os.name=='nt'
 def native_path(path):
  value=os.path.abspath(os.fspath(path))
  if value.startswith('\\\\?\\'):return value
  if value.startswith('\\\\'):return '\\\\?\\UNC\\'+value[2:]
  return '\\\\?\\'+value
 def normal_path(value):
  if value.startswith('\\\\?\\UNC\\'):return '\\\\'+value[8:]
  if value.startswith('\\\\?\\'):return value[4:]
  return value
 def path_open(self,mode='r',buffering=-1,encoding=None,errors=None,newline=None):
  return io.open(native_path(self),mode,buffering,encoding,errors,newline)
 def path_stat(self,*,follow_symlinks=True):return os.stat(native_path(self),follow_symlinks=follow_symlinks)
 def path_mkdir(self,mode=0o777,parents=False,exist_ok=False):
  try:os.mkdir(native_path(self),mode)
  except FileNotFoundError:
   if not parents or self.parent==self:raise
   self.parent.mkdir(parents=True,exist_ok=True)
   self.mkdir(mode,parents=False,exist_ok=exist_ok)
  except OSError:
   if not exist_ok or not self.is_dir():raise
 def path_iterdir(self):
  for name in os.listdir(native_path(self)):yield self/name
 def path_resolve(self,strict=False):return type(self)(normal_path(os.path.realpath(native_path(self),strict=strict)))
 Path.open=path_open;Path.stat=path_stat;Path.mkdir=path_mkdir;Path.iterdir=path_iterdir;Path.resolve=path_resolve
 Path._audit_extended_io_installed=True

install_native_long_path_io()

P = Path(__file__).resolve().parent / 'native-02'
P.mkdir(exist_ok=False)
R = P.parents[6]
assert R.name == 'lean-computational-mathematics' and os.name == 'nt'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def write(path, obj):
    with path.open('xb') as f:
        f.write((json.dumps(obj, indent=2, ensure_ascii=False) + '\n').encode())
def ref(path):
    return {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}

assert not (P / 'receipt.json').exists()
package = R / '.lake/packages/mathlib'
relative = Path('Mathlib/Analysis/Calculus/ContDiff/FTaylorSeries.lean')
source = package / relative
overlay = P / 'source'
target = overlay / relative
target.parent.mkdir(parents=True, exist_ok=False)
with target.open('xb') as f:
    f.write(source.read_bytes())
assert sha(target) == sha(source)
lake = shutil.which('lake')
assert lake
flags = ['-DautoImplicit=false', '-DmaxSynthPendingDepth=3', '-Dpp.unicode.fun=true']
pins = [source, package / 'lakefile.lean', R / 'lake-manifest.json', R / 'lean-toolchain']
compiled = package / '.lake/build/lib/lean' / relative.with_suffix('.olean')
pins.append(compiled)
for suffix in ('.olean.private', '.olean.server'):
    q = compiled.with_suffix(suffix)
    if q.exists(): pins.append(q)
for module in re.findall(r'^public import (\S+)', source.read_text(encoding='utf-8'), re.M):
    q = package / '.lake/build/lib/lean' / Path(module.replace('.', '/')).with_suffix('.olean')
    assert q.is_file(), q
    pins.append(q)
    for suffix in ('.olean.private', '.olean.server'):
        side = q.with_suffix(suffix)
        if side.exists(): pins.append(side)
    s = package / Path(module.replace('.', '/')).with_suffix('.lean')
    assert s.is_file()
    pins.append(s)
before = [ref(p) for p in pins]
write(P / 'inputs.json', {'source': ref(source), 'exact_copy': ref(target), 'pins': before,
      'flags': flags, 'scope': 'Direct imported Mathlib source and compiled artifacts, source compiler configuration, and unchanged existing FTaylorSeries compiled artifacts. No claim of whole transitive closure capture.'})
records = []
for label, args in [('version', ['env', 'lean', '--version']),
                    ('dependencies', ['env', 'lean', *flags, '--root', str(overlay), '--deps', str(target)]),
                    ('compile', ['env', 'lean', *flags, '--root', str(overlay), '-o', str(target.with_suffix('.olean')), str(target)])]:
    command = [lake, *args]
    start = time.monotonic()
    with (P / (label + '-stdout.txt')).open('xb') as out, (P / (label + '-stderr.txt')).open('xb') as err:
        result = subprocess.run(command, cwd=R, stdout=out, stderr=err)
    item = {'argv': command, 'cwd': str(R), 'exit_code': result.returncode,
            'elapsed_ms': round((time.monotonic() - start) * 1000),
            'stdout': ref(P / (label + '-stdout.txt')), 'stderr': ref(P / (label + '-stderr.txt'))}
    write(P / (label + '-exit.json'), item)
    records.append(item)
    print(json.dumps(item), flush=True)
    if label != 'compile': assert result.returncode == 0
after = [ref(p) for p in pins]
assert before == after and sha(target) == sha(source)
artifacts = [ref(p) for p in sorted(target.parent.iterdir()) if p.is_file()]
record = {'schema': 1, 'kind': 'isolated-mathlib-package-options-replay',
          'source_modified': False, 'canonical_compiled_outputs_modified': False,
          'inputs': ref(P / 'inputs.json'), 'commands': records, 'source_and_direct_pins_unchanged': True,
          'scratch_artifacts': artifacts, 'runner': ref(Path(__file__)),
          'interpretation': 'Actual compile outcome only; this does not establish why a failure occurs or authorize changed compiler options.'}
write(P / 'receipt.json', record)
print(json.dumps({'receipt': ref(P / 'receipt.json')}), flush=True)
sys.exit(records[-1]['exit_code'])
