class DashboardModel {
  final List<PaymentModel> previousUnpaidPayments;
  final PaymentModel? nextUpcomingPayment;
  final List<PaymentModel> previousPaidPayments;

  DashboardModel({
    required this.previousUnpaidPayments,
    required this.nextUpcomingPayment,
    required this.previousPaidPayments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      previousUnpaidPayments: (json['PreviousUnpaidPayments'] as List)
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
      nextUpcomingPayment: json['NextUpcomingPayment'] == null
          ? null
          : PaymentModel.fromJson(json['NextUpcomingPayment']),
      previousPaidPayments: (json['PreviousPaidPayments'] as List)
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
    );
  }
}

class PaymentModel {
  final String date;
  final double amount;

  PaymentModel({required this.date, required this.amount});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      date: json['RentDueDate'],
      amount: (json['RentAmount'] as num).toDouble(),
    );
  }
}
