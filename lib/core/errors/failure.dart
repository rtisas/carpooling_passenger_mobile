abstract class Failure {
  final String message;
  Failure({required this.message});
}
class FailureResponse extends Failure {
  FailureResponse({required String message}) : super(message: message);
}
