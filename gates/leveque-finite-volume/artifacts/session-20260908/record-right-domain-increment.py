"""Record actual right-mode checks and preserve separate source/process findings."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent
R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
record={'schema':1,'checks':[]}
for prefix in ['right-domain-production-build','right-domain-production-checks','right-domain-layout',
               'right-domain-compatibility','right-domain-tiers-recounted','right-domain-placeholders',
               'transport-integral-nonaccepted-complete','right-mode-nonaccepted-complete']:
    out=S/(prefix+'-output.txt'); ep=S/(prefix+'-exit.json')
    e=json.loads(ep.read_text(encoding='utf-8-sig'))
    assert type(e['exit_code']) is int and e['exit_code']==0,prefix
    record['checks'].append({'check':prefix,'command':e['command'],'exit_code':0,
        'output':out.relative_to(R).as_posix(),'output_sha256':sha(out.read_bytes()),
        'exit':ep.relative_to(R).as_posix(),'exit_sha256':sha(ep.read_bytes())})
layout=(S/'right-domain-layout-output.txt').read_text(encoding='utf-8-sig')
for line in ['Lean modules: 5921','unclassified modules: 0','mixed modules: 0',
    'modules missing module docs: 0','legacy naming exceptions: 0','declaration-bearing umbrellas: 0',
    'unsorted aggregate imports: 0','Layout contract satisfied']:assert line in layout
assert '14838 Lean file(s)' in (S/'right-domain-placeholders-output.txt').read_text(encoding='utf-8-sig')
inputs=json.loads((S/'right-domain-production-inputs.json').read_text())
for f in inputs['files']:assert sha((R/f['path']).read_bytes())==f['sha256']
assert sha((S/'right-domain-production-checks.lean').read_bytes())==inputs['check_file_sha256']
assert sha((R/inputs['aggregate']['path']).read_bytes())==inputs['aggregate']['sha256']
name=inputs['files'][0]['declarations'][0]
out=(S/'right-domain-production-checks-output.txt').read_text(encoding='utf-8-sig')
m=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',out)
assert m and {x.strip() for x in m.group(1).split(',') if x.strip()}<={'propext','Quot.sound','Classical.choice'}
record['files']=inputs['files'];record['aggregate']=inputs['aggregate']
tier=json.loads((S/'right-domain-tier-recount.json').read_text())
assert sha((R/'docs/architecture/tiers.json').read_bytes())==tier['sha256']
assert tier['counts']['production_modules']==5921 and tier['new_exact_rules']==0
record['tiers']=tier
bindings=json.loads((S/'right-domain-recounted-rebinding-receipt.json').read_text())
assert len(bindings)==6 and all(x['exit_code']==0 for x in bindings)
record['rebindings']=bindings
record['organization']={'unclassified_modules':0,'duplicate_wrappers':0,'placeholder_findings':0,'canonical_placement_pending':0}
record['review']='The only new owner is a 48-line source wrapper reusing the existing characteristic-combination theorem. It adds the positive-ratio domain without asserting physical admissibility of negative material values. Full layout, compatibility, tiers, placeholders and native declaration/axiom checks passed; the existing reviewed source prefix is counted exactly.'
A=S/'audits/LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908/faithfulness'
decision=(A/'decision.json').read_bytes()
assert sha(decision)=='b2047373180d8d4fd572bdfc2a24a9905b7d4c750b228f4888da15a2727ba843'
d=json.loads(decision)
assert d['classification']=='undetermined' and d['accepted'] is False and d['adjudicated'] is True
assert all(x['verdict']=='unclear' for x in d['implications'].values())
source=R/'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
process=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
entries=[(source,'LEV-C1-TRANSPORT-SOLUTION-CONTEXT-009',
'| LEV-C1-TRANSPORT-SOLUTION-CONTEXT-009 | LEV-CH01-EQ-1.3-ADVECTED-PROFILE | unresolved source admissibility and temporal interpretation | Chapter 1 allows arbitrary profiles and discontinuities while retaining a displayed mass-derivative conservation law; selected pages do not specify the exact nonsmooth profile class or exceptional-time convention | The transport target proves initial data, unchanged shape, characteristic constancy, classical PDE under necessary differentiability and rectangle conservation under necessary local interval integrability | undetermined after 24-trigger independent adjudication; accepted false; both implications unclear; no source discrepancy certified | decision SHA-256 b2047373180d8d4fd572bdfc2a24a9905b7d4c750b228f4888da15a2727ba843; report SHA-256 5dfa554bafa1a438cae7b24e50316cfeaa5a0a9b6f2e8391ff3b102800a3f176; root complete validation exit 0 | Preserve the frozen result. Use the same book\'s printed pp215-216 weak-solution discussion as additional explanatory context in a fresh audit. It supplies a test-function definition and asserts integral equivalence; it does not by itself settle every source-domain and temporal question. |'),
(process,'BF-LEV-RUN-20260908-013',
'| BF-LEV-RUN-20260908-013 | 2026-09-08 | sealed v1 external dependency frontier | Real.measureSpace was displayed as inferInstance without its explicit selected argument; MeasureSpace.volume only projected the fixed instance. The native measure was not shown incorrect. | Frozen transport decision b2047373180d8d4fd572bdfc2a24a9905b7d4c750b228f4888da15a2727ba843; immutable real-measure-dependency dossier v2 SHA b4054b6e2a31cb3597acc2a3811a64a71d479fefe99717533c34ca708bdb8c92; root verification c54645ba9e251f9e8039a76a1fa04ee57767c4b490b3829a673196270b5fde5f | Missing exact-instance evidence prevented independent normalization review. | implementation evidence resolved locally; fresh semantic use remains actionable | The pinned native instance selects normalized real length measure; 16 axiom checks and 12 source/compiled owner hashes were verified. Use a new environment-bound config and fresh direct/adjudicator evidence under the documented v1 route, leaving blind packets, old config, kit and all frozen decisions untouched. |'),
(process,'BF-LEV-RUN-20260908-014',
'| BF-LEV-RUN-20260908-014 | 2026-09-08 | prefix-covered source-module census | Adding the right-mode wrapper under a reviewed prefix did not require a new exact rule, but the first tier scan found stale production and source counts. | right-domain-tiers-exit.json preserves failure; right-domain-tier-recount.json changes only measured census/prefix use; right-domain-tiers-recounted-exit.json and full layout scan pass with 5921 modules. | A valid classification prefix does not make stored measured counts current. | repaired; original failed scan and stale intermediate bindings retained | Update the measured census after every new owner and rebind all six closed rows after that controlled-file change; current right-domain-recounted bindings passed. |')]
for path,ident,entry in entries:
    before=path.read_bytes();assert ident.encode() not in before
    snapshot=S/('ledger-before-'+ident+'-'+sha(before)+'.bin');snapshot.write_bytes(before)
    path.write_bytes(before.rstrip(b'\r\n')+b'\n'+entry.encode()+b'\n')
record['ledger_sha256']={'source':sha(source.read_bytes()),'process':sha(process.read_bytes())}
G=R/'gates/leveque-finite-volume/chapter-01.json';before=G.read_bytes();g=json.loads(before)
assert len([r for r in g['rows'] if r['status'] in ['REUSED','PROVED','DISCREPANCY']])==6
(S/('gate-before-right-domain-increment-'+sha(before)+'.json')).write_bytes(before)
g['verification_loops']['organization_completeness']=record['organization']
updates={
'LEV-CH01-ACOUSTICS-RIGHT-MODE':'The broader positive-ratio source wrapper passed native build, exact declaration/axiom checks, full organization and sealed preparation. Complete the fresh independent LEV-CH01-ACOUSTICS-RIGHT-MODE-ALGEBRAIC-PRODUCTION-20260908 audit; preserve the old parameter-domain uncertainty and close only on an accepted complete decision.',
'LEV-CH01-EQ-1.3-ADVECTED-PROFILE':'The transport-integral successor remains undetermined after independent adjudication. Exact real-measure evidence is now frozen and native checked. Complete a fresh environment-bound audit using the same book\'s own weak-solution context, preserving prior source-domain and temporal uncertainty; no source discrepancy or row closure is yet certified.'}
for row in g['rows']:
    if row['id'] in updates:
        assert row['status']=='READY';row['next_foundation']=updates[row['id']]
record['counts']={'formalized':6,'denominator':41,'remaining':35,'skipped':16,'deferred':0}
record['global_checks']='All eight remain OPEN; full-library build is separate and not certified by this focused receipt.'
dest=S/'right-domain-increment-verification.json';assert not dest.exists()
dest.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
G.write_text(json.dumps(g,indent=2,ensure_ascii=False)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'verification_sha256':sha(dest.read_bytes()),'gate_sha256':sha(G.read_bytes()),'counts':record['counts'],'organization':record['organization']}))
