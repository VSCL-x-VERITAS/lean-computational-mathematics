"""In-memory Git-object fixtures: no Git process, repository, ref or commit writes."""
import argparse, copy, hashlib, json, tempfile
from pathlib import Path
import common as c
import build_lane_inventory as inv
import prepare_two_lane_bundle as conv

HERE = Path(__file__).resolve().parent
def encoded(v): return c.canonical(v) + b'\n'
def fake_sha(v): return hashlib.sha1(encoded(v)).hexdigest()
def put(path,v): path.write_bytes(encoded(v))

class MemoryObjects:
    stores, refs, calls = {}, {}, []
    def __init__(self, repository): self.repository = repository
    def tree(self, commit): return self.stores[commit]['entries']
    def text(self,*args): return self.run(*args).decode().strip()
    def evidence(self,commit,ref):
        c.exact_keys(ref,('path','sha256'),'fixture reference')
        data = self.stores[commit]['files'][ref['path']]
        c.require(c.digest(data) == ref['sha256'],'candidate evidence hash mismatch')
        return data
    def run(self,*args):
        self.calls.append(args); c.require(args[0] in c.GitObjects.allowed,'mutating fixture operation')
        if args[0] == 'rev-parse':
            token=args[1]; tree=token.endswith('^{tree}'); ref=token.split('^{')[0]
            commit=self.refs.get(ref,ref)
            return ((self.stores[commit]['tree'] if tree else commit)+'\n').encode()
        if args[:3] == ('show','-s','--format=%P'): return (' '.join(self.stores[args[3]]['parents'])+'\n').encode()
        if args[:2] == ('rev-list','--first-parent'):
            out=[]; current=args[2]
            while current:
                out.append(current); parents=self.stores[current]['parents']; current=parents[0] if parents else None
            return ('\n'.join(out)+'\n').encode()
        if args[:2] == ('merge-base','--is-ancestor'):
            seen=set(); todo=[args[3]]
            while todo:
                current=todo.pop()
                if current in seen: continue
                seen.add(current); todo.extend(self.stores[current]['parents'])
            c.require(args[2] in seen,'fixture ancestry mismatch'); return b''
        raise AssertionError(args)

class MemoryBatch:
    def __init__(self,git): pass
    def get(self,oid,data=False):
        for commit in MemoryObjects.stores.values():
            for path,e in commit['entries'].items():
                if e['oid']==oid:
                    b=commit['files'][path]; return b if data else c.digest(b)
        raise KeyError(oid)
    def close(self): pass

def commit(files,parents):
    # Synthetic object keys, explicitly not Git/Lean evidence.
    entries={p:{'mode':'100644','oid':hashlib.sha1(b).hexdigest()} for p,b in files.items()}
    tree=fake_sha(entries); key=fake_sha([tree,parents])
    MemoryObjects.stores[key]={'files':copy.deepcopy(files),'entries':entries,'tree':tree,'parents':parents}
    return key

