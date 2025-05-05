class DenominationDataModel {
  final int? id;
  final double totalAmount;
  final String fileName;
  final String timestamp;

  DenominationDataModel({
    this.id,
    required this.totalAmount,
    required this.fileName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'fileName': fileName,
      'timestamp': timestamp,
    };
  }

  factory DenominationDataModel.fromMap(Map<String, dynamic> map) {
    return DenominationDataModel(
      id: map['id'],
      totalAmount: map['totalAmount'],
      fileName: map['fileName'],
      timestamp: map['timestamp'],
    );
  }
}
