import 'dart:convert';
import 'package:foap/helper/imports/common_import.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;


class StripeCardPayment extends StatefulWidget {
  const StripeCardPayment({Key? key}) : super(key: key);

  @override
  StripeCardPaymentState createState() => StripeCardPaymentState();
}

class StripeCardPaymentState extends State<StripeCardPayment> {
  stripe.CardFieldInputDetails? _card;

  // bool? _saveCard = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: SizedBox(
            height: Get.height,
            child: Column(children: [

              backNavigationBar(
                   title: buyTicketString.tr),

              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  stripe.CardField(
                    enablePostalCode: true,
                    countryCode: 'US',
                    postalCodeHintText: 'Enter the us postal code',
                    onCardChanged: (card) {
                      setState(() {
                        _card = card;
                      });
                    },
                  ),
                  // const SizedBox(height: 20),
                  // CheckboxListTile(
                  //   value: _saveCard,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _saveCard = value;
                  //     });
                  //   },
                  //   title: Text('Save card during payment'),
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  AppThemeButton(
                      text: payString.tr, onPress: _handlePayPress)
                ],
              ).hp(DesignConstants.horizontalPadding)
            ])));
  }

  Future<void> _handlePayPress() async {
    if (_card == null) {
      return;
    }

    // 1. fetch Intent Client Secret from backend
    final clientSecret = await fetchPaymentIntentClientSecret();

    // 2. Gather customer billing information (ex. email)
    const billingDetails = stripe.BillingDetails(
      // email: _email,
      phone: '+48888000888',
      address: stripe.Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mo mocked data for tests

    // 3. Confirm payment with card details
    // The rest will be done automatically using webhooks
    // ignore: unused_local_variable
    final paymentIntent = await stripe.Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret['clientSecret'],
      data: const stripe.PaymentMethodParams.card(
        paymentMethodData: stripe.PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ),
    );

    AppUtil.showToast(
        message: 'Success!: The payment was confirmed successfully!',
        isSuccess: true);
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currency': 'usd',
        'amount': 1099,
        'payment_method_types': ['card'],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }
}
