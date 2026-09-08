"""Construct only an immutable request for the frozen V2 blocked-gate preparer.

Root supplies every status, narrative, completion claim and evidence reference.
No prepare/install, current_context, Git, audit or native command is invoked.
"""
from pathlib import Path
import argparse, hashlib, importlib.util, json, os, re, sys

H=Path(__file__).resolve().parent
S=H.parent
R=S.parents[3]
B=S/'blocked-gate-binding-transcript-order-v2/blocked_gate_binding.py'
B_SHA='dbfb374e263b7b0a2f25e9d1b8815a3e65d4e4e0e693581c24a881299fa017a9'
SCHEMA=B.parent/'input.schema.json'
SCHEMA_SHA='9daddcd180355375a4822206fa3056fb71d5b0abc84ca10606e9ea08870c12fd'
REF_KEYS=('base_gate','proposed_rows','check_inputs','source_manifest','question_projection','route_manifest')
SUFFIXES=('source-inventory','layout','tiers','compatibility','hygiene','audits','declarations','focused-build','full-build')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def require(value,message):
    if not value:raise ValueError(message)

def load_binding_helper():
    require(os.name!='nt','Run through the existing prepared POSIX launcher')
    require(sys.flags.optimize==0,'Optimized Python is forbidden')
    require(sha(B)==B_SHA and sha(SCHEMA)==SCHEMA_SHA,'Frozen V2 helper/schema changed')
    spec=importlib.util.spec_from_file_location('request_only_binding_primitives',B)
    b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
    return b

def validate_labels(labels):
    require(type(labels) is dict and set(labels)==set(SUFFIXES),'Exactly nine named receipt labels required')
    require(all(type(x) is str and re.fullmatch(r'[a-z0-9][a-z0-9-]*',x) for x in labels.values()),'Unsafe/missing receipt label')
    require(len(set(labels.values()))==9,'Receipt labels must be distinct')

def completion_kind(dossier):
    require(type(dossier) is dict and type(dossier.get('schema_version')) is int
            and dossier['schema_version']==1 and dossier.get('kind')=='reviewed-local-work-exhaustion',
            'A root completion dossier in the existing routeManifest shape is required; bounded reviews are not completion')
    require(type(dossier.get('rows')) is list and len(dossier['rows'])==9,'Exactly nine completion rows required')
    for row in dossier['rows']:
        require(type(row) is dict and row.get('all_local_work_complete') is True
                and row.get('remaining_local_actions')==[], 'Pending or unspecified local work')

def validate_context(context,checker):
    require(type(context) is dict and re.fullmatch(r'[0-9a-f]{40}',context.get('lean_current_head','')),
            'Explicit current-context HEAD required')
    bindings=context.get('bindings')
    require(type(bindings) is dict and set(bindings)==checker.BINDING_FIELDS,'Exact existing context binding fields required')
    for key,value in bindings.items():
        if key=='unit_audit_epoch':require(type(value) is str and bool(value.strip()),'Missing unit audit epoch')
        else:require(type(value) is str and re.fullmatch(r'[0-9a-f]{40}' if key=='lean_git_head' else r'[0-9a-f]{64}',value),'Invalid context digest: '+key)