def fixture(directory,schema_path):
    MemoryObjects.stores={}; MemoryObjects.refs={}; MemoryObjects.calls=[]
    paths={k:directory/(k+'.json') for k in ('topology','request','status','mapping','merge','inspect')}
    gp=inv.GATE; ap='gates/leveque-finite-volume/artifacts/test/audits/'
    def gate(name=None,second='READY'):
        row={'id':'row','status':'PROVED' if name else 'READY','lean_declarations':[name] if name else []}
        if name: row['faithfulness_task']=ap+name+'/audit-task.json'
        return {'source_unit_sha256':'1'*64,'bindings':{'module_profile_sha256':'2'*64},'rows':[row,{'id':'context','status':second,'lean_declarations':[]}]}
    files={gp:encoded(gate()),'base.txt':b'Synthetic fixture only\n'}
    anchor=commit(files,[])
    records={}
    def add(name,module,index):
        src=module+'.lean'; files[src]=b'-- synthetic; no Lean proof\n'
        record={'name':name,'module':module,'kind':'theorem','type_sha256':str(index)*64,
                'value_sha256':str(index+1)*64,'recursor_values_sha256':'7'*64,'level_params_sha256':'8'*64}
        records[name]=record
        files['fp-'+name+'.json']=encoded({'normalization':'SYNTHETIC STRUCTURAL FIXTURE',
            'files':[{'path':src,'sha256':c.digest(files[src])}],'records':[record]})
        task={'task_id':name,'audit_output':ap+name+'/faithfulness','source':{'sha256':'1'*64},
              'target':{'file':src,'declaration':name}}
        files[ap+name+'/audit-task.json']=encoded(task)
        files[ap+name+'/faithfulness/decision.json']=encoded({'accepted':True,'classification':'SYNTHETIC'})
        files['producer-'+name+'.json']=encoded({'format':'canonical-producer-identity-v1','module':module,'declaration':name,
            'kind':record['kind'],'type_sha256':record['type_sha256'],'level_params_sha256':record['level_params_sha256']})
        files['policy-'+name+'.json']=encoded({'format':'synthetic-origin-policy','declaration':name})
    add('Example.old','Old',3); files[gp]=encoded(gate('Example.old')); inspect=commit(files,[anchor])
    add('Example.new','New',5); files[gp]=encoded(gate('Example.new','SKIPPED')); files['review.md']=b'Explicit fixture association; not semantic equality\n'
    merge=commit(files,[inspect]); candidate=commit(files,[anchor,merge])
    MemoryObjects.refs={'refs/heads/work':merge,'refs/remotes/origin/main':inspect,'refs/heads/integration/test':anchor}
    topology={'shared_anchor':anchor,'campaign_head':{'instance_id':'campaign','commit':anchor,'ref':'refs/heads/integration/test'},'instances':[
        {'id':'work','role':'formalization','repository':'memory','head':merge,'anchor':anchor,'ref':'refs/heads/work','allowed_destinations':['campaign']},
        {'id':'inspect','role':'reorganization','repository':'memory','head':inspect,'anchor':anchor,'ref':'refs/remotes/origin/main','allowed_destinations':['campaign']},
        {'id':'campaign','role':'canonical','repository':'memory','head':anchor,'anchor':anchor,'ref':'refs/heads/integration/test','allowed_destinations':[]}]}
    put(paths['topology'],topology)
    request={'request_id':'a'*64,'task':'prepare','remote_write_policy':'forbid','admission_backend':'none',
        'topology':{'sha256':c.load(paths['topology'])[1]},
        'inputs':[{'instance_id':v['id'],'commit':v['head'],'ref':v['ref'],'mode':'merge' if v['id']=='work' else 'inspect'} for v in topology['instances'][:2]],
        'destination':{'instance_id':'campaign','expected_old_commit':anchor,'ref':'refs/heads/integration/test'},
        'selected_units':[{'book_id':'leveque-finite-volume','unit_id':'1','gate':{'path':gp,'sha256':c.digest(files[gp])}}]}
    put(paths['request'],request)
    status={'schema_version':1,'workflow_schema_version':4,'request_id':request['request_id'],'request_sha256':c.load(paths['request'])[1],
        'current_state':'CANDIDATE','result_kind':'candidate','candidate':{'scratch_repository':'memory','commit':candidate,
        'tree':MemoryObjects.stores[candidate]['tree'],'parents':[anchor,merge]}}
    put(paths['status'],status)
    builder=lambda p,l,f,r:inv.build(p,l,f,r,MemoryObjects,MemoryBatch)
    previews={'work':builder(paths['topology'],'work',['fp-Example.old.json','fp-Example.new.json'],True),
              'inspect':builder(paths['topology'],'inspect',['fp-Example.old.json'],False)}
    put(paths['merge'],previews['work']); put(paths['inspect'],previews['inspect'])
    ref=lambda name:{'path':name,'sha256':c.digest(files[name])}
    mapping={'schema_version':2,'input_sha256':{},'review_evidence':ref('review.md'),'assets':[]}
    for lane,preview in previews.items():
        for a in preview['assets']:
            entry={'lane_id':lane,'preview_asset_id':a['asset_id'],'concept_id':'shared-'+a['kind'],
                   'disposition':a['disposition'] if lane=='work' else 'retained-unresolved'}
            if a['kind']=='declaration':
                entry['declaration_identity']={'module':a['module'],'declaration':a['name'],
                    'producer_payload':ref('producer-'+a['name']+'.json'),'policy_payload':ref('policy-'+a['name']+'.json')}
            mapping['assets'].append(entry)
    def bind():
        mapping['input_sha256']={k:c.load(paths[k])[1] for k in ('topology','request','status')}
        mapping['input_sha256'].update(epoch_schema=c.load(schema_path)[1],previews={'work':c.load(paths['merge'])[1],'inspect':c.load(paths['inspect'])[1]})
        put(paths['mapping'],mapping)
    def convert(): return conv.prepare([paths['merge'],paths['inspect']],paths['topology'],paths['request'],paths['status'],paths['mapping'],schema_path,MemoryObjects,builder)
    return paths,mapping,bind,convert,builder

