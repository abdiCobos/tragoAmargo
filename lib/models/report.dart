import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String reporterId;
  final String reporterName;
  final String targetId;
  final String targetType; // 'shop', 'review'
  final String reason;
  final String details;
  final DateTime createdAt;

  Report({
    this.id = '',
    required this.reporterId,
    required this.reporterName,
    required this.targetId,
    required this.targetType,
    required this.reason,
    this.details = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Report.fromMap(String id, Map<String, dynamic> data) {
    return Report(
      id: id,
      reporterId: data['reporterId'] ?? '',
      reporterName: data['reporterName'] ?? '',
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? '',
      reason: data['reason'] ?? '',
      details: data['details'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reporterId': reporterId,
      'reporterName': reporterName,
      'targetId': targetId,
      'targetType': targetType,
      'reason': reason,
      'details': details,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
