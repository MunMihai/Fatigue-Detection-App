import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/reports/session_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum SortOption { dateDesc, dateAsc, durationDesc, durationAsc }

class AllSessionReportsPage extends StatefulWidget {
  const AllSessionReportsPage({super.key});

  @override
  State<AllSessionReportsPage> createState() => _AllSessionReportsPageState();
}

class _AllSessionReportsPageState extends State<AllSessionReportsPage> {
  String _searchQuery = '';
  SortOption _selectedSortOption = SortOption.dateDesc; 

  List<SessionReport> getFilteredReports(
    List<SessionReport> reports,
    String searchQuery,
  ) {
    final query = searchQuery.toLowerCase();

    List<SessionReport> filtered = reports.where((session) {
      return session.timestamp.toIso8601String().contains(query) ||
          session.fatigueLevelLabel.toLowerCase().contains(query);
    }).toList();

    switch (_selectedSortOption) {
      case SortOption.dateDesc:
        filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case SortOption.dateAsc:
        filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case SortOption.durationDesc:
        filtered.sort((a, b) => b.durationMinutes.compareTo(a.durationMinutes));
        break;
      case SortOption.durationAsc:
        filtered.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionReportProvider>();
    final reports = provider.reports;
    final filteredReports = getFilteredReports(reports, _searchQuery);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpaceses.verticalSmall,
            /// 📋 Opțiuni de sortare
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort by:', style: AppTextStyles.filterText),
                DropdownButton<SortOption>(
                  value: _selectedSortOption,
                  onChanged: (SortOption? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSortOption = newValue;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: SortOption.dateDesc,
                      child: Text('Date ↓'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.dateAsc,
                      child: Text('Date ↑'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.durationDesc,
                      child: Text('Duration ↓'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.durationAsc,
                      child: Text('Duration ↑'),
                    ),
                  ],
                ),
              ],
            ),

            AppSpaceses.verticalSmall,

            /// 🔎 Câmp de căutare
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
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
                prefixIcon: const Icon(Icons.search, color: Colors.black, size: 30),
              ),
            ),

            AppSpaceses.verticalMedium,


            /// 🔄 Lista de sesiuni
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredReports.isEmpty
                      ? const Center(child: Text('No sessions found.'))
                      : ListView.builder(
                          itemCount: filteredReports.length,
                          itemBuilder: (context, index) {
                            final report = filteredReports[index];
                            return SessionCard(sessionReport: report);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
