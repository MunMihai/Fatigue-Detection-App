abstract class Failure {
  final String message;
  final int? code; // Opțional, pentru coduri specifice (ex: 404, 500)

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}