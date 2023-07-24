import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class MeeduPlayerFullscreenPage extends StatefulWidget {
  final MeeduPlayerController controller;
  final bool disposePlayer;
  const MeeduPlayerFullscreenPage(
      {Key? key, required this.controller, required this.disposePlayer})
      : super(key: key);
  @override
  State<MeeduPlayerFullscreenPage> createState() =>
      _MeeduPlayerFullscreenPageState();
}

class _MeeduPlayerFullscreenPageState extends State<MeeduPlayerFullscreenPage> {
  Widget _buildBottomDrawer() {
    return BottomDrawer(
      header: Container(),
      body: widget.controller.bottomDrawer ?? Container(),
      headerHeight: 10,
      drawerHeight: 180,
      color: Colors.transparent,
      controller: widget.controller.bottomDrawerController,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 60,
          spreadRadius: 5,
          offset: const Offset(2, -6), // changes position of shadow
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.controller.isInPipMode.value) {
          widget.controller.closePip(context);

          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              MeeduVideoPlayer(
                controller: widget.controller,
              ),
              _buildBottomDrawer(),
            ],
          )),
    );
  }

  @override
  Future<void> dispose() async {
    widget.controller.customDebugPrint("disposed");
    if (widget.disposePlayer) {
      widget.controller.videoPlayerClosed();
    } else {
      widget.controller.onFullscreenClose();
    }

    widget.controller.launchedAsFullScreen = false;
    if (kIsWeb) {
      //FORCE UI REFRESH
      widget.controller.forceUIRefreshAfterFullScreen.value = true;
    }
    // if (kIsWeb) {
    //   print("ON WEB WILL PLAY AFTER CLOSING FULLSCREEN");
    //   widget.controller.pause();
    //   widget.controller.play();
    // }
    super.dispose();
  }
}
