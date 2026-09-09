def compact_json(raw):
    """Remove only JSON whitespace outside strings; preserve every token byte."""
    value=decode(raw)
    result=bytearray();quoted=False;escaped=False
    for char in raw:
        if quoted:
            result.append(char)
            if escaped:escaped=False
            elif char==92:escaped=True
            elif char==34:quoted=False
        elif char==34:
            quoted=True;result.append(char)
        elif char not in b' \t\r\n':result.append(char)
    assert not quoted and not escaped
    result=bytes(result)
    assert decode(result)==value
    return result

def document_header(item):
    return ('\n\n'+item['label']+' SHA256 '+item['sha256']+'\n').encode()

def expand_blind(body,spans,canonical):
    """Resolve references only to the verbatim same-prompt canonical dossier."""
    previous_end=0
    for span in spans:
        start=span['canonical_start_byte'];end=span['canonical_end_byte_exclusive']
        assert type(start) is int and type(end) is int and 0<=start<end<=len(canonical)
        assert span['blind_start_byte']>=previous_end
        assert span['blind_end_byte_exclusive']-span['blind_start_byte']==end-start
        previous_end=span['blind_end_byte_exclusive']
        exact=canonical[start:end]
        assert digest(exact)==span['sha256']
        marker=span['marker_utf8'].encode()
        assert body.count(marker)==1,'Missing or repeated internal reference'
        body=body.replace(marker,exact,1)
    return body

def reconstruct(compact,mapping,inputs):
    """Independently restore reference bytes and original pinned JSON formatting."""
    by_name={Path(x['path']).name:x for x in inputs}
    canonical_item=by_name['declaration_dossier.md']
    canonical=Path(canonical_item['path']).read_bytes()
    assert digest(canonical)==canonical_item['sha256']
    assert compact.count(document_header(canonical_item)+canonical)==1
    previous_end=0
    for item in mapping['transformed_documents']:
        start=item['rendered_start_byte'];end=item['rendered_end_byte_exclusive']
        assert type(start) is int and type(end) is int and previous_end<=start<end<=len(compact)
        previous_end=end
    expanded=compact
    for item in reversed(mapping['transformed_documents']):
        pin=item['input'];raw=Path(pin['path']).read_bytes()
        assert digest(raw)==pin['sha256'] and len(raw)==pin['bytes']
        start=item['rendered_start_byte'];end=item['rendered_end_byte_exclusive']
        body=compact[start:end]
        assert digest(body)==item['rendered_sha256']
        if item['representation']=='exact same-prompt canonical document span':
            assert body==item['marker_utf8'].encode()
            restored=canonical[item['canonical_start_byte']:item['canonical_end_byte_exclusive']]
        elif item['representation']=='exact same-prompt canonical line spans':
            restored=expand_blind(body,item['spans'],canonical)
        elif item['representation']=='JSON whitespace only':
            assert compact_json(raw)==body and decode(raw)==decode(body)
            restored=raw
        else:raise AssertionError('Unknown reconstruction operation')
        assert restored==raw,'Reconstructed document differs from original bytes'
        expanded=expanded[:start]+restored+expanded[end:]
    assert digest(expanded)==mapping['original_prompt_sha256']
    return expanded

