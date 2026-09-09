"""Synthetic transport/guard checks. No role, released command or real audit mutation."""
from pathlib import Path
import copy,importlib.util,json,tempfile,unittest
D=Path(__file__).resolve().parent
def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
r=load('recovery_v3',D/'recovery-v3.py')
base=load('recovery_v2_tests',D.parent/'adjudicator-transport-recovery/test_recovery_v2.py')
base.r=r;base.F=D/'synthetic-fixtures';base.F.mkdir(exist_ok=True)

class GuardTests(base.GuardTests):
    def test_exact_reconstruction_and_verbatim_json(self):
        # Override only the obsolete V2 requirement to preserve JSON whitespace.
        prompt,records=self.setup_documents();compact,mapping=r.deduplicate(prompt,records)
        self.assertEqual(r.reconstruct(compact,mapping,records),prompt)
        self.assertIn(Path(records[1]['path']).read_bytes(),compact)
        self.assertIn(Path(records[2]['path']).read_bytes(),compact)
        self.assertIn(r.compact_json(Path(records[-1]['path']).read_bytes()),compact)

    def repeated_documents(self):
        directory=Path(tempfile.mkdtemp(prefix='shared-',dir=base.F))
        a=('First exact mathematical line ∀ q : ℝ, q = q. '+'x'*190+'\n').encode()
        b=('Second exact mathematical line ∃ q : ℝ, q = 0. '+'y'*210+'\n').encode()
        data={'direct_review_packet.md':b'# Exact packet\n'+a+b,
            'declaration_dossier.md':b'# Exact packet\n'+a+b+b'# Canonical extra only\n',
            'blind_dossier.md':b'# Unique anonymous title\n'+a+b'Unique middle\n'+b+b'Unique ending\n',
            'evidence.json':b'{\n "literal": " \\n \\\" \\\\ \\u0041", "number": 1.00e+01, "truth": true\n}\n'}
        records=[];prompt=b'Original unmodified framing.\n'
        for name,raw in data.items():
            path=directory/name;path.write_bytes(raw)
            item={'path':str(path),'label':name,'sha256':r.digest(raw),'bytes':len(raw)}
            records.append(item);prompt+=r.document_header(item)+raw
        return prompt,records

    def test_shared_unicode_lines_retained_and_reconstructible(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        self.assertGreaterEqual(mapping['blind_reference_count'],2)
        self.assertEqual(r.reconstruct(compact,mapping,records),prompt)
        self.assertIn(b'Unique middle\n',compact);self.assertIn(b'Unique ending\n',compact)
        self.assertIn(Path(records[1]['path']).read_bytes(),compact)

    def test_json_only_outside_whitespace_removed(self):
        raw=b' { "a" : " x \\n \\\" \\\\ \\u0041 ", "n": 1.00e+01 } \n'
        small=r.compact_json(raw)
        self.assertEqual(small,b'{"a":" x \\n \\\" \\\\ \\u0041 ","n":1.00e+01}')
        self.assertEqual(r.decode(small),r.decode(raw))

    def test_reference_hash_change_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        blind=next(x for x in mapping['transformed_documents'] if 'spans' in x)
        blind['spans'][0]['sha256']='0'*64
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_reference_range_change_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        blind=next(x for x in mapping['transformed_documents'] if 'spans' in x)
        blind['spans'][0]['canonical_start_byte']+=1
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_missing_reference_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        blind=next(x for x in mapping['transformed_documents'] if 'spans' in x)
        compact=compact.replace(blind['spans'][0]['marker_utf8'].encode(),b'')
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_unique_markdown_loss_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        compact=compact.replace(b'Unique ending',b'Wrong  ending')
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_json_value_change_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        compact=compact.replace(b'1.00e+01',b'2.00e+01')
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_canonical_document_loss_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        compact=compact.replace(b'# Canonical extra only',b'# Altered   extra only')
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

    def test_reserved_marker_collision_rejected(self):
        prompt,records=self.repeated_documents()
        with self.assertRaises(AssertionError):r.deduplicate(b'[INTERNAL DD 0:10]\n'+prompt,records)

    def test_duplicate_input_name_rejected(self):
        prompt,records=self.repeated_documents()
        with self.assertRaises(AssertionError):r.deduplicate(prompt,records+[records[0]])

    def test_prompt_prefix_tamper_rejected(self):
        prompt,records=self.repeated_documents();compact,mapping=r.deduplicate(prompt,records)
        compact=compact.replace(b'Original unmodified',b'MODIFIED unmodified')
        with self.assertRaises(AssertionError):r.reconstruct(compact,mapping,records)

if __name__=='__main__':unittest.main(verbosity=2)
