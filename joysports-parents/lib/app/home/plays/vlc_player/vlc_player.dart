import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:joysports/app/home/plays/vlc_player/video_data.dart';
import 'package:joysports/app/home/plays/vlc_player/vlc_controller.dart';
import 'package:path_provider/path_provider.dart';

class VlcScreen extends StatefulWidget {
  const VlcScreen({Key? key}) : super(key: key);

  @override
  _VlcScreenState createState() => _VlcScreenState();
}

class _VlcScreenState extends State<VlcScreen> {
  late int selectedVideoIndex;
  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  String videoPath = '';
  String videoName = '';
  final videoItems = {};
  late List<VideoData> listVideos;

  // Future<File> _loadVideoToFs() async {
  //   final videoData = await rootBundle.load('assets/sample.mp4');
  //   final videoBytes = Uint8List.view(videoData.buffer);
  //   var dir = (await getTemporaryDirectory()).path;
  //   var temp = File('$dir/temp.file');
  //   temp.writeAsBytesSync(videoBytes);
  //   return temp;
  // }

  @override
  Future<void> _getData() async {
   listVideos = <VideoData>[];
   await FirebaseFirestore.instance
        .collection('VideoDatas')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((snapShot){
        videoPath = snapShot['path'].toString();
        videoName = snapShot['name'].toString();
        // print(snapShot['name'].toString());
        // print(snapShot['path'].toString());
        // print(snapShot['type'].toString());
         listVideos.add(VideoData(
            name: videoName, path: videoPath, type: VideoType.network));
        print(VideoData);
        print(listVideos.reversed);

      });
    });
  }

//video Screen
  void onData() {

    selectedVideoIndex = 0;

    var initVideo = listVideos[selectedVideoIndex];

    print(initVideo);
    switch (initVideo.type) {
      case VideoType.network:
        _controller = VlcPlayerController.network(
          initVideo.path,
          hwAcc: HwAcc.FULL,
          options: VlcPlayerOptions(
            advanced: VlcAdvancedOptions([
              VlcAdvancedOptions.networkCaching(2000),
            ]),
            subtitle: VlcSubtitleOptions([
              VlcSubtitleOptions.boldStyle(true),
              VlcSubtitleOptions.fontSize(30),
              VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
              VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
              // works only on externally added subtitles
              VlcSubtitleOptions.color(VlcSubtitleColor.navy),
            ]),
            http: VlcHttpOptions([
              VlcHttpOptions.httpReconnect(true),
            ]),
            rtp: VlcRtpOptions([
              VlcRtpOptions.rtpOverRtsp(true),
            ]),
          ),
          autoPlay: true
        );
        break;
      case VideoType.asset:
        _controller = VlcPlayerController.asset(
          initVideo.path,
          options: VlcPlayerOptions(),
        );
        break;
    }

    _controller!.addOnInitListener(() async {
      await _controller!.startRendererScanning();
    });
    _controller!.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
  }

  @override
  void initState() {
    super.initState();

    _getData().then((value) => onData());
    print(_getData);
    print(listVideos);
  }
  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: VlcPlayer(
                  controller: _controller!,
                  aspectRatio: 16 / 9,
                  placeholder: Center(child: CircularProgressIndicator()),
                ),
              ),
              SizedBox(
                height: 130,
                child: VlcPlayerWithControls(
                  key: _key,
                  controller: _controller!,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listVideos.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var video = listVideos[index];
                  IconData iconData;
                  switch (video.type) {
                    case VideoType.network:
                      iconData = Icons.camera;
                      break;
                    // case VideoType.file:
                    //   iconData = Icons.insert_drive_file;
                    //   break;
                    case VideoType.asset:
                      iconData = Icons.all_inbox;
                      break;
                  }
                  return ListTile(
                    dense: true,
                    selected: selectedVideoIndex == index,
                    selectedTileColor: Colors.green[300],
                    leading: Icon(
                      iconData,
                      color: selectedVideoIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      video.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selectedVideoIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      video.path,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selectedVideoIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    onTap: () async {
                      switch (video.type) {
                        case VideoType.network:
                          await _controller!.setMediaFromNetwork(
                            video.path,
                            hwAcc: HwAcc.FULL,
                          );
                          break;
                        // case VideoType.file:
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content:
                        //           Text('Copying file to temporary storage...'),
                        //     ),
                        //   );
                        //   await Future.delayed(Duration(seconds: 1));
                        //   var tempVideo = await _loadVideoToFs();
                        //   print(tempVideo);
                        //   await Future.delayed(Duration(seconds: 1));
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text('Now trying to play...'),
                        //     ),
                        //   );
                        //   await Future.delayed(Duration(seconds: 1));
                        //   if (await tempVideo.exists()) {
                        //     await _controller.setMediaFromFile(tempVideo);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //       content: Text('File load error'),
                        //     ));
                        //   }
                        //   break;
                        case VideoType.asset:
                          await _controller!.setMediaFromAsset(video.path);
                          break;
                      }
                      setState(() {
                        selectedVideoIndex = index;
                      });
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller!.stopRendererScanning();
    await _controller!.dispose();
  }
}
