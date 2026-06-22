import 'enums.dart';

class AppUser {
  final String id;
  final String nickname;
  final String? email;
  final String? avatarUrl;
  final double heightCm;
  final double weightKg;
  final double? shoulderWidthCm;
  final double? waistCm;
  final double? hipCm;
  final double? inseamCm;
  final List<Style> preferredStyles;
  final List<ClothingColor> preferredColors;
  final List<ClothingColor> avoidColors;
  final String? cityName;
  final String? faceImageUrl;
  final DateTime createdAt;

  AppUser({
    required this.id,
    this.nickname = '',
    this.email,
    this.avatarUrl,
    this.heightCm = 170,
    this.weightKg = 65,
    this.shoulderWidthCm,
    this.waistCm,
    this.hipCm,
    this.inseamCm,
    this.preferredStyles = const [],
    this.preferredColors = const [],
    this.avoidColors = const [],
    this.cityName,
    this.faceImageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'email': email,
        'avatar_url': avatarUrl,
        'height_cm': heightCm,
        'weight_kg': weightKg,
        'shoulder_width_cm': shoulderWidthCm,
        'waist_cm': waistCm,
        'hip_cm': hipCm,
        'inseam_cm': inseamCm,
        'preferred_styles': preferredStyles.map((e) => e.name).toList(),
        'preferred_colors': preferredColors.map((e) => e.name).toList(),
        'avoid_colors': avoidColors.map((e) => e.name).toList(),
        'city_name': cityName,
        'face_image_url': faceImageUrl,
        'created_at': createdAt.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] ?? '',
        nickname: json['nickname'] ?? '',
        email: json['email'],
        avatarUrl: json['avatar_url'],
        heightCm: (json['height_cm'] ?? 170).toDouble(),
        weightKg: (json['weight_kg'] ?? 65).toDouble(),
        shoulderWidthCm: (json['shoulder_width_cm'] as num?)?.toDouble(),
        waistCm: (json['waist_cm'] as num?)?.toDouble(),
        hipCm: (json['hip_cm'] as num?)?.toDouble(),
        inseamCm: (json['inseam_cm'] as num?)?.toDouble(),
        preferredStyles: (json['preferred_styles'] as List<dynamic>?)
                ?.map((e) => Style.values.firstWhere(
                      (s) => s.name == e,
                      orElse: () => Style.minimalist,
                    ))
                .toList() ??
            [],
        preferredColors: (json['preferred_colors'] as List<dynamic>?)
                ?.map((e) => ClothingColor.values.firstWhere(
                      (c) => c.name == e,
                      orElse: () => ClothingColor.white,
                    ))
                .toList() ??
            [],
        avoidColors: (json['avoid_colors'] as List<dynamic>?)
                ?.map((e) => ClothingColor.values.firstWhere(
                      (c) => c.name == e,
                      orElse: () => ClothingColor.white,
                    ))
                .toList() ??
            [],
        cityName: json['city_name'],
        faceImageUrl: json['face_image_url'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
      );
}
