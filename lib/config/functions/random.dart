import 'dart:math';

final Random rnd = Random.secure();

String getRandomString({int length = 6, specialCharacters = '!@*()-_=+.', bool allowSpecialCharacters = false}) {
  String alphabets = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  String numbers = '1234567890';

  String _chars = alphabets + numbers + (allowSpecialCharacters ? specialCharacters : "");

  String randomString = String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(
        rnd.nextInt(
          _chars.length,
        ),
      ),
    ),
  );
  return randomString;
}
