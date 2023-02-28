abstract class Failure {
  final String message;
  final Exception? exception;
  Failure({required this.message, this.exception});
}
class FailureResponse extends Failure {
  FailureResponse({required String message, Exception? exception}) : super(message: message, exception: exception);
}
