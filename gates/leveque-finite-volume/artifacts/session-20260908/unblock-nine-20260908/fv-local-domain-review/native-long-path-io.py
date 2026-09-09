def install_native_long_path_io():
 """Use extended Windows paths only at I/O; preserve all logical Path strings."""
 import io
 if getattr(Path,'_audit_extended_io_installed',False):return
 assert os.name=='nt'
 def native_path(path):
  value=os.path.abspath(os.fspath(path))
  if value.startswith('\\\\?\\'):return value
  if value.startswith('\\\\'):return '\\\\?\\UNC\\'+value[2:]
  return '\\\\?\\'+value
 def normal_path(value):
  if value.startswith('\\\\?\\UNC\\'):return '\\\\'+value[8:]
  if value.startswith('\\\\?\\'):return value[4:]
  return value
 def path_open(self,mode='r',buffering=-1,encoding=None,errors=None,newline=None):
  return io.open(native_path(self),mode,buffering,encoding,errors,newline)
 def path_stat(self,*,follow_symlinks=True):return os.stat(native_path(self),follow_symlinks=follow_symlinks)
 def path_mkdir(self,mode=0o777,parents=False,exist_ok=False):
  try:os.mkdir(native_path(self),mode)
  except FileNotFoundError:
   if not parents or self.parent==self:raise
   self.parent.mkdir(parents=True,exist_ok=True)
   self.mkdir(mode,parents=False,exist_ok=exist_ok)
  except OSError:
   if not exist_ok or not self.is_dir():raise
 def path_iterdir(self):
  for name in os.listdir(native_path(self)):yield self/name
 def path_resolve(self,strict=False):return type(self)(normal_path(os.path.realpath(native_path(self),strict=strict)))
 Path.open=path_open;Path.stat=path_stat;Path.mkdir=path_mkdir;Path.iterdir=path_iterdir;Path.resolve=path_resolve
 Path._audit_extended_io_installed=True

install_native_long_path_io()
