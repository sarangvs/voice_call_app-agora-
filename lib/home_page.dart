import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// const appId = '72c21bd29bec4bb0b4ada9efbf96019d';
// const Token = '00672c21bd29bec4bb0b4ada9efbf96019dIACYYy9SPq0gxa4hUvEocuIddFqZWvrqW7j1YYorWm0FEdJjSIgAAAAAEABLPQ3JuUzmYQEAAQC5TOZh';

const appId = '49e5499cc23247949224b4bbd9bdb201';
const Token = '00649e5499cc23247949224b4bbd9bdb201IABz9kaV/sYuFeTOrxc/55kaw53Xo9cp3WZaezDuOfoHEtJjSIgAAAAAEABLPQ3J0F3mYQEAAQDQXeZh';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(appId);
    var engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess $channel $uid');
          setState(() {
            _joined = true;
          });
        }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }));
    await engine.enableAudio();
    // Join channel with channel name as 123
    await engine.joinChannel(Token, '123', null, 0);
  }

  Future<void> disposePlatformState() async {
    // Get microphone permission
    await [Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(appId);
    var engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess $channel $uid');
          setState(() {
            _joined = true;
          });
        }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }));
    // Join channel with channel name as 123
    await engine.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Home Page"),
        ),
        body: SizedBox(
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text("Hello"),
                    onPressed: (){

                      initPlatformState();
                    },
                  ),
                  TextButton(
                    child: const IconButton(onPressed: null, icon: Icon(Icons.call_end,color: Colors.redAccent,)),
                    onPressed: (){
                      disposePlatformState();

                      // initPlatformState();
                    },
                  ),
                ],
              )
          ),
        ));
  }
}
