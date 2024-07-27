class PagedResult<T> {
  List<T> items;
  bool hasNextPage;

  PagedResult({required this.items, required this.hasNextPage});

  factory PagedResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PagedResult(
      items: (json['items'] as List).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
      hasNextPage: json['hasNextPage'],
    );
  }
}