import 'dart:ui';
import 'package:flutter/material.dart';

// The main function is the entry point of the app.

// New: A helper function to format numbers as Indian currency (e.g., ₹1,20,000)
// This removes the need for the 'intl' package.
String formatCurrency(double amount) {
  String value = amount.toInt().toString();
  if (value.length <= 3) {
    return '₹$value';
  }
  String result = '';
  // Get the last 3 digits
  result = value.substring(value.length - 3);
  // Get the remaining digits
  String remaining = value.substring(0, value.length - 3);

  // Add a comma every 2 digits to the remaining part
  while (remaining.isNotEmpty) {
    if (remaining.length > 2) {
      result = '${remaining.substring(remaining.length - 2)},$result';
      remaining = remaining.substring(0, remaining.length - 2);
    } else {
      result = '$remaining,$result';
      remaining = '';
    }
  }
  return '₹$result';
}

// The page is now a StatefulWidget to manage the state of the receipt view.
class FeeStatusPage extends StatefulWidget {
  const FeeStatusPage({super.key});

  @override
  State<FeeStatusPage> createState() => _FeeStatusPageState();
}

class _FeeStatusPageState extends State<FeeStatusPage> {
  // Data source for fee items, now with a transaction ID.
  final List<Map<String, String>> _feeItems = const [
    {'name': 'Tuition Fee', 'amount': '120000', 'status': 'Paid', 'date': '15 Jul 2025', 'txnId': 'TXN100239845'},
    {'name': 'Hostel Fee', 'amount': '50000', 'status': 'Due', 'date': '10 Oct 2025', 'txnId': ''},
    {'name': 'Library Fee', 'amount': '2500', 'status': 'Paid', 'date': '15 Jul 2025', 'txnId': 'TXN100239846'},
    {'name': 'Transport Fee', 'amount': '15000', 'status': 'Paid', 'date': '20 Aug 2025', 'txnId': 'TXN100241221'},
    {'name': 'Exam Fee', 'amount': '1500', 'status': 'Due', 'date': '25 Oct 2025', 'txnId': ''},
  ];

  // State variable to hold the data of the selected receipt.
  Map<String, String>? _selectedReceipt;

  // Function to show the receipt overlay.
  void _showReceipt(Map<String, String> receiptData) {
    setState(() {
      _selectedReceipt = receiptData;
    });
  }

  // Function to hide the receipt overlay.
  void _hideReceipt() {
    setState(() {
      _selectedReceipt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals for the summary card.
    double totalDue = 0;
    double totalPaid = 0;
    for (var item in _feeItems) {
      final amount = double.tryParse(item['amount']!) ?? 0;
      if (item['status'] == 'Due') {
        totalDue += amount;
      } else if (item['status'] == 'Paid') {
        totalPaid += amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Status'),
      ),
      // Using a Stack to overlay the receipt view on top of the main content.
      body: Stack(
        children: [
          Column(
            children: [
              FeeSummaryCard(totalDue: totalDue, totalPaid: totalPaid),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: _feeItems.length,
                  itemBuilder: (context, index) {
                    final item = _feeItems[index];
                    return FeeItemCard(
                      name: item['name']!,
                      amount: double.parse(item['amount']!),
                      status: item['status']!,
                      date: item['date']!,
                      // Pass the callback function to the card.
                      onViewReceipt: () => _showReceipt(item),
                    );
                  },
                ),
              ),
            ],
          ),
          // If a receipt is selected, show the overlay.
          if (_selectedReceipt != null)
            ReceiptOverlay(
              receiptData: _selectedReceipt!,
              onClose: _hideReceipt,
            ),
        ],
      ),
    );
  }
}

/// A summary card showing total amounts due and paid.
class FeeSummaryCard extends StatelessWidget {
  final double totalDue;
  final double totalPaid;

  const FeeSummaryCard({
    super.key,
    required this.totalDue,
    required this.totalPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(context, "Total Paid", formatCurrency(totalPaid), theme.colorScheme.secondary),
                _buildSummaryItem(context, "Total Due", formatCurrency(totalDue), theme.colorScheme.tertiary),
              ],
            ),
            const SizedBox(height: 20),
            if (totalDue > 0)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.payment_rounded),
                  label: Text('Pay Total Due (${formatCurrency(totalDue)})'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

/// A card for each individual fee item.
class FeeItemCard extends StatelessWidget {
  final String name;
  final double amount;
  final String status;
  final String date;
  final VoidCallback onViewReceipt; // Callback for viewing receipt.

  const FeeItemCard({
    super.key,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaid = status == 'Paid';
    final statusColor = isPaid ? theme.colorScheme.secondary : theme.colorScheme.tertiary;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(formatCurrency(amount), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(isPaid ? 'Paid on $date' : 'Due by $date', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: isPaid
                  ? OutlinedButton.icon(
                onPressed: onViewReceipt, // Trigger the callback.
                icon: const Icon(Icons.receipt_long_rounded, size: 16),
                label: const Text('View Receipt'),
                style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.onSurface, side: BorderSide(color: Colors.grey.withOpacity(0.3))),
              )
                  : FilledButton(
                onPressed: () {},
                child: const Text('Pay Now'),
                style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A new widget for the receipt overlay.
class ReceiptOverlay extends StatelessWidget {
  final Map<String, String> receiptData;
  final VoidCallback onClose;

  const ReceiptOverlay({
    super.key,
    required this.receiptData,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Blurred background
        GestureDetector(
          onTap: onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
        // Receipt card in the center
        Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Receipt', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Icon(Icons.check_circle, color: theme.colorScheme.secondary, size: 28),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildReceiptRow(context, 'Item:', receiptData['name']!),
                  _buildReceiptRow(context, 'Amount Paid:', formatCurrency(double.parse(receiptData['amount']!))),
                  _buildReceiptRow(context, 'Date:', receiptData['date']!),
                  _buildReceiptRow(context, 'Transaction ID:', receiptData['txnId']!),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onClose,
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}