// lib/features/wrapper/data/models/about_model.dart
class AboutModel {
  final int id;
  final String aboutTitleAr;
  final String aboutTitleEn;
  final String aboutTitleHighlightAr;
  final String aboutTitleHighlightEn;
  final String aboutSubtitleAr;
  final String aboutSubtitleEn;
  final String aboutDescTitleAr;
  final String aboutDescTitleEn;
  final String aboutDescTextAr;
  final String aboutDescTextEn;
  final String aboutImageUrl;
  final String aboutImageRoleAr;
  final String aboutImageRoleEn;
  final String aboutImageNameAr;
  final String aboutImageNameEn;
  final String aboutBirthInfoAr;
  final String aboutBirthInfoEn;
  final String aboutMethodLabelAr;
  final String aboutMethodLabelEn;
  final String aboutMethodValueAr;
  final String aboutMethodValueEn;
  final String aboutActivityLabelAr;
  final String aboutActivityLabelEn;
  final String aboutActivityValueAr;
  final String aboutActivityValueEn;
  final String aboutMetricTitleAr;
  final String aboutMetricTitleEn;
  final String aboutMetricSubtitleAr;
  final String aboutMetricSubtitleEn;
  final List<PillarModel> pillarsAr;
  final List<PillarModel> pillarsEn;
  final List<SocialLinkModel> socialLinks;

