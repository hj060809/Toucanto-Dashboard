import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<Directory> getDirectory(List<String> path) async {
  Directory documentDir = await getApplicationDocumentsDirectory();
  String directoryPath = documentDir.path;

  for(String dirName in path){
    directoryPath = "$directoryPath\\$dirName";
    Directory lowerDir = Directory(directoryPath);

    bool isExist = await lowerDir.exists();
    if(!isExist){
      await lowerDir.create();
    }
  }

  return Directory(directoryPath);
}

Future<File> getFile(List<String> path, String fileName, String defaultContent) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  if(!(await file.exists())){
    await file.create();
    await file.writeAsString(defaultContent);
  }
  return file;
}

Future<File?> getNullableFile(List<String> path, String fileName) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  if(!(await file.exists())){
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

String extractFileName(String path) {
  return path.replaceAll('\\', '/').split('/').last;
}

String getCurrentTimeString(){
  DateTime now = DateTime.now();
  
  formatter(int num){return num.toString().padLeft(2, '0');}

  return "${now.year}-${formatter(now.month)}-${formatter(now.day)} ${formatter(now.hour)}h${formatter(now.minute)}m${formatter(now.second)}s";
}