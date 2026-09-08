"""Replay the complete source and compiled architecture check in this checkout.

The reconciliation verifier schedules graph checks before its separate full
build check. Build the pinned libraries here so this also works in a pristine
candidate, then invoke the repository's unchanged full graph validator.
Successful build progress is not a stable semantic output; failures retain the
entire captured diagnostic and the original nonzero status.
"""
from pathlib import Path
import argparse,json,subprocess,sys

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline-name',required=True)
    args=parser.parse_args()
    if not args.baseline_name.replace('-','').isalnum():
        parser.error('baseline name must contain only letters, numbers and hyphens')
    session=Path(__file__).resolve().parent
    root=session.parents[3]
    graph_dir=session/'architecture-graphs'
    baseline=graph_dir/(args.baseline_name+'.json')
    if not baseline.is_file():parser.error('committed baseline is missing')
    commands=[
        ['lake','--quiet','--log-level=error','build','ComputationalMathematics','NumStability'],
        [sys.executable,'tools/architecture/generate_baseline.py','--no-build','--strict-source',
         '--check','--output-dir',graph_dir.relative_to(root).as_posix(),'--name',args.baseline_name],
    ]
    for command in commands:
        result=subprocess.run(command,cwd=root,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        if result.returncode:
            sys.stdout.buffer.write(result.stdout)
            return result.returncode
    data=json.loads(baseline.read_text(encoding='utf-8'))
    print('Candidate source, import, signature and body graphs match the committed baseline; both production libraries build successfully. Source tree SHA-256: '+data['source']['source_tree_sha256'])
    return 0

if __name__=='__main__':raise SystemExit(main())
