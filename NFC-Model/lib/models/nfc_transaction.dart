class NFCTransaction {
  final String id;
  final String userId;
  final String stationId;
  final double amount;
  final DateTime timestamp;
  final String cardNumber;
  final String status;

  NFCTransaction({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.amount,
    required this.timestamp,
    required this.cardNumber,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'stationId': stationId,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'cardNumber': cardNumber,
    'status': status,
  };

  factory NFCTransaction.fromJson(Map<String, dynamic> json) => NFCTransaction(
    id: json['id'],
    userId: json['userId'],
    stationId: json['stationId'],
    amount: json['amount'],
    timestamp: DateTime.parse(json['timestamp']),
    cardNumber: json['cardNumber'],
    status: json['status'],
  );
}