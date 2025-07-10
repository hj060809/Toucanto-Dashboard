import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/global_constants.dart';
import 'dart:io';
import 'package:toucanto_dashboard/utils/logic_utils.dart';
import 'package:toucanto_dashboard/page_musics/musics_home_model.dart';

class MusicsHomeViewModel extends ChangeNotifier{
  final MusicsHomeModel _musicsHomeModel = MusicsHomeModel();
}