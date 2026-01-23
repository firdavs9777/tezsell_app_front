/// Report Model for reporting inappropriate content or users

enum ReportContentType {
  product,
  service,
  message,
  user;

  static ReportContentType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'service':
        return ReportContentType.service;
      case 'message':
        return ReportContentType.message;
      case 'user':
        return ReportContentType.user;
      default:
        return ReportContentType.product;
    }
  }

  String get displayName {
    switch (this) {
      case ReportContentType.product:
        return 'Product Listing';
      case ReportContentType.service:
        return 'Service Listing';
      case ReportContentType.message:
        return 'Chat Message';
      case ReportContentType.user:
        return 'User Profile';
    }
  }
}

enum ReportReason {
  spam,
  inappropriate,
  fraud,
  harassment,
  illegal,
  other;

  static ReportReason fromString(String reason) {
    switch (reason.toLowerCase()) {
      case 'inappropriate':
        return ReportReason.inappropriate;
      case 'fraud':
        return ReportReason.fraud;
      case 'harassment':
        return ReportReason.harassment;
      case 'illegal':
        return ReportReason.illegal;
      case 'other':
        return ReportReason.other;
      default:
        return ReportReason.spam;
    }
  }

  String get displayName {
    switch (this) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.inappropriate:
        return 'Inappropriate Content';
      case ReportReason.fraud:
        return 'Fraud or Scam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.illegal:
        return 'Illegal Activity';
      case ReportReason.other:
        return 'Other';
    }
  }

  String get description {
    switch (this) {
      case ReportReason.spam:
        return 'Unwanted promotional content or repeated posts';
      case ReportReason.inappropriate:
        return 'Content that violates community guidelines';
      case ReportReason.fraud:
        return 'Scam, counterfeit products, or deceptive listings';
      case ReportReason.harassment:
        return 'Threatening, bullying, or abusive behavior';
      case ReportReason.illegal:
        return 'Content that promotes illegal activities';
      case ReportReason.other:
        return 'Other violation not listed above';
    }
  }

  String get icon {
    switch (this) {
      case ReportReason.spam:
        return '📧';
      case ReportReason.inappropriate:
        return '🚫';
      case ReportReason.fraud:
        return '⚠️';
      case ReportReason.harassment:
        return '😠';
      case ReportReason.illegal:
        return '🚨';
      case ReportReason.other:
        return '❓';
    }
  }
}

enum ReportStatus {
  pending,
  reviewed,
  resolved,
  dismissed;

  static ReportStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'resolved':
        return ReportStatus.resolved;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        return ReportStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ReportStatus.pending:
        return 'Under Review';
      case ReportStatus.reviewed:
        return 'Reviewed';
      case ReportStatus.resolved:
        return 'Action Taken';
      case ReportStatus.dismissed:
        return 'Dismissed';
    }
  }

  int get colorCode {
    switch (this) {
      case ReportStatus.pending:
        return 0xFFFFC107; // Yellow
      case ReportStatus.reviewed:
        return 0xFF2196F3; // Blue
      case ReportStatus.resolved:
        return 0xFF4CAF50; // Green
      case ReportStatus.dismissed:
        return 0xFF9E9E9E; // Gray
    }
  }
}

class Report {
  final int id;
  final ReportContentType contentType;
  final int contentId;
  final ReportReason reason;
  final String? description;
  final ReportStatus status;
  final String? resolution;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  const Report({
    required this.id,
    required this.contentType,
    required this.contentId,
    required this.reason,
    this.description,
    required this.status,
    this.resolution,
    required this.createdAt,
    this.reviewedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      contentType: ReportContentType.fromString(json['content_type'] ?? 'product'),
      contentId: json['content_id'] ?? 0,
      reason: ReportReason.fromString(json['reason'] ?? 'other'),
      description: json['description'],
      status: ReportStatus.fromString(json['status'] ?? 'pending'),
      resolution: json['resolution'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.tryParse(json['reviewed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_type': contentType.name,
      'content_id': contentId,
      'reason': reason.name,
      'description': description,
      'status': status.name,
      'resolution': resolution,
      'created_at': createdAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }

  bool get isResolved => status == ReportStatus.resolved || status == ReportStatus.dismissed;
}

/// Request model for submitting a report
class SubmitReportRequest {
  final ReportContentType contentType;
  final int contentId;
  final ReportReason reason;
  final String? description;

  const SubmitReportRequest({
    required this.contentType,
    required this.contentId,
    required this.reason,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'content_type': contentType.name,
      'content_id': contentId,
      'reason': reason.name,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }
}
