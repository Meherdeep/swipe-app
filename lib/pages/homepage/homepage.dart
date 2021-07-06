import 'dart:async';

import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:swipe_app/controller/session_controller.dart';
import 'package:swipe_app/helper/style.dart';
import 'package:swipe_app/pages/meet/meet.dart';
import 'package:swipe_app/pages/widgets/verticalSpacer.dart';
import 'package:mic_stream/mic_stream.dart';

class HomePage extends StatefulWidget {
  final SessionController controller;
  const HomePage({Key key, this.controller}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double volumeHeight1 = 0;
  double volumeHeight2 = 0;
  double volumeHeight3 = 0;
  double volumeHeight4 = 0;

  StreamSubscription<List<int>> listener;

  @override
  void initState() {
    super.initState();
    widget.controller.startVideoPreview();
    volumeListener();
    // widget.controller.createClient();
    widget.controller.matchUserInterests();
  }

  @override
  void dispose() {
    listener?.cancel();
    volumeHeight1 = 0;
    volumeHeight2 = 0;
    volumeHeight3 = 0;
    volumeHeight4 = 0;
    widget.controller.stopVideoPreview();
    super.dispose();
  }

  void volumeListener() async {
    // Init a new Stream
    Stream<List<int>> stream = await MicStream.microphone(sampleRate: 44100);

    // Start listening to the stream
    listener = stream.listen((samples) {
      double tempVolume1 = 0;
      double tempVolume2 = 0;
      double tempVolume3 = 0;
      setState(() {
        tempVolume1 = volumeHeight1;
        volumeHeight1 = samples[0].toDouble();
        tempVolume2 = volumeHeight2;
        volumeHeight2 = tempVolume1;
        tempVolume3 = volumeHeight3;
        volumeHeight3 = tempVolume2;
        volumeHeight4 = tempVolume3;
      });
    });
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());
    return list;
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  @override
  Widget build(BuildContext context) {
    final views = _getRenderViews();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Don\'t forget to smile',
                          style: bigHeadingStyle,
                        ),
                        VerticalSpacer(
                          percentage: 0.01,
                        ),
                        Text(
                          'Check your camera and microphone before joining.',
                          style: smallHeadingStyle,
                        )
                      ],
                    ),
                  ),
                  VerticalSpacer(percentage: 0.07),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[_videoView(views[0])],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: AudioWave(
                            width: 50,
                            spacing: 5,
                            bars: [
                              AudioWaveBar(
                                height: volumeHeight1 / 3,
                                color: Colors.lightBlueAccent,
                              ),
                              AudioWaveBar(
                                height: volumeHeight2 / 3,
                                color: Colors.blue,
                              ),
                              AudioWaveBar(
                                height: volumeHeight3 / 3,
                                color: Colors.black,
                              ),
                              AudioWaveBar(
                                height: volumeHeight4 / 3,
                                color: Colors.red,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.16,
                child: RawMaterialButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetPage(controller: widget.controller),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Join',
                      textAlign: TextAlign.center,
                      style: defaultButtonTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
