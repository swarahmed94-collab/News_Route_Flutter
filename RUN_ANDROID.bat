@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found in PATH. Install Flutter SDK and open a new terminal.
  exit /b 1
)
flutter create --platforms=android --project-name=news_route --org=com.newsroute .
if errorlevel 1 exit /b 1
flutter pub get
if errorlevel 1 exit /b 1
flutter run %*
