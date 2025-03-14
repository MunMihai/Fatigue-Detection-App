import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';

class AllSessionReportsPage extends StatefulWidget {
  const AllSessionReportsPage({super.key});

  @override
  State<AllSessionReportsPage> createState() => _AllSessionReportsPageState();
}

class _AllSessionReportsPageState extends State<AllSessionReportsPage> {
  String _searchQuery = '';
  bool _sortAsc = false;

  List<SessionReport> getFilteredAndSortedReports(
    List<SessionReport> reports,
    String searchQuery,
    bool sortAsc,
  ) {
    var filtered = reports.where((session) {
      final query = searchQuery.toLowerCase();
      return session.timestamp.toIso8601String().contains(query) ||
          session.fatigueLevelLabel.toLowerCase().contains(query);
    }).toList();

    filtered.sort((a, b) => sortAsc
        ? a.timestamp.compareTo(b.timestamp)
        : b.timestamp.compareTo(a.timestamp));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionReportProvider>();

    final reports = provider.reports;
    final filteredAndSortedReports = getFilteredAndSortedReports(
      reports,
      _searchQuery,
      _sortAsc,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Reports'),
        actions: [
          IconButton(
            icon: Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _sortAsc = !_sortAsc;
              });
            },
            tooltip: 'Sort by timestamp',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search reports...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAndSortedReports.isEmpty
                    ? const Center(child: Text('No reports found.'))
                    : ListView.builder(
                        itemCount: filteredAndSortedReports.length,
                        itemBuilder: (context, index) {
                          final report = filteredAndSortedReports[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text('Session ID: ${report.id}'),
                              subtitle: Text(
                                'Date: ${report.timestamp}\n'
                                'Avg Severity: ${report.averageSeverity.toStringAsFixed(2)}',
                              ),
                              onTap: () {
                                // Optional: navighează către detalii
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
