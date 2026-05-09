class MapsException implements Exception {
  final String message;
  MapsException(this.message);
  @override
  String toString() => 'MapsException: $message';
}

class MapsServerException extends MapsException {
  final int statusCode;
  MapsServerException(this.statusCode, [String? body])
      : super('HTTP $statusCode${body == null ? '' : ': $body'}');
}

class MapsRateLimitException extends MapsException {
  MapsRateLimitException() : super('Rate limited (429)');
}

class MapsTimeoutException extends MapsException {
  MapsTimeoutException() : super('Request timed out');
}

class MapsParseException extends MapsException {
  final String rawBody;
  final String reason;
  MapsParseException(this.rawBody, this.reason)
      : super('Parse failure: $reason — body=$rawBody');
}
