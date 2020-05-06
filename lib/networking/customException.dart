class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([String message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([String message]) : super(message, "Unauthorised: ");
}

class ForbiddenException extends CustomException {
  ForbiddenException([String message]) : super(message, "Forbidden: ");
}

class DataNotFoundException extends CustomException {
  DataNotFoundException([String message]) : super(message, "Data Not Found: ");
}

class InternalServerException extends CustomException {
  InternalServerException([String message])
      : super(message, "Internal Server Error: ");
}
