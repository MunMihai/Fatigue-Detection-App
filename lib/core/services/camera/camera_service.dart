abstract class ICameraService {
  Future<void> initialize();
  Stream<Object> get frameStream; // Sau tipul exact de frame (ex: CameraImage)
  Future<void> startStream();
  Future<void> stopStream();
  Future<void> dispose();
}
