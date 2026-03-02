import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, String>> sendMessage(String message);
  void resetChat();
}

