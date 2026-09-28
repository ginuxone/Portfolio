import 'package:portfolio/models/job_model.dart';

// TODO(gino): highlights are drafted from each role's tech stack — rewrite
// them with your real achievements, and fill in the missing companies.

/// Career entries, most recent first.
final journey = <JobModel>[
  JobModel(
    role: 'Software Engineer',
    company: 'AntaresVision',
    start: DateTime(2025, 2),
    highlights: const [
      'Develop features across C# back-end services and React front-ends.',
      'Design PostgreSQL data models and run services on Azure.',
      'Plan and track delivery in Jira within an agile team.',
    ],
    tools: const ['Azure', 'C#', 'React', 'PostgreSQL', 'Jira'],
  ),
  JobModel(
    role: 'Software Engineer',
    company: 'Pharma & Fashion clients',
    start: DateTime(2024, 6),
    end: DateTime(2025, 1),
    highlights: const [
      'Built business applications for pharmaceutical and fashion clients.',
      'Developed Java web UIs with Vaadin on top of SQL databases.',
      'Containerised services with Docker for consistent environments.',
    ],
    tools: const ['Java', 'Docker', 'Vaadin', 'SQL'],
  ),
  JobModel(
    role: 'Software Engineer',
    company: 'Digital Twin platform',
    start: DateTime(2023, 8),
    end: DateTime(2024, 5),
    highlights: const [
      'Built the platform front-end in Next.js.',
      'Implemented serverless features with AWS Lambda and DynamoDB.',
      'Deployed and hosted the application with AWS Amplify.',
    ],
    tools: const ['Next.js', 'AWS Amplify', 'DynamoDB', 'Lambda'],
  ),
  JobModel(
    role: 'Software Engineer',
    company: 'IoT device management platform',
    start: DateTime(2022, 7),
    end: DateTime(2023, 8),
    highlights: const [
      'Built an Angular dashboard to monitor and manage connected devices.',
      'Integrated device messaging over MQTT with AWS IoT Core.',
      'Wrote Python services and tooling for device data.',
    ],
    tools: const ['AWS IoT Core', 'Angular', 'MQTT', 'Python'],
  ),
  JobModel(
    role: 'Software Developer',
    company: 'Startup mobile app',
    start: DateTime(2020, 3),
    end: DateTime(2022, 7),
    highlights: const [
      'Developed a cross-platform mobile app in Flutter.',
      'Integrated Firebase and Google Cloud services as the app back-end.',
    ],
    tools: const ['Flutter', 'Firebase', 'Google Cloud'],
  ),
  JobModel(
    role: 'Software Developer',
    start: DateTime(2016, 11),
    end: DateTime(2017, 6),
    highlights: const [
      'Built web application front-ends with Angular and Bootstrap.',
      'Deployed and hosted applications on IIS.',
    ],
    tools: const ['Angular', 'Bootstrap', 'IIS'],
  ),
  JobModel(
    role: 'Software Developer',
    start: DateTime(2015, 2),
    end: DateTime(2016, 11),
    highlights: const [
      'Developed Windows desktop applications in C# and WinForms.',
      'Designed and queried SQL Server databases.',
    ],
    tools: const ['C#', 'WinForms', 'SQL Server'],
  ),
];