def run(schema_path):
    checks=[]
    with tempfile.TemporaryDirectory(prefix='memory-fixture-',dir=HERE) as name:
        d=Path(name).resolve(); assert d.is_relative_to(HERE)
        paths,mapping,bind,convert,builder=fixture(d,schema_path); bind()
        original={k:p.read_bytes() for k,p in paths.items()}; original_mapping=copy.deepcopy(mapping)
        result=convert(); fields=result['epoch_fields']
        assert len(fields['lane_heads'])==2 and len(fields['branches'])==2
        assert sum(len(b['unique_assets']) for b in fields['branches'])==sum(a['unique'] for a in fields['assets'])
        assert len({a['asset_id'] for a in fields['assets']})==len(fields['assets'])
        inspected=[a for a in fields['assets'] if a['lane_id']=='inspect']
        assert inspected and all(a['disposition']=='retained-unresolved' for a in inspected)
        assert any(a['origin_disposition']=='selected' for a in inspected)
        assert any(a.get('origin_current_source_certificate') is True and a['current_source_certificate'] is False for a in inspected)
        assert result['lane_coverage']['inspect']['origin_open_source_rows']==['context']
        assert all(paths[k].read_bytes()==v for k,v in original.items())
        assert set(fields)=={'candidate','lane_heads','assets','branches'}
        checks.append('positive: both nonempty lanes; open inspection preserved; origin certificates separated; all unique occurrences retained; no input writes')
        def refusal(label,key,mutate,expected):
            for k,p in paths.items(): p.write_bytes(original[k])
            mapping.clear(); mapping.update(copy.deepcopy(original_mapping))
            if key=='mapping': mutate(mapping)
            else:
                value=c.load(paths[key])[0]; mutate(value); put(paths[key],value)
                if key=='request':
                    st=c.load(paths['status'])[0];st['request_sha256']=c.load(paths['request'])[1];put(paths['status'],st)
            bind()
            try: convert()
            except (c.InputError,KeyError) as e: assert expected in str(e),(label,str(e))
            else: raise AssertionError('accepted invalid fixture: '+label)
            checks.append('refuses: '+label)
        refusal('retained checkpoint','status',lambda v:v.update(current_state='QUEUED',result_kind='retained'),'actual recorded CANDIDATE')
        refusal('forged candidate tree','status',lambda v:v['candidate'].update(tree='0'*40),'candidate tree mismatch')
        refusal('forged inspection coverage','inspect',lambda v:v['file_coverage'].pop(next(iter(v['file_coverage']))),'complete origin Git inventory')
        refusal('inspection relabeled as merge','request',lambda v:v['inputs'][1].update(mode='merge'),'one merge and one inspect')
        refusal('gate not committed in merge input','request',lambda v:v['selected_units'][0]['gate'].update(sha256='0'*64),'request gate differs')
        refusal('open merge','merge',lambda v:v.update(open_source_rows=['row']),'merge preview must require')
        refusal('inspection origin head changed','inspect',lambda v:v.update(head='0'*40),'origin ref/head mismatch')
        refusal('missing mapping','mapping',lambda v:v['assets'].pop(),'every origin occurrence')
        refusal('duplicate mapping','mapping',lambda v:v['assets'].append(copy.deepcopy(v['assets'][0])),'duplicate identity mapping')
        refusal('inspection acceptance','mapping',lambda v:next(a for a in v['assets'] if a['lane_id']=='inspect').update(disposition='selected'),'inspection must be retained')
        refusal('fabricated supersession','mapping',lambda v:v['assets'][0].update(disposition='superseded'),'inspection must be retained')
        refusal('review hash changed','mapping',lambda v:v['review_evidence'].update(sha256='0'*64),'evidence hash mismatch')
        refusal('declaration renamed','mapping',lambda v:next(a for a in v['assets'] if 'declaration_identity' in a)['declaration_identity'].update(declaration='Wrong'),'identity renames')
        refusal('wrong producer payload','mapping',lambda v:next(a for a in v['assets'] if a.get('declaration_identity',{}).get('declaration')=='Example.old')['declaration_identity'].update(producer_payload={'path':'producer-Example.new.json','sha256':c.digest(MemoryObjects.stores[c.load(paths['status'])[0]['candidate']['commit']]['files']['producer-Example.new.json'])}),'producer payload differs')
        refusal('missing inspection unique asset','inspect',lambda v:v['branch']['unique_assets'].pop(),'complete origin Git inventory')
        for k,p in paths.items(): p.write_bytes(original[k])
        try: builder(paths['topology'],'inspect',['fp-Example.old.json'],True)
        except c.InputError as e: assert 'open source rows' in str(e)
        else: raise AssertionError('inspection falsely closed')
        checks.append('refuses: all-closed applied to actually open inspection')
        oldref=MemoryObjects.refs['refs/remotes/origin/main']; MemoryObjects.refs['refs/remotes/origin/main']='0'*40
        try: builder(paths['topology'],'work',['fp-Example.old.json','fp-Example.new.json'],True)
        except (c.InputError,KeyError): pass
        else: raise AssertionError('ignored inspection ref drift')
        MemoryObjects.refs['refs/remotes/origin/main']=oldref
        checks.append('refuses: real-ref-shaped inspection drift')
        assert all(call[0] in c.GitObjects.allowed for call in MemoryObjects.calls)
    print(json.dumps({'scope':'In-memory synthetic Git-object fixtures only, no Git subprocess/ref/commit writes',
                      'count':len(checks),'checks':checks,'released_schema_sha256':c.load(schema_path)[1]},indent=2))

if __name__=='__main__':
    p=argparse.ArgumentParser(); p.add_argument('--epoch-schema',type=Path,required=True)
    run(p.parse_args().epoch_schema)
