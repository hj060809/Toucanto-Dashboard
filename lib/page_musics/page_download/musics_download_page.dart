import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:toucanto_dashboard/ui_utils.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_view_model.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_dto.dart';

class MusicsDownload extends StatefulWidget {
  const MusicsDownload({super.key});

  @override
  State<MusicsDownload> createState() => _MusicsDownloadState();
}

class _MusicsDownloadState extends State<MusicsDownload> {
  final TextEditingController urlInputController = TextEditingController();

  late FToast fToast;
 
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicsDownloadViewModel>(
      create: (_) => MusicsDownloadViewModel(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text("Download Music", style: basicTitle_Light(fS: 20)),
          ),
          AbsoluteSpacer(height: 10),
          Consumer<MusicsDownloadViewModel>(
            builder: (context, provider, child){
              return URLInputField(
                controller: urlInputController,
                onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : () {
                  int flag = provider.onPressedApplyURL(urlInputController.text);
                  
                  switch(flag){
                    case MusicsDownloadViewModel.URL_APPLY_NOT_FOUND: showWarningToast('URL or Video Not Found', fToast);
                    case MusicsDownloadViewModel.URL_APPLY_DUPLICATED: showWarningToast('Already Registered URL', fToast);
                    case MusicsDownloadViewModel.URL_APPLY_UNKNOWN_ERROR: showWarningToast('Unknown Error: Failed to Apply URL', fToast);
                  }
                  urlInputController.text = '';
                },
              );
            },
          ),
          AbsoluteSpacer(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<MusicsDownloadViewModel>(
                builder: (context, provider, child){
                  return ElevatedButton(
                    onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : provider.onPressedLoadSavedList,
                    child: Text('Load Saved List'),
                  );
                }
              ),
              AbsoluteSpacer(width: 10),
              Consumer<MusicsDownloadViewModel>(
                builder: (context, provider, child){
                  return ElevatedButton(
                    onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : provider.onPressedSelectFile,
                    child: Text('Select File'),
                  );
                }
              ),
              AbsoluteSpacer(width: 10),
              Consumer<MusicsDownloadViewModel>(
                builder: (context, provider, child){
                  return ElevatedButton(
                    onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : provider.clearDownloadables,
                    child: Text('Delete All'),
                  );
                }
              ),
            ],
          ),
          AbsoluteSpacer(height: 15),
          Consumer<MusicsDownloadViewModel>(
            builder: (context, provider, child){
              return DownloadableList(
                downloadableList: provider.downloadables,
                downloadState: provider.downloadingState,
                onDeletePressed: provider.onPressedDeleteDownloadable
              );
            }
          ),
          AbsoluteSpacer(height: 15),
          Row(
            children: [
              Expanded(
                child: Consumer<MusicsDownloadViewModel>(
                  builder: (context, provider, child){
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 24),
                      ),
                      onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : () async {
                        int downloadResultCode = await provider.onPressedDownload();
                        switch(downloadResultCode){
                          case MusicsDownloadViewModel.DOWNLOAD_EMPTY_LIST: showWarningToast('Downloadable Not Found: downloadable list is empty', fToast);
                          case MusicsDownloadViewModel.DOWNLOAD_ERROR_OCCURED: showWarningToast('Error Occured: Somthing is wrong during download process', fToast);
                          case MusicsDownloadViewModel.DOWNLOAD_SUCCESS: showToast("", fToast); // 석세스 
                        }
                      },
                      child: Text('Download'),
                    );
                  }
                ),
              ),
              AbsoluteSpacer(width: 10),
              Consumer<MusicsDownloadViewModel>(
                builder: (context, provider, child){
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      backgroundColor: Color.fromARGB(255, 231, 243, 255),
                      iconColor: Color.fromARGB(255, 16, 136, 255)
                    ),
                    onPressed: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : provider.onPressedSelectExternalStorage,
                    onLongPress: provider.downloadingState != MusicsDownloadViewModel.DOWNLOAD_STATE_NOT_STARTED ? null : provider.onPressedUnSelectExternalStorage,
                    child: Icon(
                      provider.downloadPath == null ? Icons.folder_open : Icons.folder,
                      size: 25
                    ),
                  );
                }
              )
            ],
          ),
        ],
      )
    );
  }
}

class URLInputField extends StatelessWidget {
  const URLInputField({
    Key? key,
    required VoidCallback? onPressed,
    required TextEditingController controller,
  }) :
    _onPressed = onPressed,
    _controller = controller,
    super(key: key);

  final VoidCallback? _onPressed;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Enter URL',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          onPressed: _onPressed,
        ),
      ),
    );
  }
}

class DownloadInCleaning extends StatelessWidget {
  const DownloadInCleaning({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        AbsoluteSpacer(height: 10),
        Text("Cleaning Up...", style: basicText_Light(fS: 15))
      ],
    );
  }
}

class DownloadableList extends StatelessWidget {
  const DownloadableList({
    Key? key,
    required List<Downloadable> downloadableList,
    required int downloadState,
    required Function(int) onDeletePressed
  }) : 
  _downloadableList = downloadableList,
  _downloadState = downloadState,
  _onDeletePressed = onDeletePressed,
  super(key: key);

  final List<Downloadable> _downloadableList;
  final Function(int) _onDeletePressed;
  final int _downloadState;

  Widget buildContent(VideoInfo videoInfo, int i){
    return ListTile(
      leading: videoInfo.thumbNail.thumbNailURL != null ? Image.network(videoInfo.thumbNail.thumbNailURL!) : null,
      title: Text(videoInfo.title),
      subtitle: Text(videoInfo.authorName),
      trailing: (() {
        switch (_downloadableList[i].downloadState) {
          case Downloadable.DOWNLOAD_READY:
            return Icon(Icons.download);
          case Downloadable.DOWNLOADING:
            return CircularProgressIndicator();
          case Downloadable.DOWNLOAD_SUCCESS:
            return Icon(Icons.check);
          case Downloadable.DOWNLOAD_FAIL:
            return Icon(Icons.error);
          default:
            return IconButton(
              onPressed: () => {_onDeletePressed(i)},
              icon: Icon(Icons.delete)
            );
        }
      })(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: max(MediaQuery.of(context).size.height-350, 100), // Trash Code: Should be removed
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: basicTextColor_Light),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _downloadState > MusicsDownloadViewModel.DOWNLOADING ? DownloadInCleaning() : ListView.builder(
        itemCount: _downloadableList.length, // Replace with your data count
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: _downloadableList[index].futureVideoInfo,
            builder: (context, snapshot) {

              if (snapshot.hasData){
                VideoInfo videoInfo = snapshot.data!;
                return buildContent(videoInfo, index);
              } else if (snapshot.hasError){
                return buildContent(VideoInfo.defaultInfo(
                  authorName: "Error: ${snapshot.error.runtimeType}"
                ), index);
              }
              
              return ListTile(
                leading: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          );
        },
      ),
    );
  }
}
//List 내부 삭제 버튼이 로딩으로 바뀌면서 하나하나 돌아가는 방식

/*
import 'dart:io';

void main() async {
  ProcessResult result = await Process.run('external_program', ['arg1', 'arg2']);
  print(result.stdout); // Output from the external program
}
*/