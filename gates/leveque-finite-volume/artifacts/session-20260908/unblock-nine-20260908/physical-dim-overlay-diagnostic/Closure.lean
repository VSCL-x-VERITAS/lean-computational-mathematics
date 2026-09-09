import Lean

open Lean

unsafe def main (args : List String) : IO UInt32 := do
  let [name] := args | throw <| IO.userError "Expected one module name"
  initSearchPath (← findSysroot)
  withImportModules #[{ module := name.toName }] {} fun env => do
    let mut records := #[]
    for moduleName in env.header.moduleNames do
      let file ← findOLean moduleName
      records := records.push <| Json.mkObj [
        ("module", toJson moduleName.toString), ("olean", toJson file.toString)]
    IO.println (Json.arr records).compress
    return 0
