/// One entry of the career timeline.
class JobModel {
  const JobModel({
    required this.role,
    required this.start,
    this.end,
    this.company,
    this.highlights = const [],
    this.tools = const [],
  });

  final String role;

  /// Company or context of the role; omitted from the UI when null.
  final String? company;
  final DateTime start;

  /// Null while the role is ongoing.
  final DateTime? end;
  final List<String> highlights;
  final List<String> tools;

  bool get isCurrent => end == null;
}
