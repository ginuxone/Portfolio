import 'package:portfolio/models/project_model.dart';

// TODO(gino): the tags below describe the kind of work; replace them with the
// actual tech used for each site, and add screenshots via `imageAsset`.
final projects = <ProjectModel>[
  ProjectModel(
    title: 'Hostaria Germoglio',
    url: Uri.parse('https://www.hostariagermoglio.it'),
    description:
        'Website for a family-run restaurant in Verdello that blends Bergamo '
        'tradition with Peruvian cuisine: menu, story and contacts.',
    tags: const ['Web design', 'Responsive', 'Multilingual'],
  ),
  ProjectModel(
    title: 'Fondazione Bosis',
    url: Uri.parse('https://www.fondazionebosis.it'),
    description:
        'Site for a Bergamo non-profit foundation offering mental-health care '
        'and rehabilitation through art, culture and nature.',
    tags: const ['WordPress', 'Web design', 'Responsive'],
  ),
  ProjectModel(
    title: 'Cascina Ronchi',
    url: Uri.parse('https://www.cascinaronchi.it'),
    description:
        'Agriturismo in the hills of Val San Martino: guest rooms, '
        'farm-to-table restaurant and wines from its own vineyards.',
    tags: const ['Web design', 'Responsive', 'Hospitality'],
  ),
  ProjectModel(
    title: 'Chiara Gambirasio',
    url: Uri.parse('https://www.chiaragambirasio.com'),
    description:
        'Portfolio for a Bergamo-born visual artist, showcasing her painting, '
        'sculpture and land-art works.',
    tags: const ['Portfolio', 'Web design', 'Responsive'],
  ),
];
