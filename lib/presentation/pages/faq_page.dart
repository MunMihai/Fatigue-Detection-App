import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.faqTitle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaqItem(
            question: tr.faq1Q,
            answer: tr.faq1A,
          ),
          FaqItem(
            question: tr.faq2Q,
            answer: tr.faq2A,
          ),
          FaqItem(
            question: tr.faq3Q,
            answer: tr.faq3A,
          ),
          FaqItem(
            question: tr.faq4Q,
            answer: tr.faq4A,
          ),
          FaqItem(
            question: tr.faq5Q,
            answer: tr.faq5A,
          ),
          FaqItem(
            question: tr.faq6Q,
            answer: tr.faq6A,
          ),
          FaqItem(
            question: tr.faq7Q,
            answer: tr.faq7A,
          ),
          FaqItem(
            question: tr.faq8Q,
            answer: tr.faq8A,
          ),
          FaqItem(
            question: tr.faq9Q,
            answer: tr.faq9A,
          ),
          FaqItem(
            question: tr.faq10Q,
            answer: tr.faq10A,
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(widget.question, style: AppTextStyles.h4(context)),
        initiallyExpanded: _isExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer,
              style: AppTextStyles.subtitle,
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}
