import 'package:flutter/material.dart';
import 'package:c_h_p/features/payment/presentation/pages/payment_page.dart';

class CheckoutFormPage extends StatelessWidget {
  final int totalAmountPaise;

  const CheckoutFormPage({super.key, required this.totalAmountPaise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Form')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentPage(
                  totalAmount: totalAmountPaise,
                  deliveryAddress: 'Placeholder Address',
                  fullName: 'Placeholder Name',
                  email: 'test@example.com',
                  phone: '1234567890',
                  lat: 0.0,
                  lng: 0.0,
                ),
              ),
            );
          },
          child: const Text('Proceed to Payment'),
        ),
      ),
    );
  }
}
