import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_dto.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/utils/ui_utils.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_view_model.dart';

class MusicsUpload extends StatelessWidget {
  const MusicsUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicsUploadViewModel>(
      create: (_) => MusicsUploadViewModel(),
      child: MusicsUploadInnerProv()
    );
  }
}

class MusicsUploadInnerProv extends StatefulWidget {
  const MusicsUploadInnerProv({super.key});

  @override
  State<MusicsUploadInnerProv> createState() => _MusicsUploadState();
}

class _MusicsUploadState extends State<MusicsUploadInnerProv> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MusicsUploadViewModel>().loadMusic().then((loadFailures){
        if (!_dialogShown && context.mounted && loadFailures.isNotEmpty) {
          showDialog<String>(
            context: context,
            builder: (context) {
              return LoadFailureDialog(loadFailures: loadFailures);
            }
          );
          _dialogShown = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width;
    bool isTall = windowHeight > windowWidth;

    return Container(
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
            child: UploadDashboard(isTall: isTall)
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
                  onPressed: provider.musicState != MusicsUploadViewModel.MUSIC_UPLOAD_PREPARING ? null : () async {

                  },
                  child: Text('Upload'),
                );
              }
            ),
          )
        ],
      )
    );
  }
}

class LoadFailureDialog extends StatelessWidget {
  LoadFailureDialog({
    super.key,
    required Map<String, String> loadFailures
  }): 
  fileNames = loadFailures.keys.toList(),
  reasons = loadFailures.values.toList();
  
  final List<String> fileNames;
  final List<String> reasons;

  Widget buildContent(int index){
    String fileName = fileNames[index];
    String reason = reasons[index];
    return ListTile(
      title: Text(fileName),
      subtitle: Text(reason),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shadowColor: Color.fromARGB(255, 255, 126, 126),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width-300,
        height: MediaQuery.of(context).size.height-300,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Load Failed", style: basicTitle_Light(fS: 20)),
              Divider(),
              AbsoluteSpacer(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height-400,
                child: ListView.builder(
                  itemCount: fileNames.length,
                  itemBuilder: (context, index){
                    return buildContent(index);
                  }
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class UploadDashboard extends StatefulWidget {
  const UploadDashboard({
    super.key,
    required this.isTall
  });

  final bool isTall;

  @override
  State<UploadDashboard> createState() => _UploadDashboardState();
}

class _UploadDashboardState extends State<UploadDashboard> {
  int? selected;
  int? hovered;

  int? getSelected(){return selected;}
  int? getHovered(){return hovered;}

  void setHovered(int? h){setState(() {
    hovered = h;
  });}
  void setSelected(int? s){setState(() {
    selected = s;
  });}
  
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.isTall ? Axis.vertical : Axis.horizontal,
      children: [
        Expanded(child: Consumer<MusicsUploadViewModel>(
          builder: (context, provider, child){
            return selected == null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                AbsoluteSpacer(height: 10),
                Text("No Music Selected")
              ],
            )
            : MusicProfile(
              musicInfo: provider.musicInfos[selected!],
            );
          }
        )),
        AbsoluteSpacer(height: 10),
        Expanded(child: Consumer<MusicsUploadViewModel>(
          builder: (context, provider, child){
            return MusicList(
              musicInfoList: provider.musicInfos,
              musicState: provider.musicState,
              setHovered: setHovered,
              setSelected: setSelected,
              getHovered: getHovered,
              getSelected: getSelected,
              onDeletePressed: (int index){
                provider.onMusicDeletePressed(index);
                if(provider.musicInfos.isEmpty){
                  setSelected(null);
                } else if(selected != null && selected! > provider.musicInfos.length-1){
                  setSelected(selected!-1);
                }
              },
            );
          }
        )),
      ]
    );
  }
}

class MusicProfile extends StatelessWidget {
  const MusicProfile({
    super.key,
    required MusicInfo musicInfo
  })
  :_musicInfo = musicInfo;

  final MusicInfo _musicInfo;

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
  const MusicList({
    super.key,
    required List<MusicInfo> musicInfoList,
    required int musicState,
    required this.setSelected,
    required this.setHovered,
    required this.getSelected,
    required this.getHovered,
    required Function(int) onDeletePressed
  }) : 
  _musicInfoList = musicInfoList,
  _musicState = musicState,
  _onDeletePressed = onDeletePressed;

  final List<MusicInfo> _musicInfoList;
  final int _musicState;

  final Function(int) _onDeletePressed;

  final ValueSetter<int?> setSelected;
  final ValueSetter<int?> setHovered;
  final ValueGetter<int?> getSelected;
  final ValueGetter<int?> getHovered;

  Widget buildContent(int i){
    MusicInfo musicInfo = _musicInfoList[i];
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: musicInfo.identifier.duplicatedMusics.isNotEmpty
          ? Icon(Icons.warning, color: Colors.red)
          : Image.network(musicInfo.profileImage == null ? musicInfo.identifier.thumbnailURL : musicInfo.profileImage!.imagePath)
      ),
      title: Text(musicInfo.title == null ? musicInfo.fileName : musicInfo.title!, overflow: TextOverflow.ellipsis),
      subtitle: Text(musicInfo.artist == null ? musicInfo.identifier.uploader : musicInfo.artist!.name, overflow: TextOverflow.ellipsis),
      hoverColor: Color.fromARGB(25, 177, 177, 177),
      selectedTileColor: Color.fromARGB(50, 124, 255, 142),
      shape: RoundedRectangleBorder( // hover랑 select랑 붙어 있을 때 borderRadius도 붙임
        borderRadius: (){
          if(getSelected() == null || getHovered() == null){return BorderRadius.circular(10);}
          for(int term in [getSelected()!-i, getHovered()!-i]){
            switch(term){
              case 1: return BorderRadius.vertical(top: Radius.circular(10));
              case -1: return BorderRadius.vertical(bottom: Radius.circular(10));
            }
          }
          return BorderRadius.circular(10);
        }()
      ),
      selected: getSelected() == i,
      onTap: (){
        if(getSelected() == i){
          setSelected(null);
        } else {
          setSelected(i);
        }
      },
      trailing: (){
        switch(musicInfo.uploadState){
          case MusicsUploadViewModel.UPLOADING: return CircularProgressIndicator();
          case MusicsUploadViewModel.UPLOAD_SUCCESS: return Icon(Icons.check);
          case MusicsUploadViewModel.UPLOAD_FAIL: return Icon(Icons.warning);
          default: return IconButton(
            onPressed: () => {_onDeletePressed(i)},
            icon: Icon(Icons.delete)
          );
        }
      }()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: basicTextColor_Light),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _musicState == MusicsUploadViewModel.MUSIC_LOADING
      ? CircularProgressIndicatorWithMessage(message: "Loading...")
      : ListView.builder(
        itemCount: _musicInfoList.length, // Replace with your data count
        itemBuilder: (context, index) {
          return FocusableActionDetector(
            onShowHoverHighlight: (hover) {
              if(hover){
                setHovered(index);
              } else{
                setHovered(null);
              }
            },
            child: buildContent(index)
          );
        }
      )
    );
  }
}

/**
 * 업로드할 대상 음악 체크박스 만들기
 * 삭제시 경고 메시지 출력
 * 그 duplication 처리 어떻게 함
 * => 매번 Supabase DB 전부 받아와서 처리...?
 * => 그럼 또 cache 처리 해줘야 함
 */