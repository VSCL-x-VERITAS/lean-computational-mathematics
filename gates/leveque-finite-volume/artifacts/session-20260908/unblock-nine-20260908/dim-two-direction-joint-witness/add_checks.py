from pathlib import Path
import hashlib,json,re
h=Path(__file__).resolve().parent
groups={
 'abbrev':'Direction State Position Cell',
 'def':'active position cellAt axes physical coord families method initial reference amplification direction full_application joint_applicability',
 'theorem':'mem_active active_nonempty cell_index_bounds identity_hyperbolic axis_volume physical_volume physical_area quality cartesian initial_nonconstant mean_zero flux_zero reference_valid initial_error admitted extracted_zero rule_zero face_error_zero schedule active_count advance_shift extract_at extract_outside advance_x_predecessor advance_x_origin advance_y_predecessor advance_y_bottom initial_origin first_stage_moves second_stage_moves step_duration physical_flux_identity numerical_flux_value numerical_flux_nonzero'
}
records=[{'name':'DIMTwoDirectionJointWitness.'+name,'kind':kind} for kind,names in groups.items() for name in names.split()]
source=h/'Candidate.lean';raw=source.read_text(encoding='utf-8')
authored=set(re.findall(r'^(?:noncomputable )?(?:def|abbrev|theorem) (\w+)',raw,re.M))
assert authored=={x['name'].split('.')[-1] for x in records}
body=raw.split('\n#check DIMTwoDirectionJointWitness.full_application',1)[0]
checks='\nset_option pp.deepTerms true\nset_option pp.maxSteps 1000000\n\n'+''.join('#check '+x['name']+'\n#print axioms '+x['name']+'\n' for x in records)
for p in [h/'declarations.json',h/'Checks.lean.fragment']:
 if p.exists():raise SystemExit('Refusing overwrite')
(h/'declarations.json').write_text(json.dumps({'declarations':records,'count':len(records),'classification':'Explicit authored name inventory; generated declarations excluded.'},indent=2)+'\n',encoding='utf-8')
(h/'Checks.lean.fragment').write_text(checks,encoding='utf-8')
source.write_text(body+checks,encoding='utf-8')
print(len(records),hashlib.sha256(source.read_bytes()).hexdigest())
