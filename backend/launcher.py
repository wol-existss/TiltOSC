import subprocess
import os
import sys

if getattr(sys, 'frozen', False):
    script_dir = os.path.dirname(sys.executable)
else:
    script_dir = os.path.dirname(os.path.abspath(__file__))

launcher_path = os.path.join(script_dir, "_internal", "LauncherApp.exe")

subprocess.Popen([launcher_path], cwd=os.path.join(script_dir, "_internal"))
os._exit(0)