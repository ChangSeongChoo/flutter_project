import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joysports/app/home/plays/vlc_player/vlc_player.dart';

import 'package:joysports/constants/strings.dart';

// watch database
class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: const Text('영상'),
        ),
        body: VlcScreen()
    );
  }
}



