(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/build_windows.bat b/build_windows.bat
new file mode 100644
index 0000000000000000000000000000000000000000..4ccb8bfe41db90872d34587c3bda6e159da6c6bd
--- /dev/null
+++ b/build_windows.bat
@@ -0,0 +1,47 @@
+@echo off
+setlocal
+
+REM Build Windows EXE and optionally MSI-like installer (Inno Setup .exe installer)
+
+set "PY_CMD="
+where py >nul 2>nul
+if not errorlevel 1 set "PY_CMD=py"
+if not defined PY_CMD (
+  where python >nul 2>nul
+  if not errorlevel 1 set "PY_CMD=python"
+)
+if not defined PY_CMD (
+  echo [ERROR] Python executable was not found ^(neither "py" nor "python"^).
+  exit /b 1
+)
+
+echo [INFO] Using Python command: %PY_CMD%
+%PY_CMD% -m pip install --upgrade pip pyinstaller
+if errorlevel 1 (
+  echo [ERROR] Failed to install PyInstaller.
+  exit /b 1
+)
+
+%PY_CMD% -m PyInstaller --noconfirm --clean --windowed --onefile --name NeonCounter counter_overlay.py
+if errorlevel 1 (
+  echo [ERROR] Failed to build executable.
+  exit /b 1
+)
+
+echo [OK] EXE built: dist\NeonCounter.exe
+
+where ISCC >nul 2>nul
+if errorlevel 1 (
+  echo [WARN] Inno Setup Compiler ^("ISCC"^) not found.
+  echo [WARN] Install Inno Setup and rerun this script to build installer.
+  exit /b 0
+)
+
+ISCC installer\NeonCounter.iss
+if errorlevel 1 (
+  echo [ERROR] Failed to build installer with Inno Setup.
+  exit /b 1
+)
+
+echo [OK] Installer built in installer\output\
+exit /b 0
 
EOF
)
