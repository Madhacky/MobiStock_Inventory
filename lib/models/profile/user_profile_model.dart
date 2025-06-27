// models/profile_response.dart
class ProfileResponse {
  final String status;
  final String message;
  final UserProfile payload;
  final int statusCode;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: UserProfile.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class UserProfile {
  final int id;
  final String shopId;
  final String shopStoreName;
  final String email;
  final String? password;
  final List<int>? passwordUpdatedAt;
  final ShopAddress? shopAddress;
  final List<SocialMediaLink> socialMediaLinks;
  final List<ShopImage> images;
  final int status;
  final List<int>? creationDate;
  final String? gstnumber;
  final String? adhaarNumer;

  UserProfile({
    required this.id,
    required this.shopId,
    required this.shopStoreName,
    required this.email,
    this.password,
    this.passwordUpdatedAt,
    this.shopAddress,
    required this.socialMediaLinks,
    required this.images,
    required this.status,
    this.creationDate,
    this.gstnumber,
    this.adhaarNumer,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? '',
      shopStoreName: json['shopStoreName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      passwordUpdatedAt: json['passwordUpdatedAt'] != null 
          ? List<int>.from(json['passwordUpdatedAt']) 
          : null,
      shopAddress: json['shopAddress'] != null 
          ? ShopAddress.fromJson(json['shopAddress']) 
          : null,
      socialMediaLinks: json['socialMediaLinks'] != null
          ? (json['socialMediaLinks'] as List)
              .map((item) => SocialMediaLink.fromJson(item))
              .toList()
          : [],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => ShopImage.fromJson(item))
              .toList()
          : [],
      status: json['status'] ?? json['Status'] ?? 0,
      creationDate: json['creationDate'] != null 
          ? List<int>.from(json['creationDate']) 
          : null,
      gstnumber: json['gstnumber'],
      adhaarNumer: json['adhaarNumer'],
    );
  }
}

class ShopAddress {
  final int id;
  final String label;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final bool defaultAddress;

  ShopAddress({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.defaultAddress,
  });

  factory ShopAddress.fromJson(Map<String, dynamic> json) {
    return ShopAddress(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
      defaultAddress: json['default'] ?? false,
    );
  }
}

class SocialMediaLink {
  final int id;
  final String platform;
  final String url;

  SocialMediaLink({
    required this.id,
    required this.platform,
    required this.url,
  });

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) {
    return SocialMediaLink(
      id: json['id'] ?? 0,
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class ShopImage {
  final int id;
  final String imageUrl;

  ShopImage({
    required this.id,
    required this.imageUrl,
  });

  factory ShopImage.fromJson(Map<String, dynamic> json) {
    return ShopImage(
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}