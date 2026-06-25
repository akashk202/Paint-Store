import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/payment_providers.dart';

// Centralize Razorpay Key ID so it can be easily changed later
const String kRazorpayKeyId = 'rzp_test_RVfRg0s4WjSnkL';

class PaymentPage extends ConsumerStatefulWidget {
  final int totalAmount; // Amount in smallest currency unit (e.g., paise)
  final String? deliveryAddress;
  final String? fullName;
  final String? email;
  final String? phone;
  final double? lat;
  final double? lng;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    this.deliveryAddress,
    this.fullName,
    this.email,
    this.phone,
    this.lat,
    this.lng,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  bool _paymentCompleted = false;
  String? _deliveryAddress;
  bool _openedCheckout = false;
  bool _checkoutInvoked = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _deliveryAddress = widget.deliveryAddress;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_openedCheckout) {
        _openedCheckout = true;
        _openCheckout();
      }
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;
    debugPrint("✅ PAYMENT SUCCESSFUL: ${response.paymentId}");
    setState(() => _isProcessing = true);
    _paymentCompleted = true;
    try {
      _razorpay.clear();
    } catch (_) {}

    try {
      final orderId =
          await ref.read(paymentNotifierProvider.notifier).handlePaymentSuccess(
                paymentId: response.paymentId ?? 'N/A',
                signature: response.signature,
                totalAmountPaise: widget.totalAmount,
                deliveryAddress: _deliveryAddress,
                lat: widget.lat,
                lng: widget.lng,
                fullName: widget.fullName,
                email: widget.email,
                phone: widget.phone,
              );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessPage(
            orderId: orderId ?? 'N/A',
            paymentId: response.paymentId ?? 'N/A',
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error handling payment success: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment successful, but failed to finalize order: $e'),
        backgroundColor: Colors.orange,
      ));
      setState(() => _isProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    if (_paymentCompleted) return;
    debugPrint("❌ PAYMENT FAILED: ${response.code} - ${response.message}");
    setState(() => _isProcessing = false);
    final msg = (response.message == null || response.message!.isEmpty)
        ? 'Payment failed. Please try again.'
        : 'Payment Failed: ${response.message}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    debugPrint("📦 EXTERNAL WALLET: ${response.walletName}");
  }

  void _openCheckout() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    String? userEmail = widget.email;
    String? userContact = widget.phone;

    if (_deliveryAddress == null || _deliveryAddress!.trim().isEmpty) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a delivery address to proceed.'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }

    if (widget.totalAmount < 100) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Amount too low to process. Minimum is ₹1.'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }

    var options = {
      'key': kRazorpayKeyId,
      'amount': widget.totalAmount,
      'currency': 'INR',
      'name': 'Chandra Paints',
      'description': 'Paint Order Payment',
      'timeout': 120,
      'prefill': {
        if (userEmail != null) 'email': userEmail,
        if (userContact != null) 'contact': userContact,
      },
      'theme': {
        'color': '#FF5722'
      }
    };

    try {
      _checkoutInvoked = true;
      _razorpay.open(options);
      Future.delayed(const Duration(seconds: 8), () {
        if (!mounted) return;
        if (!_paymentCompleted && _checkoutInvoked && _isProcessing) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open payment sheet. Tap to retry.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
      debugPrint('Error opening Razorpay checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Could not start payment. Please try again. (Details: ${e.toString()})'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Processing Payment",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.deepOrange),
            const SizedBox(height: 16),
            Text('Opening secure payment...',
                style: GoogleFonts.poppins(color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            if (!_isProcessing && !_paymentCompleted)
              ElevatedButton(
                onPressed: _openCheckout,
                child: const Text('Retry Payment'),
              ),
          ],
        ),
      ),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final String paymentId;

  const OrderSuccessPage(
      {super.key, required this.orderId, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Order Successful"),
          automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Icon(Iconsax.tick_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              Text("Payment Successful!",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Your order has been placed.",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey.shade700)),
              const SizedBox(height: 20),
              Text("Order ID: $orderId",
                  style: GoogleFonts.poppins(fontSize: 14)),
              Text("Payment ID: $paymentId",
                  style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context,
                      (route) => route.isFirst);
                },
                child: const Text("Continue Shopping"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
