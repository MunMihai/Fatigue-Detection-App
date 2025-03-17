import 'package:driver_monitoring/domain/repositories/camera_repository.dart';

class SetZoomUseCase {
  final CameraRepository repository;

  SetZoomUseCase(this.repository);

  Future<void> call(double zoom) async {
    await repository.setZoom(zoom);
  }
}
