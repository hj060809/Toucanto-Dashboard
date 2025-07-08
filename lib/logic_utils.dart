import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

Future<File> getFile(List<String> path, String fileName) async {
  Directory dir = await getDirectory(path);
  File file = File("${dir.path}\\$fileName");
  if(await file.exists()){
    await file.create();
  }
  return file;
}

String getCurrentTimeString(){
  DateTime now = DateTime.now();
  
  formatter(int num){return num.toString().padLeft(2, '0');}

  return "${now.year}-${formatter(now.month)}-${formatter(now.day)} ${formatter(now.hour)}h${formatter(now.minute)}m${formatter(now.second)}s";
}