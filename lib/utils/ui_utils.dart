import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:fluttertoast/fluttertoast.dart';

SizedBox AbsoluteSpacer({
  double height = 0,
  double width = 0,
}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Widget TitledBox({
  String title = 'Title',
  double boxHeight = 200,
  double horizontalPadding = 24,
  Widget? child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(title, style: basicTitle_Light(fS: 20)),
      ),
      Divider(),
      Container(
        height: boxHeight,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        child: child,
      ),
    ],
  );
}

Widget IconCard({
  double width = 200,
  double height = 50,
  double iconSize = 20,
  Color color = basicTextColor_Light,
  IconData? icon = Icons.account_balance,
  String text = 'Card',
  double textSize = 16,
  Function()? onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            AbsoluteSpacer(width: 10),
            Text(
              text,
              style: basicTitle_Light(color: color, fS: textSize),
            ),
          ],
        ),
      ),
    ),
  );
}

class CircularProgressIndicatorWithMessage extends StatelessWidget {
  const CircularProgressIndicatorWithMessage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        AbsoluteSpacer(height: 10),
        Text(message, style: basicText_Light(fS: 15)),
      ],
    );
  }
}

void showToast(String message, FToast fToast) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
    ),
    child: Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'NotoSansRegular',
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
  );
}

void showWarningToast(String message, FToast fToast) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
    ),
    child: Text(
      message,
      style: TextStyle(
        color: Colors.red,
        fontFamily: 'NotoSansRegular',
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
  );
}
