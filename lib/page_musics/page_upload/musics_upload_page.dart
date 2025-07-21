import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_dto.dart';
import 'package:toucanto_dashboard/supabase/external_dtos/dto_provider.dart';
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
      child: MusicsUploadInnerProv(),
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
      context
          .read<MusicsUploadViewModel>()
          .setEnums()
          .then((enumState) {
            if (!_dialogShown &&
                enumState == MusicsUploadViewModel.LOAD_FAILED) {
              showDialog<String>(
                context: context,
                builder: (context) {
                  return LoadFailureDialog(
                    loadFailures: {"ENUM": "ENUM_LOAD_FAILED"},
                  );
                },
              );
              _dialogShown = true;
            }
          })
          .then((_) {
            context.read<MusicsUploadViewModel>().setArtists();
          });
      context.read<MusicsUploadViewModel>().loadMusic().then((loadFailures) {
        if (!_dialogShown && context.mounted && loadFailures.isNotEmpty) {
          showDialog<String>(
            context: context,
            builder: (context) {
              return LoadFailureDialog(loadFailures: loadFailures);
            },
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
      height: windowHeight - 120,
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
          Expanded(child: UploadDashboard(isTall: isTall)),
          AbsoluteSpacer(height: 20),
          SizedBox(
            width: double.infinity,
            child: Consumer<MusicsUploadViewModel>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 24),
                  ),
                  onPressed: !provider.allPrepared ? null : () async {},
                  child: Text('Upload'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoadFailureDialog extends StatelessWidget {
  LoadFailureDialog({super.key, required Map<String, String> loadFailures})
    : fileNames = loadFailures.keys.toList(),
      reasons = loadFailures.values.toList();

  final List<String> fileNames;
  final List<String> reasons;

  Widget buildContent(int index) {
    String fileName = fileNames[index];
    String reason = reasons[index];
    return ListTile(title: Text(fileName), subtitle: Text(reason));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shadowColor: Color.fromARGB(255, 255, 126, 126),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 300,
        height: MediaQuery.of(context).size.height - 300,
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
                height: MediaQuery.of(context).size.height - 400,
                child: ListView.builder(
                  itemCount: fileNames.length,
                  itemBuilder: (context, index) {
                    return buildContent(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadDashboard extends StatefulWidget {
  const UploadDashboard({super.key, required this.isTall});

  final bool isTall;

  @override
  State<UploadDashboard> createState() => _UploadDashboardState();
}

class _UploadDashboardState extends State<UploadDashboard> {
  int? selected;
  int? hovered;

  int? getSelected() {
    return selected;
  }

  int? getHovered() {
    return hovered;
  }

  void setHovered(int? h) {
    setState(() {
      hovered = h;
    });
  }

  void setSelected(int? s) {
    setState(() {
      selected = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.isTall ? Axis.vertical : Axis.horizontal,
      children: [
        Expanded(
          child: Consumer<MusicsUploadViewModel>(
            builder: (context, provider, child) {
              return selected == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        AbsoluteSpacer(height: 10),
                        Text("No Music Selected"),
                      ],
                    )
                  : MusicProfile(
                      statefulMusicInfo: provider.statefulMusicInfos[selected!],
                    );
            },
          ),
        ),
        AbsoluteSpacer(height: 10),
        Expanded(
          child: Consumer<MusicsUploadViewModel>(
            builder: (context, provider, child) {
              return MusicList(
                statefulMusicInfoList: provider.statefulMusicInfos,
                allPrepared: provider.allPrepared,
                setHovered: setHovered,
                setSelected: setSelected,
                getHovered: getHovered,
                getSelected: getSelected,
                onDeletePressed: (int index) {
                  provider.onMusicDeletePressed(index);
                  if (provider.statefulMusicInfos.isEmpty) {
                    setSelected(null);
                  } else if (selected != null &&
                      selected! > provider.statefulMusicInfos.length - 1) {
                    setSelected(selected! - 1);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class MusicProfileImageContainer extends StatelessWidget {
  const MusicProfileImageContainer({super.key, required this.profileImage});

  final MusicProfileImage? profileImage;

  @override
  Widget build(BuildContext context) {
    bool isNullProfile = profileImage == null;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        decoration: isNullProfile
            ? BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 146, 146, 146),
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: isNullProfile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  AbsoluteSpacer(height: 5),
                  Text("No Image", style: basicText_Light(fS: 12)),
                ],
              )
            : Image.network(
                fit: BoxFit.cover,
                profileImage!.imagePath,
              ),
      ),
    );
  }
}

class MusicProfileTitleInput extends StatelessWidget {
  const MusicProfileTitleInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: "Enter Title",
          labelStyle: TextStyle(fontSize: 12),
          border: UnderlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, size: 14),
            onPressed: () {
              controller.text = "";
            },
          ),
        ),
      ),
    );
  }
}

class MusicProfileArtistInput extends StatelessWidget {
  const MusicProfileArtistInput({super.key, required this.artists});

  final List<Artist> artists;

  bool compareArtistName(String artName1, String artName2) {
    return artName1
        .toLowerCase()
        .replaceAll(" ", "")
        .contains(artName2.toLowerCase().replaceAll(" ", ""));
  }

  Widget artistSearchfieldViewBuilder(
    context,
    controller,
    focusNode,
    onSubmitted,
  ) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: "Enter Artist",
        labelStyle: TextStyle(fontSize: 12),
        border: UnderlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.close, size: 14),
          onPressed: () {
            controller.text = "";
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Autocomplete<Artist>(
        optionsBuilder: (TextEditingValue textEdit) {
          final searchResult = artists.where(
            (artist) => compareArtistName(artist.name, textEdit.text),
          );
          if (searchResult.isEmpty) {
            return <Artist>[
              Artist(
                name: "+ Add New Artist",
                debutDate: DateTime.now(),
                nationality: null,
              ),
            ];
          }
          return searchResult;
        },
        displayStringForOption: (Artist artist) => artist.name,
        onSelected: (Artist selectedArtist) {
          print('선택됨: ${selectedArtist.name}');
        },
        fieldViewBuilder: artistSearchfieldViewBuilder,
      ),
    );
  }
}

class MusicProfile extends StatefulWidget {
  const MusicProfile({super.key, required this.statefulMusicInfo});

  final StatefulMusicInfo statefulMusicInfo;

  @override
  State<MusicProfile> createState() => _MusicProfileState();
}

class _MusicProfileState extends State<MusicProfile> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final musicInfo = widget.statefulMusicInfo.musicInfo;
    titleController.text = musicInfo.title == null
        ? ""
        : musicInfo.title!;
    artistController.text = musicInfo.artist == null
        ? ""
        : musicInfo.artist!.name;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                MusicProfileImageContainer(
                  profileImage: musicInfo.profileImage,
                ),
                AbsoluteSpacer(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      MusicProfileTitleInput(
                        controller: titleController,
                      ),
                      Consumer<MusicsUploadViewModel>(
                        builder: (context, provier, child) {
                          return MusicProfileArtistInput(
                            artists: provier.artists,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Column()),
        ],
      ),
    );
  }
}

class MusicList extends StatelessWidget {
  const MusicList({
    super.key,
    required List<StatefulMusicInfo> statefulMusicInfoList,
    required bool allPrepared,
    required this.setSelected,
    required this.setHovered,
    required this.getSelected,
    required this.getHovered,
    required Function(int) onDeletePressed,
  }) : _statefulMusicInfoList = statefulMusicInfoList,
       _allPrepared = allPrepared,
       _onDeletePressed = onDeletePressed;

  final List<StatefulMusicInfo> _statefulMusicInfoList;
  final bool _allPrepared;

  final Function(int) _onDeletePressed;

  final ValueSetter<int?> setSelected;
  final ValueSetter<int?> setHovered;
  final ValueGetter<int?> getSelected;
  final ValueGetter<int?> getHovered;

  Widget buildContent(int i) {
    MusicInfo musicInfo = _statefulMusicInfoList[i].musicInfo;
    int uploadState = _statefulMusicInfoList[i].uploadState;
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: musicInfo.identifier.duplicatedMusics.isNotEmpty
            ? Icon(Icons.warning, color: Colors.red)
            : Image.network(
                musicInfo.profileImage == null
                    ? musicInfo.identifier.thumbnailURL
                    : musicInfo.profileImage!.imagePath,
              ),
      ),
      title: Text(
        musicInfo.title == null ? musicInfo.fileName : musicInfo.title!,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        musicInfo.artist == null
            ? musicInfo.identifier.uploader
            : musicInfo.artist!.name,
        overflow: TextOverflow.ellipsis,
      ),
      hoverColor: Color.fromARGB(25, 177, 177, 177),
      selectedTileColor: Color.fromARGB(50, 124, 255, 142),
      shape: RoundedRectangleBorder(
        // hover랑 select랑 붙어 있을 때 borderRadius도 붙임
        borderRadius: () {
          if (getSelected() == null || getHovered() == null) {
            return BorderRadius.circular(10);
          }
          for (int term in [getSelected()! - i, getHovered()! - i]) {
            switch (term) {
              case 1:
                return BorderRadius.vertical(top: Radius.circular(10));
              case -1:
                return BorderRadius.vertical(bottom: Radius.circular(10));
            }
          }
          return BorderRadius.circular(10);
        }(),
      ),
      selected: getSelected() == i,
      onTap: () {
        if (getSelected() == i) {
          setSelected(null);
        } else {
          setSelected(i);
        }
      },
      trailing: () {
        switch (uploadState) {
          case MusicsUploadViewModel.UPLOADING:
            return CircularProgressIndicator();
          case MusicsUploadViewModel.UPLOAD_SUCCESS:
            return Icon(Icons.check);
          case MusicsUploadViewModel.UPLOAD_FAIL:
            return Icon(Icons.warning);
          default:
            return IconButton(
              onPressed: () => {_onDeletePressed(i)},
              icon: Icon(Icons.delete),
            );
        }
      }(),
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
      child: !_allPrepared
          ? CircularProgressIndicatorWithMessage(message: "Loading...")
          : ListView.builder(
              itemCount: _statefulMusicInfoList.length, // Replace with your data count
              itemBuilder: (context, index) {
                return FocusableActionDetector(
                  onShowHoverHighlight: (hover) {
                    if (hover) {
                      setHovered(index);
                    } else {
                      setHovered(null);
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: buildContent(index),
                  ),
                );
              },
            ),
    );
  }
}