def deduplicate(prompt,inputs):
    """Exact duplicate spans plus JSON formatting only; no semantic projection."""
    names=[Path(x['path']).name for x in inputs]
    assert len(names)==len(set(names)),'Duplicate input document names'
    by_name={Path(x['path']).name:x for x in inputs}
    target=by_name['direct_review_packet.md'];container=by_name['declaration_dossier.md']
    blind_item=by_name['blind_dossier.md']
    bodies={}
    for item in inputs:
        path=Path(item['path']);raw=path.read_bytes()
        assert len(raw)==item['bytes'] and digest(raw)==item['sha256']
        if path.suffix in ('.md','.json'):
            assert prompt.count(document_header(item)+raw)==1,'Input document is not exact and unique'
            bodies[path.name]=raw
            if path.suffix=='.json':decode(raw)
    whole=bodies['declaration_dossier.md'];body=bodies['direct_review_packet.md']
    blind=bodies['blind_dossier.md']
    assert whole.count(body)==1,'Direct packet is not one exact contiguous dossier span'
    start=whole.index(body);end=start+len(body)
    assert prompt.index(document_header(target)+body)<prompt.index(document_header(container)+whole)
    assert prompt.index(document_header(container)+whole)<prompt.index(document_header(blind_item)+blind)
    assert b'[INTERNAL DD ' not in prompt and b'[LOSSLESS TRANSPORT NOTICE' not in prompt
    marker=("\n[LOSSLESS TRANSPORT NOTICE — SAME-PROMPT REFERENCES, NO TOOLS]\n"
        "DD denotes the complete direct declaration dossier supplied verbatim below, beginning "
        "at its first document byte (not at its prompt header). Its original SHA256 is "
        f"{container['sha256']}. This complete direct review packet is its exact UTF-8 byte "
        f"range [{start},{end}), original SHA256 {target['sha256']}. Read that same supplied "
        "content for this packet. In the later blind dossier, [INTERNAL DD start:end SHA256 hash] "
        "means the exact indicated DD bytes also occur at that location; read them as part of "
        "the blind dossier. Every unique Markdown byte is retained, and each referenced byte "
        "is present verbatim in DD in this same prompt. Native reconstruction verifies both "
        "complete original dossiers and the entire expanded prompt byte-for-byte. JSON documents "
        "may have formatting whitespace outside strings removed; every token, value, string "
        "escape and number byte is unchanged, duplicate keys are rejected, and parsed values "
        "are verified equal. Original header hashes identify the original documents, before "
        "these transport substitutions. All source images and other evidence are unchanged. "
        "The native role remains one turn and tool-free. Inspect the full evidence independently; "
        "these references supply no judgment or desired verdict.\n"
        "[END LOSSLESS TRANSPORT NOTICE]\n").encode()
    assert marker not in prompt
    compact=prompt.replace(document_header(target)+body,document_header(target)+marker,1)
    changes=[{'input':target,'representation':'exact same-prompt canonical document span',
        'canonical_start_byte':start,'canonical_end_byte_exclusive':end,'marker_utf8':marker.decode()}]
    rendered={target['path']:marker}
    # Match only byte-identical complete lines. No anonymized-name or semantic matching.
    aa=whole.splitlines(keepends=True);bb=blind.splitlines(keepends=True)
    ao=[0];bo=[0]
    for line in aa:ao.append(ao[-1]+len(line))
    for line in bb:bo.append(bo[-1]+len(line))
    spans=[];parts=[];cursor=0
    for block in difflib.SequenceMatcher(None,aa,bb,autojunk=False).get_matching_blocks():
        if not block.size:continue
        a,z=ao[block.a],ao[block.a+block.size];b,y=bo[block.b],bo[block.b+block.size]
        exact=whole[a:z]
        assert exact==blind[b:y]
        token=('\n[INTERNAL DD '+str(a)+':'+str(z)+' SHA256 '+digest(exact)+']\n').encode()
        if len(exact.decode())<=len(token.decode()):continue
        assert token not in prompt and all(x['marker_utf8']!=token.decode() for x in spans)
        parts.extend([blind[cursor:b],token]);cursor=y
        spans.append({'blind_start_byte':b,'blind_end_byte_exclusive':y,
            'canonical_start_byte':a,'canonical_end_byte_exclusive':z,
            'sha256':digest(exact),'marker_utf8':token.decode()})
    parts.append(blind[cursor:]);represented_blind=b''.join(parts)
    assert expand_blind(represented_blind,spans,whole)==blind
    if spans:
        compact=compact.replace(document_header(blind_item)+blind,
            document_header(blind_item)+represented_blind,1)
        changes.append({'input':blind_item,'representation':'exact same-prompt canonical line spans','spans':spans})
        rendered[blind_item['path']]=represented_blind
    json_checks=[]
    for item in inputs:
        if Path(item['path']).suffix!='.json':continue
        raw=bodies[Path(item['path']).name];small=compact_json(raw)
        assert compact.count(document_header(item)+raw)==1
        compact=compact.replace(document_header(item)+raw,document_header(item)+small,1)
        changes.append({'input':item,'representation':'JSON whitespace only'})
        rendered[item['path']]=small
        json_checks.append({'input':item,'compact_sha256':digest(small),'parsed_equal':True,
            'all_nonformatting_bytes_unchanged':True,'duplicate_keys_rejected':True})
    for change in changes:
        raw=rendered[change['input']['path']];header=document_header(change['input'])
        assert compact.count(header+raw)==1
        begin=compact.index(header+raw)+len(header)
        change.update(rendered_start_byte=begin,rendered_end_byte_exclusive=begin+len(raw),
            rendered_sha256=digest(raw))
    changes.sort(key=lambda x:x['rendered_start_byte'])
    mapping={'format':'exact-duplicate-spans-and-json-whitespace-3','container':container,
        'original_prompt_sha256':digest(prompt),'compact_prompt_sha256':digest(compact),
        'original_characters':len(prompt.decode()),'compact_characters':len(compact.decode()),
        'character_limit':LIMIT,'transformed_documents':changes,'json_checks':json_checks,
        'blind_reference_count':len(spans),'blind_referenced_bytes':sum(
            x['canonical_end_byte_exclusive']-x['canonical_start_byte'] for x in spans),
        'every_unique_markdown_byte_retained':True,'canonical_dossier_verbatim':True,
        'reconstruction_byte_equal':True}
    assert reconstruct(compact,mapping,inputs)==prompt
    for item in inputs:
        name=Path(item['path']).name
        if Path(item['path']).suffix=='.md' and name not in ('direct_review_packet.md','blind_dossier.md'):
            assert compact.count(document_header(item)+bodies[name])==1
    return compact,mapping

