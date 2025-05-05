class DenominationDataModel {
  final int? id;
  final double totalAmount;
  final String fileName;
  final String timestamp;
  final List<int> noteQuantities;

  DenominationDataModel({
    this.id,
    required this.totalAmount,
    required this.fileName,
    required this.timestamp,
    required this.noteQuantities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'fileName': fileName,
      'timestamp': timestamp,
      'noteQuantities': noteQuantities.join(
        ',',
      ), // Store as comma-separated string
    };
  }

  factory DenominationDataModel.fromMap(Map<String, dynamic> map) {
    return DenominationDataModel(
      id: map['id'],
      totalAmount: map['totalAmount'],
      fileName: map['fileName'],
      timestamp: map['timestamp'],
      noteQuantities:
          (map['noteQuantities'] as String)
              .split(',')
              .map((e) => int.tryParse(e) ?? 0)
              .toList(),
    );
  }
}
