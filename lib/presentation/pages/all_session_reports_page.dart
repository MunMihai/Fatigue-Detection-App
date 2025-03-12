import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/widgets/reports/session_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';

class AllSessionRportsPage extends StatelessWidget {
  const AllSessionRportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<SessionReportProvider>();
    final sessions = reportProvider.filteredAndSortedReports;
    final isLoading = reportProvider.isLoading;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: 'All Sessions',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpaceses.verticalLarge,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sort by', style: AppTextStyles.h2),
                      GestureDetector(
                        onTap: () {
                          reportProvider.toggleSortOrder();
                        },
                        child: Row(
                          children: [
                            Text('Date', style: AppTextStyles.h4),
                            Icon(
                              reportProvider.sortAsc
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  AppSpaceses.verticalLarge,

                  /// Search field
                  TextField(
                    onChanged: (value) {
                      reportProvider.setSearchQuery(value);
                    },
                    style: AppTextStyles.filterText,
                    decoration: InputDecoration(
                      hintText: 'Filter by date or fatigue level...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.searchBar,
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.black, size: 30),
                    ),
                  ),

                  AppSpaceses.verticalMedium,

                  /// Lista de sesiuni
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await reportProvider.fetchReports();
                      },
                      child: sessions.isEmpty
                          ? const Center(child: Text('No sessions found.'))
                          : ListView.builder(
                              itemCount: sessions.length,
                              itemBuilder: (context, index) {
                                final session = sessions[index];
                                return SessionCard(sessionReport: session);
                              },
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
