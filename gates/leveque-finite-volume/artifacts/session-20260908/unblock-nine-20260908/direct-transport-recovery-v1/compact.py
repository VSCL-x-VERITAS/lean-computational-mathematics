"""Exact-byte dictionary transport. No source interpretation or evidence selection."""
import hashlib,json,bisect
def digest(b):return hashlib.sha256(b).hexdigest()
PREFIX=b'[[DX'
NOTICE=(b'[[DIRECT-LOSSLESS-NOTICE]]\n'
 b'Transport representation only. The original direct-role input is represented below with exact duplicate byte ranges referenced in place. '
 b'[[DXB:Bnnnn]] and [[DXE:Bnnnn]] enclose a canonical block present VERBATIM in this same prompt. [[DXR:Bnnnn:start:end]] names its UTF-8 byte range [start,end); substitute those exact bytes at the reference, with no added spaces or newlines. '
 b'Treat all original documents, including JSON, as their fully expanded content. Block wrappers and reference markers are transport syntax, not evidence or mathematical notation. '
 b'No semantic summaries, additional evidence, name matching, or inferred equality are used. Every reference is byte-identical to its canonical range. '
 b'Native reconstruction checks the entire original input byte-for-byte; the original document SHA256 labels remain hashes of the expanded originals. '
 b'All original instructions, role isolation and attached source images apply unchanged. Read all evidence independently. No prior judgment or desired verdict is supplied. '
 b'Use no tools. This is a fresh one-turn direct judge.\n[[DIRECT-LOSSLESS-END-NOTICE]]\n')

def discover(raw,minimum=512,protected=None):
    """Greedy LZ matches whose sources stay in earlier, unmodified raw intervals."""
    assert PREFIX not in raw
    protected=sorted(protected or [])
    assert all(0<=a<b<=len(raw) for a,b in protected)
    assert all(x[1]<=y[0] for x,y in zip(protected,protected[1:]))
    index={};segments=[];current=0;i=0;matches=[];keylen=32;pi=0
    while i+minimum<=len(raw):
        while pi<len(protected) and protected[pi][1]<=i:pi+=1
        if pi<len(protected) and protected[pi][0]<=i<protected[pi][1]:
            segments.append((current,i));i=protected[pi][1];current=i;continue
        key=raw[i:i+keylen];choices=index.get(key,[]);best=None
        for p,segment in reversed(choices[-12:]):
            end=segments[segment][1] if segment<len(segments) else i
            limit=min(end-p,len(raw)-i)
            if pi<len(protected) and i<protected[pi][0]:limit=min(limit,protected[pi][0]-i)
            if limit<minimum:continue
            if raw[p:p+minimum]!=raw[i:i+minimum]:continue
            n=minimum
            while n+256<=limit and raw[p+n:p+n+256]==raw[i+n:i+n+256]:n+=256
            while n<limit and raw[p+n]==raw[i+n]:n+=1
            # Never split a UTF-8 code point at either end.
            while n and (i+n<len(raw) and raw[i+n]&0xc0==0x80):n-=1
            if n>=minimum and (best is None or n>best[2]):best=(p,i,n)
        if best and raw[i]&0xc0!=0x80 and raw[best[0]]&0xc0!=0x80:
            p,q,n=best
            assert p+n<=q and raw[p:p+n]==raw[q:q+n]
            matches.append({'source_start':p,'source_end':p+n,'start':q,'end':q+n})
            segments.append((current,i));i+=n;current=i
        else:
            if raw[i]&0xc0!=0x80:
                choices.append((i,len(segments)))
                if len(choices)>12:del choices[0]
                index[key]=choices
            i+=1
    segments.append((current,len(raw)))
    return matches

