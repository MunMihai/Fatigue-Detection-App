abstract class ICameraService {
  Future<void> initialize();
  Stream<Object> get frameStream;
  Future<void> startStream();
  Future<void> stopStream();
  Future<void> dispose();

  Object? get previewData;
}
