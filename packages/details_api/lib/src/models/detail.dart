class Detail {
  Detail({
    this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.position,
  });

  final int? id;
  final String title;
  final String description;
  final int iconData;
  final int position;

  Detail copyWith({
    int? id,
    String? title,
    String? description,
    int? iconData,
    int? position,
  }) {
    return Detail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconData: iconData ?? this.iconData,
      position: position ?? this.position,
    );
  }
}
