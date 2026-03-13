class SubjectModel {
  final String id;
  final String classId;
  final String name;
  final String teacherId;
  final double price;
  final String coverImage;

  SubjectModel({
    required this.id,
    required this.classId,
    required this.name,
    required this.teacherId,
    required this.price,
    required this.coverImage,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map, String id) {
    return SubjectModel(
      id: id,
      classId: map['classId'] ?? '',
      name: map['name'] ?? '',
      teacherId: map['teacherId'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      coverImage: map['coverImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'name': name,
      'teacherId': teacherId,
      'price': price,
      'coverImage': coverImage,
    };
  }
}

class VideoModel {
  final String id;
  final String subjectId;
  final String title;
  final String url;
  final bool isLive;
  final String liveLink;

  VideoModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.url,
    this.isLive = false,
    this.liveLink = '',
  });

  factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
    return VideoModel(
      id: id,
      subjectId: map['subjectId'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      isLive: map['isLive'] ?? false,
      liveLink: map['liveLink'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'title': title,
      'url': url,
      'isLive': isLive,
      'liveLink': liveLink,
    };
  }
}
