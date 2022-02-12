import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VlcPlayerWithControls extends StatefulWidget {
  final VlcPlayerController controller;
  final bool showControls;

  const VlcPlayerWithControls({
    Key? key,
    required this.controller,
    this.showControls = true
  }) : assert(controller != null,'You must Provide a vlc controller'),
        super(key: key);

  @override
  VlcPlayerWithControlsState createState() => VlcPlayerWithControlsState();
}

class VlcPlayerWithControlsState extends State<VlcPlayerWithControls> {

  late VlcPlayerController _controller;
  double volumeValue = 50;
  double sliderValue = 0.0;
  String position = '';
  String duration = '';
  bool validPosition = false;

  Future<void> initializePlayer() async {}


  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oPosition != null && oDuration != null) {
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
          "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
          "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
        }
        validPosition = oDuration.compareTo(oPosition) >= 0;
        sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      }

      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Screen Slide Bar
              SizedBox(height: 5),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: Slider(
                  activeColor: Colors.redAccent,
                  inactiveColor: Colors.white70,
                  value: sliderValue,
                  min: 0.0,
                  max: (!validPosition && _controller.value.duration == null)
                      ? 1.0
                      : _controller.value.duration.inSeconds.toDouble(),
                  onChanged: validPosition ? _onSliderPositionChanged : null,
                ),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius:
                            BorderRadius.all(Radius.circular(50))),
                        child: IconButton(
                            onPressed: _togglePlaying,
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_sharp
                                  : Icons.play_arrow_rounded,
                              size: 40,
                            )),
                      ),
                    ),
                    //volume bar
                    SizedBox(
                      height: 10,
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: volumeValue,
                        thumbColor: Colors.green[300],
                        activeColor: Colors.green[300],
                        inactiveColor: Colors.grey[400],
                        onChanged: _setSoundVolume,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  void _setSoundVolume(double value) {
    setState(() {
      volumeValue = value;
    });
    _controller.setVolume(volumeValue.toInt());
  }

  void _togglePlaying() async {
    _controller.value.isPlaying
        ? await _controller.pause()
        : await _controller.play();
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _controller.setTime(sliderValue.toInt() * 1000);
  }

}

