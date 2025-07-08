import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:flutter/material.dart';

TextStyle basicTitle_Light({
  double fS = 24,
  Color? color = basicTextColor_Light,
  TextDecoration? decoration}
){
  return TextStyle(
    fontSize: fS,
    color: color,
    fontFamily: 'NotoSansBold',
    decoration: decoration,
  );
}

TextStyle basicInvertedTitle_Light({
  double fS = 24,
  Color? color = basicInvertedTextColor_Light,
  TextDecoration? decoration}
){
  return TextStyle(
    fontSize: fS,
    color: color,
    fontFamily: 'NotoSansBold',
    decoration: decoration,
  );
}

TextStyle basicText_Light({
  double fS = 14,
  Color? color = basicTextColor_Light,
  TextDecoration? decoration}
){
  return TextStyle(
    fontSize: fS,
    color: color,
    fontFamily: 'NotoSansRegular',
    decoration: decoration,
  );
}