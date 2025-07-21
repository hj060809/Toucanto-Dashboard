import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:toucanto_dashboard/global_constants.dart';
import 'package:toucanto_dashboard/utils/object_utils.dart';

Future<Directory> getDirectory(List<String> path) async {
  Directory documentDir = await getApplicationDocumentsDirectory();
  String directoryPath = documentDir.path;

  for (String dirName in path) {
    directoryPath = "$directoryPath\\$dirName";
    Directory lowerDir = Directory(directoryPath);

    bool isExist = await lowerDir.exists();
    if (!isExist) {
      await lowerDir.create();
    }
  }

  return Directory(directoryPath);
}

Future<File> getFile(
  List<String> path,
  String fileName,
  String defaultContent,
) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  if (!(await file.exists())) {
    await file.create();
    await file.writeAsString(defaultContent);
  }
  return file;
}

Future<bool> isFileExist(List<String> path, String fileName) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  return file.exists();
}

Future<File?> getNullableFile(List<String> path, String fileName) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  if (!(await file.exists())) {
    return null;
  }
  return file;
}

Future<String> prepareFFmpeg() async {
  return await prepareFile('assets/files/ffmpeg.exe');
}

Future<String> prepareFFprobe() async {
  return await prepareFile('assets/files/ffprobe.exe');
}

Future<String> prepareFile(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/${extractFileName(assetPath)}';
  final file = File(filePath);
  await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
  return filePath;
}

Future<Map<String, String>> readPropertyFile(File propertyFile) async {
  final lines = await propertyFile.readAsLines();
  final map = <String, String>{};
  for (String line in lines) {
    line = line.trim();
    if (line.isEmpty || line.startsWith('#') || line.startsWith('!')) {
      continue; // 주석 또는 빈줄 무시
    }
    final idx = line.indexOf('=');
    if (idx <= 0) continue; // 형식이 올바르지 않으면 건너뜀

    final key = line.substring(0, idx).trim();
    final value = line.substring(idx + 1).trim();
    map[key] = value;
  }

  return map;
}

Map<String, int> parseMapValueToInt(
  Map<String, String> m, {
  int defaultValue = -1,
}) {
  return m.map((key, value) {
    final parsed = int.tryParse(value) ?? defaultValue;
    return MapEntry(key, parsed);
  });
}

Future<void> writePropertyFile(
  File propertyFile,
  Map data, {
  bool KVReverse = false,
}) async {
  final buffer = StringBuffer();
  data.forEach((key, value) {
    buffer.writeln(KVReverse ? '$value=$key' : '$key=$value');
  });
  await propertyFile.writeAsString(buffer.toString());
}

String extractFileName(String path) {
  return path.replaceAll('\\', '/').split('/').last;
}

String getCurrentTimeString() {
  DateTime now = DateTime.now();

  formatter(int num) {
    return num.toString().padLeft(2, '0');
  }

  return "${now.year}-${formatter(now.month)}-${formatter(now.day)} ${formatter(now.hour)}h${formatter(now.minute)}m${formatter(now.second)}s";
}