#!/usr/bin/env sh
set -eu
command -v flutter >/dev/null 2>&1 || { echo 'Flutter SDK is not in PATH'; exit 1; }
flutter create --platforms=android --project-name=news_route --org=com.newsroute .
flutter pub get
flutter run "$@"