  AboutModel({
    required this.id,
    required this.aboutTitleAr,
    required this.aboutTitleEn,
    required this.aboutTitleHighlightAr,
    required this.aboutTitleHighlightEn,
    required this.aboutSubtitleAr,
    required this.aboutSubtitleEn,
    required this.aboutDescTitleAr,
    required this.aboutDescTitleEn,
    required this.aboutDescTextAr,
    required this.aboutDescTextEn,
    required this.aboutImageUrl,
    required this.aboutImageRoleAr,
    required this.aboutImageRoleEn,
    required this.aboutImageNameAr,
    required this.aboutImageNameEn,
    required this.aboutBirthInfoAr,
    required this.aboutBirthInfoEn,
    required this.aboutMethodLabelAr,
    required this.aboutMethodLabelEn,
    required this.aboutMethodValueAr,
    required this.aboutMethodValueEn,
    required this.aboutActivityLabelAr,
    required this.aboutActivityLabelEn,
    required this.aboutActivityValueAr,
    required this.aboutActivityValueEn,
    required this.aboutMetricTitleAr,
    required this.aboutMetricTitleEn,
    required this.aboutMetricSubtitleAr,
    required this.aboutMetricSubtitleEn,
    required this.pillarsAr,
    required this.pillarsEn,
    required this.socialLinks,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      id: json['id'] ?? 1,
      aboutTitleAr: json['about_title_ar'] ?? '',
      aboutTitleEn: json['about_title_en'] ?? '',
      aboutTitleHighlightAr: json['about_title_highlight_ar'] ?? '',
      aboutTitleHighlightEn: json['about_title_highlight_en'] ?? '',
      aboutSubtitleAr: json['about_subtitle_ar'] ?? '',
      aboutSubtitleEn: json['about_subtitle_en'] ?? '',
      aboutDescTitleAr: json['about_desc_title_ar'] ?? '',
      aboutDescTitleEn: json['about_desc_title_en'] ?? '',
      aboutDescTextAr: json['about_desc_text_ar'] ?? '',
      aboutDescTextEn: json['about_desc_text_en'] ?? '',
      aboutImageUrl: json['about_image_url'] ?? '',
      aboutImageRoleAr: json['about_image_role_ar'] ?? '',
      aboutImageRoleEn: json['about_image_role_en'] ?? '',
      aboutImageNameAr: json['about_image_name_ar'] ?? '',
      aboutImageNameEn: json['about_image_name_en'] ?? '',
      aboutBirthInfoAr: json['about_birth_info_ar'] ?? '',
      aboutBirthInfoEn: json['about_birth_info_en'] ?? '',
      aboutMethodLabelAr: json['about_method_label_ar'] ?? '',
      aboutMethodLabelEn: json['about_method_label_en'] ?? '',
      aboutMethodValueAr: json['about_method_value_ar'] ?? '',
      aboutMethodValueEn: json['about_method_value_en'] ?? '',
      aboutActivityLabelAr: json['about_activity_label_ar'] ?? '',
      aboutActivityLabelEn: json['about_activity_label_en'] ?? '',
      aboutActivityValueAr: json['about_activity_value_ar'] ?? '',
      aboutActivityValueEn: json['about_activity_value_en'] ?? '',
      aboutMetricTitleAr: json['about_metric_title_ar'] ?? '',
      aboutMetricTitleEn: json['about_metric_title_en'] ?? '',
      aboutMetricSubtitleAr: json['about_metric_subtitle_ar'] ?? '',
      aboutMetricSubtitleEn: json['about_metric_subtitle_en'] ?? '',
      pillarsAr:
          (json['about_pillars_ar'] as List<dynamic>?)
              ?.map((e) => PillarModel.fromJson(e))
              .toList() ??
          [],
      pillarsEn:
          (json['about_pillars_en'] as List<dynamic>?)
              ?.map((e) => PillarModel.fromJson(e))
              .toList() ??
          [],
      socialLinks:
          (json['social_links'] as List<dynamic>?)
              ?.map((e) => SocialLinkModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  String getAboutTitle(bool isAr) => isAr ? aboutTitleAr : aboutTitleEn;
  String getAboutTitleHighlight(bool isAr) =>
      isAr ? aboutTitleHighlightAr : aboutTitleHighlightEn;
  String getAboutSubtitle(bool isAr) =>
      isAr ? aboutSubtitleAr : aboutSubtitleEn;
  String getAboutDescTitle(bool isAr) =>
      isAr ? aboutDescTitleAr : aboutDescTitleEn;
  String getAboutDescText(bool isAr) =>
      isAr ? aboutDescTextAr : aboutDescTextEn;
  String getAboutImageRole(bool isAr) =>
      isAr ? aboutImageRoleAr : aboutImageRoleEn;
  String getAboutImageName(bool isAr) =>
      isAr ? aboutImageNameAr : aboutImageNameEn;
  String getAboutBirthInfo(bool isAr) =>
      isAr ? aboutBirthInfoAr : aboutBirthInfoEn;
  String getAboutMethodLabel(bool isAr) =>
      isAr ? aboutMethodLabelAr : aboutMethodLabelEn;
  String getAboutMethodValue(bool isAr) =>
      isAr ? aboutMethodValueAr : aboutMethodValueEn;
  String getAboutActivityLabel(bool isAr) =>
      isAr ? aboutActivityLabelAr : aboutActivityLabelEn;
  String getAboutActivityValue(bool isAr) =>
      isAr ? aboutActivityValueAr : aboutActivityValueEn;
  String getAboutMetricTitle(bool isAr) =>
      isAr ? aboutMetricTitleAr : aboutMetricTitleEn;
  String getAboutMetricSubtitle(bool isAr) =>
      isAr ? aboutMetricSubtitleAr : aboutMetricSubtitleEn;
  List<PillarModel> getPillars(bool isAr) => isAr ? pillarsAr : pillarsEn;
}

class PillarModel {
  final String label;
  final String desc;
  final String icon;

  PillarModel({required this.label, required this.desc, required this.icon});

  factory PillarModel.fromJson(Map<String, dynamic> json) {
    return PillarModel(
      label: json['label'] ?? '',
      desc: json['desc'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class SocialLinkModel {
  final String platform;
  final String url;
  final bool showInHeader;
  final bool showInFooter;
  final bool showInMobile;

  SocialLinkModel({
    required this.platform,
    required this.url,
    this.showInHeader = true,
    this.showInFooter = true,
    this.showInMobile = true,
  });

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      showInHeader: json['show_in_header'] ?? true,
      showInFooter: json['show_in_footer'] ?? true,
      showInMobile: json['show_in_mobile'] ?? true,
    );
  }
}
