/// A portfolio project card.
class ProjectModel {
  const ProjectModel({
    required this.title,
    required this.url,
    required this.description,
    required this.tags,
    this.imageAsset,
  });

  final String title;
  final Uri url;
  final String description;
  final List<String> tags;

  /// Screenshot asset; a generated preview is shown while this is null.
  final String? imageAsset;

  /// Bare domain shown on the card, e.g. `cascinaronchi.it`.
  String get domain => url.host.replaceFirst('www.', '');
}
