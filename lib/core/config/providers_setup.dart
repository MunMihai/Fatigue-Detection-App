import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';

import 'package:driver_monitoring/data/datasources/mock_report_sessions_local_datasource.dart';
import 'package:driver_monitoring/data/repositories/session_report_repositiry_impl.dart';

import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';

List<SingleChildWidget> getAppProviders() {
  final reportDataSource = MockSessionReportLocalDataSource();
  final sessionReportRepository = SessionReportRepositoryImpl(dataSource: reportDataSource);

  final getReportsUseCase = GetReportsUseCase(sessionReportRepository);
  final addReportUseCase = AddReportUseCase(sessionReportRepository);
  final updateReportUseCase = UpdateReportUseCase(sessionReportRepository);
  final deleteReportUseCase = DeleteReportUseCase(sessionReportRepository);

  return [
    ChangeNotifierProvider(
      create: (_) => SettingsProvider()..loadSettings(),
    ),
    ChangeNotifierProvider(
      create: (_) => SessionReportProvider(
        getReportsUseCase: getReportsUseCase,
        addReportUseCase: addReportUseCase,
        updateReportUseCase: updateReportUseCase,
        deleteReportUseCase: deleteReportUseCase,
      )..fetchReports(),
    ),
  ];
}
