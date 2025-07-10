import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/utils/ui_utils.dart';

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  Widget page = MyWidget();

  static const double padding = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AbsoluteSpacer(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconCard(
                  text: '',
                  icon: Icons.view_agenda,
                  onTap: () => setState(() => page = MyWidget()),
                ),
                AbsoluteSpacer(width: 20),
                IconCard(
                  text: '',
                  icon: Icons.view_agenda,
                  onTap: () => setState(() => page = MyWidget()),
                ),
                AbsoluteSpacer(width: 20),
                IconCard(
                  text: '',
                  icon: Icons.view_agenda,
                  onTap: () => setState(() => page = MyWidget()),
                ),
              ]
            ),
          )
        ),
        AbsoluteSpacer(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: page
        ),
      ],
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}