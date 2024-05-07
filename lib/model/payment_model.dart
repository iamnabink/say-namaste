import 'package:intl/intl.dart';

import '../helper/enum.dart';
import '../helper/enum_linking.dart';

class TransactionModel {
  int id = 0;
  String amount = '';
  int status = 0;
  String createDate = '';
  PaymentType paymentType = PaymentType.package;
  TransactionType transactionType = TransactionType.credit;
  PaymentMode paymentMode = PaymentMode.inAppPurchase;

  TransactionModel();

  factory TransactionModel.fromJson(dynamic json) {
    TransactionModel model = TransactionModel();
    model.id = json['id'];
    model.amount = (json['amount'] ?? '').toString();
    model.status = json['status'];
    model.paymentType = paymentTypeFromId(json['payment_type']);
    model.transactionType = transactionTypeFromId(json['transaction_type']);
    model.paymentMode = paymentModeFromId(json['payment_mode']);

    DateTime createDate =
        DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc();
    String dateString = DateFormat('MMM dd, yyyy').format(createDate);
    model.createDate = dateString;

    return model;
  }
}
