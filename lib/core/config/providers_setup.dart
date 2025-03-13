import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:driver_monitoring/data/datasources/mock_report_sessions_local_datasource.dart';
import 'package:driver_monitoring/data/repositories/session_report_repositiry_impl.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';

import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class AppProvidersWrapper extends StatefulWidget {
  final Widget child;

  const AppProvidersWrapper({super.key, required this.child});

  @override
  State<AppProvidersWrapper> createState() => _AppProvidersWrapperState();
}

class _AppProvidersWrapperState extends State<AppProvidersWrapper> {
  bool _previousReportsSectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    final reportDataSource = MockSessionReportLocalDataSource();
    final sessionReportRepository =
        SessionReportRepositoryImpl(dataSource: reportDataSource);

    final getReportsUseCase = GetReportsUseCase(sessionReportRepository);
    final addReportUseCase = AddReportUseCase(sessionReportRepository);
    final updateReportUseCase = UpdateReportUseCase(sessionReportRepository);
    final deleteReportUseCase = DeleteReportUseCase(sessionReportRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, SessionReportProvider>(
          create: (_) => SessionReportProvider(
            getReportsUseCase: getReportsUseCase,
            addReportUseCase: addReportUseCase,
            updateReportUseCase: updateReportUseCase,
            deleteReportUseCase: deleteReportUseCase,
          ),
          update: (context, settingsProvider, reportProvider) {
            final isEnabled = settingsProvider.isReportsSectionEnabled;

            final nonNullReportProvider = reportProvider ??
                SessionReportProvider(
                  getReportsUseCase: getReportsUseCase,
                  addReportUseCase: addReportUseCase,
                  updateReportUseCase: updateReportUseCase,
                  deleteReportUseCase: deleteReportUseCase,
                );

            if (isEnabled && !nonNullReportProvider.hasFetchedReports) {
              nonNullReportProvider.fetchReports();
            }

            if (!isEnabled && _previousReportsSectionEnabled) {
              nonNullReportProvider.clearReports();
            }

            _previousReportsSectionEnabled = isEnabled;

            return nonNullReportProvider;
          },
        ),
      ],
      child: widget.child,
    );
  }
}
