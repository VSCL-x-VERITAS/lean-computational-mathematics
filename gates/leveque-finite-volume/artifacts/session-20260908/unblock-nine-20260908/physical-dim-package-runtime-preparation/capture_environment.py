"""Return only compiler path variables from a real native Lake environment."""
import json
import os
import shutil
SAFE_ENV = ('PATH', 'LEAN_PATH', 'LEAN_SRC_PATH', 'LEAN_SYSROOT', 'LD_LIBRARY_PATH', 'DYLD_LIBRARY_PATH')
print(json.dumps({'environment': {key: os.environ[key] for key in SAFE_ENV if key in os.environ}, 'lean': shutil.which('lean')}))
