from pathlib import Path
G=Path(__file__).resolve().parent
t=(G/'Comparisons.lean').read_text()
old='''    let text := name.toString
    let exact := pairs.find? (fun p => p.1 == name)
    match exact with
    | some p => p.2
    | none => name'''
new='''    let exact := pairs.find? (fun p => p.1 == name)
    match exact with
    | some p => p.2
    | none =>
      match pairs.find? (fun p => p.1.isPrefixOf name) with
      | some p => name.replacePrefix p.1 p.2
      | none => name'''
assert old in t
t=t.replace(old,new)
(G/'Comparisons02.lean').write_text(t,encoding='utf-8',newline='\n')
