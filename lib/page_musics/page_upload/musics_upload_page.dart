import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/ui_utils.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_view_model.dart';

class MusicsUpload extends StatelessWidget {
  const MusicsUpload({super.key});

  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    bool isTall = windowHeight > windowWidth;

    return ChangeNotifierProvider<MusicsUploadViewModel>(
      create: (_) => MusicsUploadViewModel(),
      child: Container(
        width: windowWidth,
        height: windowHeight-120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text("Upload To Server", style: basicTitle_Light(fS: 20)),
            ),
            Divider(),
            AbsoluteSpacer(height: 10),
            Expanded(
              child: isTall
                ? Column(
                    children: [
                      Expanded(child: MusicProfile()),
                      AbsoluteSpacer(height: 10),
                      Expanded(child: MusicList()),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: MusicProfile()),
                      AbsoluteSpacer(width: 10),
                      Expanded(child: MusicList()),
                    ],
                  ),
            ),
            AbsoluteSpacer(height: 20),
            SizedBox(
              width: double.infinity,
              child: Consumer<MusicsUploadViewModel>(
                builder: (context, provider, child){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 24),
                    ),
                    onPressed: provider.isUploading ? null : () async {

                    },
                    child: Text('Upload'),
                  );
                }
              ),
            )
          ],
        )
      )
    );
  }
}

class MusicProfile extends StatelessWidget {
  const MusicProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        
      )
    );
  }
}

class MusicList extends StatelessWidget {
  const MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: basicTextColor_Light),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column()
    );
  }
}