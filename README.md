# Portfolio

Personal portfolio website of Gino Alessandro Milla, built with Flutter for the web.

## Features

Dark, compact **Nocturne** design (Inter, blurple accent) in a single page:

- **Hero**: particle field forming the "GM" initials (spring physics, reacts to the pointer)
- **Tech Stack**: auto-rotating 3D tag sphere (drag to spin) + grouped skills
- **Projects**: glassmorphism cards linking to client sites
- **Journey**: scrubbable career timeline
- **Contact**: validated form with confirmation (no backend yet)
- Localized in English, Spanish and Italian (`lib/l10n/*.arb`)
- Keyboard focus ring on every interactive element; animations pause
  off-screen and respect the OS "reduce motion" setting

## Project structure

```
lib/
  main.dart         App entry point (theme + localization setup)
  theme/            Design tokens (tokens.dart) and ThemeData
  screens/          HomeScreen: scroll view, sticky nav, section anchors
  sections/         Hero, Tech Stack, Projects, Journey, Contact, Footer
  widgets/          Particle hero, tech sphere, glass card, timeline, buttons...
  models/           JobModel, ProjectModel
  data/             Site content: profile/links, projects, journey entries
  l10n/             Translation files (.arb)
web/                Web entry point (index.html, icons, manifest)
fonts/              Bundled Inter font (OFL)
```

## Editing content

- Career entries: `lib/data/journey.dart`
- Projects (add screenshots via `imageAsset`): `lib/data/projects.dart`
- Links, sphere tags and skill groups: `lib/data/profile.dart`
- UI text: `lib/l10n/app_*.arb`

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
