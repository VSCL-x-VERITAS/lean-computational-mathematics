import Lean
import SourceJoint
import CanonicalChecks
run_cmd do
  for moduleName in (← Lean.getEnv).header.moduleNames do
    let path ← Lean.findOLean moduleName
    liftIO <| IO.println s!"COMPILED_IMPORT {moduleName} {path}"
