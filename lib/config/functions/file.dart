import 'dart:io';
import 'dart:math';

String getFileName(String path) {
  return path.split('/').last;
}

String getFileType(String path) {
  return path.split('/').last.split('.').last.toUpperCase();
}

Future<String> getFileSize(String filepath, {int decimals = 1}) async {
  File file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  int i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}
