import 'package:flutter/material.dart';

import 'package:c_h_p/features/checkout/presentation/pages/checkout_form_page.dart'
    as feature_checkout;

import 'package:c_h_p/features/payment/presentation/pages/payment_page.dart';

class CheckoutFormPage extends StatelessWidget {
  final int totalAmountPaise;

  const CheckoutFormPage({super.key, required this.totalAmountPaise});

  @override
  Widget build(BuildContext context) {
    return feature_checkout.CheckoutFormPage(
      totalAmountPaise: totalAmountPaise,
      onProceedToPayment: (args) async {
        if (!context.mounted) return;

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentPage(
              totalAmount: args.totalAmountPaise,
              deliveryAddress: args.deliveryAddress,
              fullName: args.fullName,
              email: args.email,
              phone: args.phone,
              lat: args.lat,
              lng: args.lng,
            ),
          ),
        );
      },
    );
  }
}
