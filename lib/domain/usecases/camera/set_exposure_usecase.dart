import 'package:driver_monitoring/domain/repositories/camera_repository.dart';

class SetExposureUseCase {
  final CameraRepository repository;

  SetExposureUseCase(this.repository);

  Future<void> call(double exposure) async {
    await repository.setExposure(exposure);
  }
}
