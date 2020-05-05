class Transaction {
  final String appointmentId;
  final String transactionId;
  final int amount;

  Transaction({this.appointmentId,this.transactionId, this.amount});

  Transaction.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        transactionId = json['transaction_id'],
        amount = json['amount'];

  Map<String, dynamic> toJson() => {
        'appointment_id': appointmentId,
        'transaction_id': transactionId,
        'amount': amount,
      };
}