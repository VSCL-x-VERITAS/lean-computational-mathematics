def load_source_context(root, reference, source, pages_arg, render_root):
 """Validate explicit source context before sealing a fresh task; no source verdict."""
 def unique(pairs):
  result={}
  for key,value in pairs:
   assert key not in result,('duplicate JSON key',key)
   result[key]=value
  return result
 def load_ref(ref):
  assert isinstance(ref,dict) and set(ref)=={'path','sha256'}
  rel=ref['path'];digest=ref['sha256']
  assert isinstance(rel,str) and rel and '\\' not in rel and ':' not in rel
  assert all(part not in ('','.','..') for part in rel.split('/')) and not Path(rel).is_absolute()
  assert isinstance(digest,str) and len(digest)==64 and all(c in '0123456789abcdef' for c in digest)
  path=root/rel
  assert path.is_file() and not path.is_symlink() and path.resolve().is_relative_to(root.resolve())
  raw=path.read_bytes();assert hashlib.sha256(raw).hexdigest()==digest,(rel,'hash changed')
  return raw
 extension=json.loads(load_ref(reference),object_pairs_hook=unique)
 assert set(extension)=={'format','source','primary_locations','inherited_locations','pages','images','interpretation_receipts'}
 assert extension['format']=='pinned-source-context-extension-1'
 assert extension['source']=={'path':source['path'],'sha256':source['sha256']}
 load_ref(extension['source'])
 assert extension['primary_locations']==source['locations'], 'Primary locator must remain exact.'
 def locations(items):
  assert isinstance(items,list) and items
  for item in items:
   assert isinstance(item,dict) and set(item)=={'location','anchor'}
   assert all(isinstance(value,str) and value.strip() for value in item.values())
 locations(extension['primary_locations']);locations(extension['inherited_locations'])
 selected=extension['primary_locations']+extension['inherited_locations']
 assert len({json.dumps(item,sort_keys=True) for item in selected})==len(selected)
 pages=extension['pages']
 assert isinstance(pages,list) and pages and all(type(page) is int and page>0 for page in pages)
 assert len(set(pages))==len(pages) and pages_arg==','.join(map(str,pages))
 assert isinstance(extension['images'],list) and len(extension['images'])==len(pages)
 hashes={};pins=[reference,extension['source']]
 for page,item in zip(pages,extension['images']):
  assert isinstance(item,dict) and set(item)=={'page','path','sha256'} and item['page']==page
  image_ref={key:item[key] for key in ('path','sha256')}
  raw=load_ref(image_ref)
  assert raw.startswith(b'\x89PNG\r\n\x1a\n')
  assert (render_root/('page-'+str(page).zfill(3)+'.png')).read_bytes()==raw,'Rendering differs from pinned source transport.'
  hashes[str(page)]=item['sha256'];pins.append(image_ref)
 receipts=extension['interpretation_receipts']
 assert isinstance(receipts,list) and receipts
 assert len({item['path'] for item in receipts})==len(receipts)
 exact=[]
 for ref in receipts:
  raw=load_ref(ref);receipt=json.loads(raw,object_pairs_hook=unique)
  assert receipt['kind']=='explicit user-adopted source interpretation'
  assert receipt['source_sha256']==source['sha256']
  for key in ('question','answer','scope','authority_limit'):
   assert isinstance(receipt[key],str) and receipt[key].strip()
  assert isinstance(receipt['adopted_interpretation'],list) and receipt['adopted_interpretation']
  assert all(isinstance(item,str) and item.strip() for item in receipt['adopted_interpretation'])
  assert isinstance(receipt['preservation'],list) and receipt['preservation']
  question=receipt['question_item_id']
  assert isinstance(question,list) and len(question)==3 and question[0]=='request_user_input_async'
  assert isinstance(question[1],str) and question[1] and type(question[2]) is int and question[2]>=0
  exact.append({'receipt':ref,'exact_receipt_bytes_utf8':raw.decode('utf-8'),'exact_fields':receipt});pins.append(ref)
 assert len({item['path'] for item in pins})==len(pins)
 packet={'format':'inherited-source-interpretation-evidence-1','source':extension['source'],
  'source_context_extension':reference,'primary_locations':extension['primary_locations'],
  'inherited_locations':extension['inherited_locations'],'interpretation_receipts':exact,
  'scope_rule':'The primary claim remains the original selection. Added locations supply explicitly identified inherited context. Preserve each exact user receipt and its original scope; independently assess whether and how that scope applies to the primary claim. Do not enlarge a user answer, attribute it to the printed source, or infer global solution extensions or pointwise representative conventions. The coordinator Q-choice is separately supplied with its different authority. No prior judgment or requested verdict is supplied.'}
 return {'locations':selected,'packet':packet,'pins':pins,'image_hashes':hashes,'pages_arg':pages_arg}


def bind_source_context_role(code, context):
 """Add exact receipt evidence only to judges, and pinned pages to source-facing roles."""
 needle=" locator=json.loads((out/'inputs/source_locator.json').read_text(encoding='utf-8'))"
 assert code.count(needle)==1
 code=code.replace(needle," assert pages_arg=="+repr(context['pages_arg'])+"\n pinned_source_images="+repr(context['image_hashes'])+"\n"+needle)
 needle=" if role in ('direct-judge','adjudicator'):"
 assert code.count(needle)==1
 extra="""  inherited=out.parent/'inherited-source-interpretation-packet.json'
  inherited_record=next(row for row in interpretation_manifest['lean_environment'] if row['path'].endswith('/'+task+'/inherited-source-interpretation-packet.json'))
  assert hashlib.sha256(inherited.read_bytes()).hexdigest()==inherited_record['sha256']
  add('Separate exact inherited user interpretation; retain original authority and scope and assess applicability independently',inherited)
  parts.append(b'\\nThis inherited receipt is distinct from the coordinator-selected convention. Its literal answer and scope must remain unchanged. Independently assess both implications under the applicable recorded conventions without importing prior judgments. Added source context does not add independently audited source rows.\\n')
"""
 code=code.replace(needle,extra+needle)
 needle="   assert image.is_file(),image\n   images.append(image)"
 assert code.count(needle)==1
 code=code.replace(needle,"   assert image.is_file(),image\n   assert hashlib.sha256(image.read_bytes()).hexdigest()==pinned_source_images[page]\n   images.append(image)")
 return code
