/// Personal details and links used across the site.
abstract final class Profile {
  static const name = 'Gino Alessandro Milla';
  static const initials = 'GM';

  static final Uri github = Uri.parse('https://github.com/ginuxone');

  // TODO(gino): add your LinkedIn profile URL; the link stays disabled until then.
  static const Uri? linkedIn = null;
}

/// Tags orbiting on the tech sphere.
const sphereTech = [
  'Flutter',
  'Dart',
  'Next.js',
  'React',
  'Angular',
  'Node.js',
  'C#',
  'SQL',
  'AWS',
  'Azure',
  'Docker',
  'Git',
];

enum SkillGroup { frontend, backend, cloud }

/// Grouped skill list next to the sphere (labels are localized by group).
const skillGroups = <SkillGroup, List<String>>{
  SkillGroup.frontend: [
    'Flutter',
    'Dart',
    'React',
    'Next.js',
    'Angular',
    'Vaadin',
  ],
  SkillGroup.backend: [
    'C#',
    'Node.js',
    'Java',
    'Python',
    'SQL',
    'PostgreSQL',
    'DynamoDB',
  ],
  SkillGroup.cloud: [
    'Azure',
    'AWS',
    'Firebase',
    'Google Cloud',
    'Docker',
    'Git',
  ],
};
