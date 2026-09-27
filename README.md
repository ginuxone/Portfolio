# Portfolio

Personal portfolio website of Gino Alessandro Milla, built with Flutter for the web.

## Features

- Light and dark theme, following the system setting
- Localized in English, Spanish and Italian (`lib/l10n/*.arb`)
- Oswald font

## Project structure

```
lib/
  main.dart         App entry point (theme + localization setup)
  pages/            Pages of the site
  components/       Reusable widgets (header, tabs, ...)
  models/           Data models (e.g. JobModel)
  themes/           Colors and light/dark ThemeData
  l10n/             Translation files (.arb)
web/                Web entry point (index.html, icons, manifest)
fonts/              Bundled fonts
```

## Development

Requires Flutter 3.35+ (Dart 3.9+).

```sh
flutter pub get          # also generates localizations
flutter run -d chrome    # run locally
flutter analyze          # lint
flutter test             # tests
flutter build web        # production build in build/web
```

To add a string, add it to `lib/l10n/app_en.arb` (with an `@key` description) and translate it in `app_es.arb` and `app_it.arb`.
