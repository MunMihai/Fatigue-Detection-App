import 'package:logger/logger.dart';

final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // arată numărul de apeluri pe stack trace
    errorMethodCount: 5, // stack trace mai mare la error
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);
