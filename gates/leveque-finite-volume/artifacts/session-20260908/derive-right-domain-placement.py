from pathlib import Path
S = Path(__file__).resolve().parent
source = (S / 'place-equation04-acoustic.py').read_text()
changes = {
    'Place the reviewed thin acoustic wrapper and connect its source aggregate.': 'Place the reviewed positive-ratio right-mode wrapper and connect its aggregate.',
    'equation04-acoustic-model/Equation04AcousticModel.lean': 'acoustics-algebraic-domain/AcousticsRightModeAlgebraic.lean',
    '05fe4d2f1cda9c311340c41e85830bc7a3873d99efc5d4261c5d754f58546843': '143afa75803d27917e2a1226f56b221bf367899e141e705cf3d3d0b742b06ba9',
    'equation04-acoustic-model/final-verification.json': 'acoustics-algebraic-domain/final-verification.json',
    'e593468c786170042743a7c65d131adc21750ef873ba6f0dba5f6db1e15f469e': '5b3b37888342d95f0ab13dfa13aba4d2dabe38511b83345153c74eb596804f5e',
    '46038487a021089cf26b3327ab5ee5610dfa4a76': 'b05cc4a1a2125ddaef745bc394fe2138dea236d9',
    'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean': 'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsRightModeAlgebraic.lean',
    'NumStability.leveque01_equation04_acousticOneWayModel': 'NumStability.leveque01_acousticsRightMode_of_pos_ratio',
    'equation04-acoustic-production': 'right-domain-production'
}
for old, new in changes.items():
    assert old in source, old
    source = source.replace(old, new)
path = S / 'place-right-domain.py'
assert not path.exists()
path.write_text(source, encoding='utf-8')
print(path)