def encode(raw,minimum=512,protected=None):
    matches=discover(raw,minimum,protected)
    bands=[]
    for m in sorted(matches,key=lambda x:x['source_start']):
        if bands and m['source_start']<=bands[-1][1]:bands[-1][1]=max(bands[-1][1],m['source_end'])
        else:bands.append([m['source_start'],m['source_end']])
    for a,b in bands:
        assert all(b<=m['start'] or m['end']<=a for m in matches)
    operations=[];blocks=[]
    for i,(a,b) in enumerate(bands):
        ident=f'B{i+1:04d}';body=raw[a:b]
        opening=(f'[[DXB:{ident}]]').encode()
        closing=(f'[[DXE:{ident}]]').encode()
        blocks.append({'id':ident,'original_start':a,'original_end':b,'sha256':digest(body),'opening':opening.decode(),'closing':closing.decode()})
        operations.append((a,b,opening+body+closing,'canonical',i))
    for i,m in enumerate(matches):
        block=next(b for b in blocks if b['original_start']<=m['source_start']<m['source_end']<=b['original_end'])
        a=m['source_start']-block['original_start'];b=m['source_end']-block['original_start']
        exact=raw[m['source_start']:m['source_end']]
        token=(f'[[DXR:{block["id"]}:{a}:{b}]]').encode()
        m.update(block=block['id'],block_start=a,block_end=b,sha256=digest(exact),token=token.decode())
        operations.append((m['start'],m['end'],token,'reference',i))
    out=bytearray(NOTICE);cursor=0
    for a,b,body,kind,i in sorted(operations):
        assert cursor<=a
        out+=raw[cursor:a];position=len(out);out+=body;cursor=b
        obj=blocks[i] if kind=='canonical' else matches[i]
        obj['rendered_start']=position;obj['rendered_end']=len(out)
    out+=raw[cursor:];compact=bytes(out)
    mapping={'format':'direct-exact-byte-dictionary-1','original_sha256':digest(raw),'compact_sha256':digest(compact),
        'original_bytes':len(raw),'original_characters':len(raw.decode()),'compact_bytes':len(compact),
        'compact_characters':len(compact.decode()),'minimum_match':minimum,'notice':NOTICE.decode(),
        'blocks':blocks,'references':matches,'referenced_bytes':sum(m['end']-m['start'] for m in matches)}
    assert reconstruct(compact,mapping)==raw
    return compact,mapping

def reconstruct(compact,mapping):
    assert digest(compact)==mapping['compact_sha256']
    notice=mapping['notice'].encode();assert notice==NOTICE and compact.startswith(notice)
    operations=[];blocks={}
    for b in mapping['blocks']:
        assert b['id'] not in blocks
        a,z=b['rendered_start'],b['rendered_end'];opening=b['opening'].encode();closing=b['closing'].encode()
        rendered=compact[a:z]
        assert rendered.startswith(opening) and rendered.endswith(closing)
        exact=rendered[len(opening):-len(closing)]
        assert PREFIX not in exact and digest(exact)==b['sha256'] and len(exact)==b['original_end']-b['original_start']
        blocks[b['id']]=exact;operations.append((a,z,exact))
    for m in mapping['references']:
        body=blocks[m['block']];a,z=m['block_start'],m['block_end']
        assert type(a) is int and type(z) is int and 0<=a<z<=len(body)
        exact=body[a:z];assert digest(exact)==m['sha256'] and len(exact)==m['end']-m['start']
        p,q=m['rendered_start'],m['rendered_end'];assert compact[p:q]==m['token'].encode()
        assert m['token']==f'[[DXR:{m["block"]}:{a}:{z}]]'
        operations.append((p,q,exact))
    out=bytearray();cursor=len(notice)
    for a,z,exact in sorted(operations):
        assert cursor<=a<z<=len(compact)
        out+=compact[cursor:a];out+=exact;cursor=z
    out+=compact[cursor:];raw=bytes(out)
    assert PREFIX not in raw
    assert len(raw)==mapping['original_bytes'] and digest(raw)==mapping['original_sha256']
    return raw

if __name__=='__main__':
    import os,time
    from pathlib import Path
    D=Path(__file__).resolve().parent
    exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
    R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
    p=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt'
    t=time.monotonic();c,m=encode(p.read_bytes())
    for name,value in [('candidate-input.txt',c),('candidate-map.json',(json.dumps(m,indent=2)+'\n').encode())]:
        with (D/name).open('xb') as f:f.write(value)
    print(json.dumps({k:v for k,v in m.items() if k not in ('blocks','references','notice')}|{'blocks':len(m['blocks']),'references':len(m['references']),'elapsed':time.monotonic()-t},indent=2))
