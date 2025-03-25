import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'FAQ - Driver Monitoring',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FaqItem(
            question: 'How does the fatigue detection work?',
            answer:
                'The system analyzes facial features in real-time video, focusing on eye closure and yawning detection. If signs of fatigue are detected consistently, the system triggers alerts to notify you.',
          ),
          FaqItem(
            question: 'What happens if no face is detected?',
            answer:
                'If no face is detected for a set of time and you are not on a break, the monitoring session will automatically stop and notify you.',
          ),
          FaqItem(
            question: 'How do I calibrate the camera for better detection?',
            answer:
                'In Camera Preview, you can adjust the camera zoom and brightness settings so your face is clearly visible. For accurate fatigue detection, make sure there is enough light inside the car. Avoid shadows or extreme backlight.',
          ),
          FaqItem(
            question: 'How can I adjust the sensitivity?',
            answer:
                'You can adjust the detection sensitivity directly from the Home screen in the "Set Up Your System" section. We recommend avoiding the highest level unless necessary, as it may lead to more frequent alerts.',
          ),
          FaqItem(
            question: 'Can I review past monitoring sessions?',
            answer:
                'Yes, all previous sessions are stored locally. Go to Reports to view your session history, detailed fatigue levels, and alerts.',
          ),
          FaqItem(
            question: 'Why can’t I find the Reports section?',
            answer:
                'The Reports section is disabled by default. To enable it, go to Settings > Preferences and activate “Enable Reports Section”. Once enabled, you can review your past monitoring sessions and view detailed reports.',
          ),
          FaqItem(
            question: 'Does the app work without an internet connection?',
            answer:
                'Absolutely! All detection and alerts are processed offline on your device. No internet connection is required for monitoring.',
          ),
          FaqItem(
            question: 'How is my data stored and is it safe?',
            answer:
                'Session data is stored locally on your device. No data is shared externally. You can configure data retention settings in the app.',
          ),
          FaqItem(
            question: 'What is the break recommendation based on?',
            answer:
                'Break recommendations are triggered by fatigue scores or session timeouts. Customize break intervals in Settings.',
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
        title: Text(
          widget.question,
          style: AppTextStyles.h4
        ),
        initiallyExpanded: _isExpanded,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.answer, style: AppTextStyles.subtitle,),
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
