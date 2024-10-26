import 'package:flutter/material.dart';
import '../services/nfc_service.dart';

class NFCPaymentScreen extends StatefulWidget {
  final double amount;
  final String stationId;
  final String userId;

  const NFCPaymentScreen({
    Key? key,
    required this.amount,
    required this.stationId,
    required this.userId,
  }) : super(key: key);

  @override
  _NFCPaymentScreenState createState() => _NFCPaymentScreenState();
}

class _NFCPaymentScreenState extends State<NFCPaymentScreen> {
  final NFCService _nfcService = NFCService();
  bool _isProcessing = false;
  String _status = 'Ready to scan';

  Future<void> _startNFCPayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _status = 'Place your card on the device...';
    });

    try {
      final isAvailable = await _nfcService.isNFCAvailable();
      if (!isAvailable) {
        setState(() => _status = 'NFC not available on this device');
        return;
      }

      final success = await _nfcService.processPayment(
        amount: widget.amount,
        stationId: widget.stationId,
        userId: widget.userId,
      );

      setState(() {
        _status = success ? 'Payment successful!' : 'Payment failed';
      });

      if (success) {
        // Navigate back or to receipt screen
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() => _status = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₱${widget.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            Text(_status),
            const SizedBox(height: 20),
            if (!_isProcessing)
              ElevatedButton(
                onPressed: _startNFCPayment,
                child: const Text('Start NFC Payment'),
              ),
            if (_isProcessing)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}