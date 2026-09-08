"""Generate a current-tree declaration-expression export for candidate inventory."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];base='9e2225705fed906b1120d55105d607baabef57c9'
read=lambda p:json.loads(p.read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
added=subprocess.check_output(['git','-c','core.longpaths=true','diff','--name-only','--diff-filter=A',base,'HEAD','--','ComputationalMathematics'],cwd=R).decode().splitlines()
assert len(added)==55 and all(x.endswith('.lean') for x in added)
paths=set(added)
for row in read(R/'gates/leveque-finite-volume/chapter-01.json')['rows']:
 if row.get('faithfulness_task'):
  paths.add(read(R/row['faithfulness_task'])['target']['path'])
modules=sorted(path[:-5].replace('/','.') for path in paths)
lean='''/- Evidence program only: inspect compiled declaration expressions, never prove a source claim.
The type/proof representation removes metadata and bound-variable display names.
It is an alpha-canonical structural serialization, not full definitional normalization.
Compiler-generated declarations are filtered using the existing architecture convention. -/
import ComputationalMathematics
import NumStability
import Lean

open Lean Lean.Elab.Command

namespace Chapter01ExpressionEvidence

private def generated : Name → Bool
  | .anonymous => false
  | .num _ _ => true
  | .str parent part =>
      part.startsWith "_" ||
      (part.startsWith "match_" && (Name.mkSimple part).isInternalDetail) ||
      generated parent

private def canonicalExpression : Expr → Expr
  | .mdata _ body => canonicalExpression body
  | .app fn arg => .app (canonicalExpression fn) (canonicalExpression arg)
  | .lam _ type body info => .lam .anonymous (canonicalExpression type) (canonicalExpression body) info
  | .forallE _ type body info => .forallE .anonymous (canonicalExpression type) (canonicalExpression body) info
  | .letE _ type value body nondep =>
      .letE .anonymous (canonicalExpression type) (canonicalExpression value) (canonicalExpression body) nondep
  | .proj typeName idx expr => .proj typeName idx (canonicalExpression expr)
  | expr => expr

private def kind : ConstantInfo → String
  | .axiomInfo _ => "axiom"
  | .defnInfo _ => "definition"
  | .thmInfo _ => "theorem"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quotient"
  | .inductInfo _ => "inductive"
  | .ctorInfo _ => "constructor"
  | .recInfo _ => "recursor"

private def selectedModules : Array String := #[
MODULES
]

run_cmd do
  let env ← getEnv
  let mut records : Array (String × Json) := #[]
  for h : idx in *...env.header.moduleData.size do
    let moduleName := env.header.moduleNames[idx]!
    if selectedModules.contains moduleName.toString then
      let data := env.header.moduleData[idx]
      for name in data.constNames, info in data.constants do
        if env.getModuleIdxFor? name == some idx &&
            !isReservedName env name && !generated (privateToUserName name) then
          let body := match info.value? true with
            | some value => Json.str (reprStr (canonicalExpression value))
            | none => Json.null
          let recursorBodies := match info with
            | .recInfo value => value.rules.map fun rule =>
                Json.str (reprStr (canonicalExpression rule.rhs))
            | _ => []
          let record := Json.mkObj [
            ("name", Json.str name.toString), ("module", Json.str moduleName.toString),
            ("kind", Json.str (kind info)),
            ("level_params", toJson (info.levelParams.map Name.toString)),
            ("type", Json.str (reprStr (canonicalExpression info.type))),
            ("value", body), ("recursor_values", toJson recursorBodies)]
          records := records.push (name.toString, record)
  records := records.qsort fun a b => a.1 < b.1
  let text := String.intercalate "\\n" (records.toList.map fun record => record.2.compress) ++ "\\n"
  liftIO <| IO.FS.writeFile ".lake/chapter01-declaration-expressions.jsonl" text
  liftIO <| IO.println s!"Chapter 1 declaration expressions exported: {records.size}"

end Chapter01ExpressionEvidence
'''.replace('MODULES',',\n'.join('  '+json.dumps(x) for x in modules))
dest=S/'export-chapter01-declaration-expressions.lean';assert not dest.exists()
dest.write_text(lean,encoding='utf-8')
manifest={'schema':1,'added_production_modules':added,'selected_modules':modules,'files':[{'path':path,'sha256':sha(R/path)} for path in sorted(paths)],'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R).decode().strip(),'exporter_path':dest.relative_to(R).as_posix(),'exporter_sha256':sha(dest),'normalization':'Structural alpha-canonical expression: erase metadata and binder display names; preserve de Bruijn indices, universe levels, constants, binder kinds and expression shape. No definitional-equality or cross-version reuse claim.'}
out=S/'chapter01-expression-export-inputs.json';assert not out.exists();out.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'exporter':dest.relative_to(R).as_posix(),'modules':len(modules),'new_modules':len(added),'manifest_sha256':sha(out)}))