def validate_native_inputs(b,reader,checker,request,base,base_bytes,context):
    """Same existing native-input relations as frozen prepare; no generated declarations."""
    m=reader.bound(request['check_inputs'])
    require(m['bindings']==context['bindings'] and m['input_commit']==context['lean_current_head']
            and m['rows_sha256']==checker.canonical_sha256(base['rows'])
            and m['source_gate_sha256']==b.digest(base_bytes),'Native inputs not bound to the supplied exact ACTIVE base/context')
    accepted=sorted([r for r in base['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES],key=lambda r:r['id'])
    names=sorted({n for row in accepted for n in row['lean_declarations']})
    require(len(accepted)==32 and names==m['declarations'] and type(m['count']) is int
            and len(names)==m['count']==32,'Exact closed declaration set required')
    require([x['row'] for x in m['files']]==[x['id'] for x in accepted],'Exact native file coverage/order required')
    for item,row in zip(m['files'],accepted,strict=True):
        require(item['declarations']==row['lean_declarations'] and item['contract_hash']==row['contract_hash']
                and item['audit_task']==row['faithfulness_task'],'Native row metadata mismatch')
        reader.raw(reader.path(item['path']),item['sha256'])
    reader.raw(reader.path(m['check_file']),m['check_file_sha256'])
    receipts,axioms=b.consume_receipts(request,reader,m,names,accepted,checker)
    return names,receipts,axioms

def construct(parameters_path,parameters_sha,label):
    b=load_binding_helper()
    require(re.fullmatch(r'[0-9a-f]{64}',parameters_sha),'Invalid parameter-file SHA')
    require(re.fullmatch(r'[a-z0-9][a-z0-9-]*',label),'Unsafe output label')
    out=H/'runs'/label
    require(not out.exists() and out.resolve().is_relative_to(H.resolve()),'Fresh contained output required')
    for parent in (out,*out.parents):require(not parent.is_symlink(),'Symlink output ancestor')
    reader=b.Reader(R)
    reader.raw(Path(__file__).resolve())
    checker=b.load_checker(reader)
    reader.raw(SCHEMA,SCHEMA_SHA)
    params=b.parse(reader.raw(parameters_path.absolute(),parameters_sha))
    b.closed(params,{'schema_version','kind',*REF_KEYS,'context','receipt_labels'},'constructor parameters')
    require(type(params['schema_version']) is int and params['schema_version']==1
            and params['kind']=='root-reviewed-blocked-request-inputs','Wrong parameter-file kind')
    validate_labels(params['receipt_labels'])
    context=reader.bound(params['context']);validate_context(context,checker)
    request={'schema_version':1,'kind':'blocked-gate-binding-request',**{k:params[k] for k in REF_KEYS},'receipts':{}}
    schema=b.parse(reader.raw(SCHEMA,SCHEMA_SHA))
    require(set(request)==set(schema['$defs']['request']['required']),'Request fields differ from frozen schema')
    require(set(SUFFIXES)==set(schema['$defs']['request']['properties']['receipts']['required']), 'Receipt set differs from frozen schema')
    base_path=reader.path(request['base_gate']['path'])
    require(base_path.resolve()!=b.GATE.resolve(),'Use a separate immutable base snapshot, never the operational gate path')
    base_bytes=reader.bound(request['base_gate'],as_json=False);base=b.parse(base_bytes)
    require(base.get('chapter_gate')=='ACTIVE','Exact supplied base must be ACTIVE')
    b.check_header(base,context,checker)
    proposed=reader.bound(request['proposed_rows']);b.closed(proposed,{'rows'},'proposed rows')
    identities=b.parse(reader.raw(b.PINS['row_set'][0]))
    dossier=reader.bound(request['route_manifest']);completion_kind(dossier)
    b.check_transition(base,proposed['rows'],identities,checker)
    b.check_provenance(request,proposed['rows'],context,reader,checker,identities)
    for suffix in SUFFIXES:
        receipt_label=params['receipt_labels'][suffix]
        pair={}
        for key,ending in [('exit','-exit.json'),('output','-output.txt')]:
            path=S/(receipt_label+ending)
            raw=reader.raw(path)
            pair[key]={'path':path.relative_to(R).as_posix(),'sha256':b.digest(raw)}
        request['receipts'][suffix]=pair
    names,receipts,axioms=validate_native_inputs(b,reader,checker,request,base,base_bytes,context)
    reader.unchanged()
    encoded=b.encode(request)
    record={'schema_version':1,'kind':'request-construction-input-checks','status':'REQUEST_ONLY',
            'constructor_sha256':sha(Path(__file__).resolve()),'helper_sha256':B_SHA,'schema_sha256':SCHEMA_SHA,
            'parameters':{'path':str(parameters_path.absolute()),'sha256':parameters_sha},
            'request_sha256':b.digest(encoded),'supplied_context':params['context'],
            'input_commit_supplied':context['lean_current_head'],'bindings_supplied':context['bindings'],
            'closed_declarations':names,'consumed_receipt_labels':params['receipt_labels'],
            'input_files':[{'path':str(path),'sha256':digest} for path,digest in sorted(reader.observed.items())],
            'live_projection_rechecked':True,'current_context_independently_queried':False,
            'operational_base_independently_compared':False,'prepare_run':False,'installation_run':False,
            'source_acceptance':False,'local_work_exhaustion_independently_established':False,
            'limits':'Only exact supplied records and existing validation primitives checked. Root owns route/status claims; later frozen prepare must compare actual current context and operational base, then separately reviewed installation and terminal checks remain.'}
    out.mkdir(parents=True)
    with (out/'request.json').open('xb') as stream:stream.write(encoded)
    reader.unchanged()
    with (out/'construction.json').open('xb') as stream:stream.write(b.encode(record))
    return {'status':'REQUEST_ONLY','request':b.make_ref(out/'request.json'),'construction':b.make_ref(out/'construction.json')}

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--inputs',required=True,type=Path)
    p.add_argument('--sha256',required=True)
    p.add_argument('--label',required=True)
    a=p.parse_args()
    print(json.dumps(construct(a.inputs,a.sha256,a.label),indent=2))

if __name__=='__main__':
    try:main()
    except (ValueError,KeyError,TypeError,OSError) as exc:raise SystemExit('REJECTED: '+str(exc)) from exc
