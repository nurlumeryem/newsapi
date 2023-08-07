import 'article.dart';

class News {
  String? status;
  int? totalResults;
  List<Articles>? articles;

  News({
    this.status,
    this.totalResults,
    this.articles,
    String? title,
    String? description,
    String? urlToImage,
  });

  News copyWith({
    String? status,
    int? totalResults,
    List<Articles>? articles,
  }) {
    return News(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles,
    };
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: (json['articles'] as List<dynamic>?)
          ?.map((e) => Articles.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      "News(status: $status,totalResults: $totalResults,articles: $articles)";

  @override
  int get hashCode => Object.hash(status, totalResults, articles);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          totalResults == other.totalResults &&
          articles == other.articles;
}
