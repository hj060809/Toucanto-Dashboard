import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/ui_utils.dart';
import 'package:toucanto_dashboard/page_musics/page_apply/musics_apply_view_model.dart';

class MusicsApply extends StatelessWidget {
  const MusicsApply({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicsApplyViewModel>(
      create: (_) => MusicsApplyViewModel(),
      child: Text("Musics Apply Page", style: basicText_Light(fS: 16))
    );
  }
}