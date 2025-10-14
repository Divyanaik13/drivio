import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? _openIndex; // keep only one tile open at a time

  final List<_FaqItem> _items = const [
    _FaqItem(
      question: "Q1. How does the service work?",
      answer:
      "Our app connects riders with verified drivers in real time. Enter pickup and drop, choose ride type (One Way or Round Trip), and confirm your booking.",
    ),
    _FaqItem(
      question: "Q2. Can I trust the drivers?",
      answer:
      "Yes. Drivers are verified with ID and vehicle checks. You can view ratings before confirming a ride.",
    ),
    _FaqItem(
      question: "Q3. How can I contact my driver?",
      answer:
      "Once a ride is assigned, you can call or chat with the driver from the trip details screen.",
    ),
    _FaqItem(
      question: "Q4. What payment methods are accepted?",
      answer:
      "We accept UPI, cards, wallets, and cash (where available). Add a preferred method in Settings.",
    ),
    _FaqItem(
      question: "Q5. What if my driver cancels?",
      answer:
      "We’ll instantly try to reassign another nearby driver. You can also rebook from the same screen.",
    ),
    _FaqItem(
      question: "Q6. Do you provide support in case of issues?",
      answer:
      "Yes. Use the in-app Help Center or call support from the trip receipt within 24 hours of your ride.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Header row
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                const SizedBox(width: 4),
                Text(
                  "Frequently asked questions",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Card container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: _buildFaqList(theme),
            ),
            const SizedBox(height: 16),
            /*Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: navigate to full FAQ page
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: const Color(0xFFE53935), // red link
                ),
                child: const Text(
                  "Read More",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: .6),
      itemBuilder: (context, index) {
        final item = _items[index];
        final isOpen = _openIndex == index;

        return Theme(
          // remove default ExpansionTile divider padding/elevation effects
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: PageStorageKey(index),
            initiallyExpanded: isOpen,
            tilePadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedShape:
            const RoundedRectangleBorder(side: BorderSide.none),
            title: Text(
              item.question,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isOpen ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            onExpansionChanged: (open) {
              setState(() {
                _openIndex = open ? index : null; // single-open behavior
              });
            },
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6F6F6F),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}
