import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_view_model.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/utils/ui_utils.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_page.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_page.dart';
import 'package:toucanto_dashboard/page_musics/musics_home_view_model.dart';

class MusicsHome extends StatefulWidget {
  const MusicsHome({super.key});

  @override
  State<MusicsHome> createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsHome> {
  Widget page = MusicDataViewer();

  static const double padding = 24;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicsHomeViewModel>(
      create: (_) => MusicsHomeViewModel(),
      child: Column(
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
                    text: 'Music Data View',
                    icon: Icons.view_agenda,
                    onTap: () => setState(() => page = MusicDataViewer()),
                  ),
                  AbsoluteSpacer(width: 20),
                  IconCard(
                    text: 'Music Download',
                    icon: Icons.download,
                    onTap: () => setState(() => page = MusicsDownload()),
                  ),
                  AbsoluteSpacer(width: 20),
                  IconCard(
                    text: 'Music Upload',
                    icon: Icons.app_registration,
                    onTap: () => setState(() => page = MusicsUpload()),
                  ),
                ],
              ),
            ),
          ),
          AbsoluteSpacer(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: page,
          ),
        ],
      ),
    );
  }
}

Widget MusicSearchBar() {
  return Container(
    height: 30,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text('ID', style: basicText_Light()),
        Text('Title', style: basicText_Light()),
        Text('Artist', style: basicText_Light()),
        Text('Release Date', style: basicText_Light()),
        Text('Language', style: basicText_Light()),
        Text('Genre', style: basicText_Light()),
        Text('Tag', style: basicText_Light()),
        Text('', style: basicText_Light()),
      ],
    ),
  );
}

class MusicDataViewer extends StatelessWidget {
  const MusicDataViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledBox(
      title: 'Music Datas',
      boxHeight: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MusicSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Music ${index + 1}'),
                  subtitle: Text('Artist ${index + 1}'),
                  trailing: Icon(Icons.play_arrow),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
