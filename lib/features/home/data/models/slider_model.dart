class SliderModel {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String img;
  final String imgMobile;
  final String linkUrl;

  SliderModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.img,
    required this.imgMobile,
    required this.linkUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      img: json['img'] ?? '',
      imgMobile: json['img_mobile'] ?? '',
      linkUrl: json['link_url'] ?? '',
    );
  }
}
