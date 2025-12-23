class PropertyInquiry {
  final int id;
  final String propertyId;
  final String propertyTitle;
  final InquiryUser? user;
  final String inquiryType;
  final String inquiryTypeDisplay;
  final String? message;
  final String? preferredContactTime;
  final String? offeredPrice;
  final bool isResponded;
  final DateTime createdAt;
  final DateTime? responseDate;

  const PropertyInquiry({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    this.user,
    required this.inquiryType,
    required this.inquiryTypeDisplay,
    this.message,
    this.preferredContactTime,
    this.offeredPrice,
    required this.isResponded,
    required this.createdAt,
    this.responseDate,
  });

  factory PropertyInquiry.fromJson(Map<String, dynamic> json) {
    return PropertyInquiry(
      id: json['id'] ?? 0,
      propertyId: json['property']?.toString() ?? json['property_id']?.toString() ?? '',
      propertyTitle: json['property_title'] ?? '',
      user: json['user'] != null ? InquiryUser.fromJson(json['user']) : null,
      inquiryType: json['inquiry_type'] ?? '',
      inquiryTypeDisplay: json['inquiry_type_display'] ?? '',
      message: json['message'],
      preferredContactTime: json['preferred_contact_time'],
      offeredPrice: json['offered_price']?.toString(),
      isResponded: json['is_responded'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      responseDate: json['response_date'] != null
          ? DateTime.tryParse(json['response_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property': propertyId,
      'property_title': propertyTitle,
      'user': user?.toJson(),
      'inquiry_type': inquiryType,
      'inquiry_type_display': inquiryTypeDisplay,
      'message': message,
      'preferred_contact_time': preferredContactTime,
      'offered_price': offeredPrice,
      'is_responded': isResponded,
      'created_at': createdAt.toIso8601String(),
      'response_date': responseDate?.toIso8601String(),
    };
  }
}

class InquiryUser {
  final int id;
  final String username;
  final String phoneNumber;
  final String userType;

  const InquiryUser({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.userType,
  });

  factory InquiryUser.fromJson(Map<String, dynamic> json) {
    return InquiryUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userType: json['user_type'] ?? 'regular',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'user_type': userType,
    };
  }
}

class InquiryRequest {
  final String propertyId;
  final String inquiryType;
  final String? message;
  final String? preferredContactTime;
  final String? offeredPrice;

  const InquiryRequest({
    required this.propertyId,
    required this.inquiryType,
    this.message,
    this.preferredContactTime,
    this.offeredPrice,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'property': propertyId,
      'inquiry_type': inquiryType,
    };
    if (message != null && message!.isNotEmpty) {
      map['message'] = message;
    }
    if (preferredContactTime != null && preferredContactTime!.isNotEmpty) {
      map['preferred_contact_time'] = preferredContactTime;
    }
    if (offeredPrice != null && offeredPrice!.isNotEmpty) {
      map['offered_price'] = offeredPrice;
    }
    return map;
  }
}

// Inquiry Types
enum InquiryType {
  viewing('viewing', 'Schedule Viewing'),
  info('info', 'Request Information'),
  offer('offer', 'Make Offer'),
  callback('callback', 'Request Callback');

  final String value;
  final String displayName;

  const InquiryType(this.value, this.displayName);

  static InquiryType? fromString(String value) {
    try {
      return InquiryType.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }
}

