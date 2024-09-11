import 'dart:async';

import 'package:aplayer/player/playing_controls.dart';
import 'package:aplayer/player/position_seek_widget.dart';
import 'package:aplayer/player/songs_selector.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  runApp(
    NeumorphicTheme(
      theme: const NeumorphicThemeData(
        intensity: 0.8,
        lightSource: LightSource.topLeft,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];
  final audios = <Audio>[
    Audio(
      'assets/audios/01_move.mp3',
      //playSpeed: 2.0,
      metas: Metas(
        id: 'Rock',
        title: 'Rock',
        artist: 'Florent Champigny',
        album: 'RockAlbum',
        image: const MetasImage.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Rockstar_Games_Logo.svg/640px-Rockstar_Games_Logo.svg.png'),
      ),
    ),
    Audio(
      'assets/audios/02_down.mp3',
      metas: Metas(
        id: 'Country',
        title: 'Country',
        artist: 'Florent Champigny',
        album: 'CountryAlbum',
        image: const MetasImage.asset('assets/images/country.jpg'),
      ),
    ),
    Audio(
      'assets/audios/03_boom.mp3',
      metas: Metas(
        id: 'Electronics',
        title: 'Electronic',
        artist: 'Florent Champigny',
        album: 'ElectronicAlbum',
        image: const MetasImage.network(
            'https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/12/attachment_68585523.jpg'),
      ),
    ),
    Audio(
      'assets/audios/04_sexy.mp3',
      metas: Metas(
        id: 'Hiphop',
        title: 'HipHop',
        artist: 'Florent Champigny',
        album: 'HipHopAlbum',
        image: const MetasImage.network(
            'https://media.istockphoto.com/id/1358569155/ru/%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F/%D1%80%D1%83%D0%BA%D0%BE%D0%BF%D0%B8%D1%81%D0%BD%D1%8B%D0%B9-%D1%82%D0%B5%D0%BA%D1%81%D1%82-%D1%85%D0%B8%D0%BF-%D1%85%D0%BE%D0%BF-%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F-%D0%BF%D1%80%D0%B8%D0%BD%D1%82-%D0%BD%D0%B0%D1%80%D0%B8%D1%81%D0%BE%D0%B2%D0%B0%D0%BD%D0%BE-%D0%BE%D1%82-%D1%80%D1%83%D0%BA%D0%B8-%D0%B8%D0%B7%D0%BE%D0%BB%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%B0%D1%8F-%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F.jpg?s=612x612&w=0&k=20&c=Eo2Ocv1CZ_ECHV-blLCUuvH0gu1NAH8II3_CACZszsQ='),
      ),
    ),
    Audio(
      'assets/audios/05_joga.mp3',
      metas: Metas(
        id: 'Pop',
        title: 'Pop',
        artist: 'Florent Champigny',
        album: 'PopAlbum',
        image: const MetasImage.network(
            'https://image.shutterstock.com/image-vector/pop-music-text-art-colorful-600w-515538502.jpg'),
      ),
    ),
    Audio(
      'assets/audios/06_like.mp3',
      metas: Metas(
        id: 'Instrumental',
        title: 'Instrumental',
        artist: 'Florent Champigny',
        album: 'InstrumentalAlbum',
        image: const MetasImage.network(
            'https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/12/attachment_68585523.jpg'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

    _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((data) {
      if (kDebugMode) {
        print('playlistAudioFinished : $data');
      }
    }));
    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      if (kDebugMode) {
        print('audioSessionId : $sessionId');
      }
    }));

    openPlayer();
  }

  void openPlayer() async {
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: false,
    );
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    if (kDebugMode) {
      print('dispose');
    }
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      StreamBuilder<Playing?>(
                          stream: _assetsAudioPlayer.current,
                          builder: (context, playing) {
                            if (playing.data != null) {
                              final myAudio = find(
                                  audios, playing.data!.audio.assetAudioPath);
                              if (kDebugMode) {
                                print(playing.data!.audio.assetAudioPath);
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Neumorphic(
                                  style: const NeumorphicStyle(
                                    depth: 8,
                                    surfaceIntensity: 1,
                                    shape: NeumorphicShape.concave,
                                    boxShape: NeumorphicBoxShape.circle(),
                                  ),
                                  child: myAudio.metas.image?.path == null
                                      ? const SizedBox()
                                      : myAudio.metas.image?.type ==
                                              ImageType.network
                                          ? Image.network(
                                              myAudio.metas.image!.path,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.contain,
                                            )
                                          : Image.asset(
                                              myAudio.metas.image!.path,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.contain,
                                            ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                      Align(
                        alignment: Alignment.topRight,
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle(),
                          ),
                          padding: const EdgeInsets.all(18),
                          margin: const EdgeInsets.all(18),
                          onPressed: () {
                            AssetsAudioPlayer.playAndForget(
                                Audio('assets/audios/horn.mp3'));
                          },
                          child: Icon(
                            Icons.add_alert,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _assetsAudioPlayer.builderCurrent(
                      builder: (context, Playing? playing) {
                    return Column(
                      children: <Widget>[
                        _assetsAudioPlayer.builderLoopMode(
                          builder: (context, loopMode) {
                            return PlayerBuilder.isPlaying(
                                player: _assetsAudioPlayer,
                                builder: (context, isPlaying) {
                                  return PlayingControls(
                                    loopMode: loopMode,
                                    isPlaying: isPlaying,
                                    isPlaylist: true,
                                    onStop: () {
                                      _assetsAudioPlayer.stop();
                                    },
                                    toggleLoop: () {
                                      _assetsAudioPlayer.toggleLoop();
                                    },
                                    onPlay: () {
                                      _assetsAudioPlayer.playOrPause();
                                    },
                                    onNext: () {
                                      //_assetsAudioPlayer.forward(Duration(seconds: 10));
                                      _assetsAudioPlayer.next(
                                          keepLoopMode:
                                              true /*keepLoopMode: false*/);
                                    },
                                    onPrevious: () {
                                      _assetsAudioPlayer.previous(
                                          /*keepLoopMode: false*/);
                                    },
                                  );
                                });
                          },
                        ),
                        _assetsAudioPlayer.builderRealtimePlayingInfos(
                            builder: (context, RealtimePlayingInfos? infos) {
                          if (infos == null) {
                            return const SizedBox();
                          }
                          //print('infos: $infos');
                          return Column(
                            children: [
                              PositionSeekWidget(
                                currentPosition: infos.currentPosition,
                                duration: infos.duration,
                                seekTo: (to) {
                                  _assetsAudioPlayer.seek(to);
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer
                                          .seekBy(const Duration(seconds: -10));
                                    },
                                    child: const Text('-10'),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer
                                          .seekBy(const Duration(seconds: 10));
                                    },
                                    child: const Text('+10'),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  _assetsAudioPlayer.builderCurrent(
                      builder: (BuildContext context, Playing? playing) {
                    return SongsSelector(
                      audios: audios,
                      onPlaylistSelected: (myAudios) {
                        _assetsAudioPlayer.open(
                          Playlist(audios: myAudios),
                          showNotification: true,
                          headPhoneStrategy:
                              HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                          audioFocusStrategy: const AudioFocusStrategy.request(
                              resumeAfterInterruption: true),
                        );
                      },
                      onSelected: (myAudio) async {
                        try {
                          await _assetsAudioPlayer.open(
                            myAudio,
                            autoStart: true,
                            showNotification: true,
                            playInBackground: PlayInBackground.enabled,
                            audioFocusStrategy:
                                const AudioFocusStrategy.request(
                                    resumeAfterInterruption: true,
                                    resumeOthersPlayersAfterDone: true),
                            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                            notificationSettings: const NotificationSettings(
                                //seekBarEnabled: false,
                                //stopEnabled: true,
                                //customStopAction: (player){
                                //  player.stop();
                                //}
                                //prevEnabled: false,
                                //customNextAction: (player) {
                                //  print('next');
                                //}
                                //customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
                                //customPauseIcon: AndroidResDrawable(name:'ic_pause_custom'),
                                //customPlayIcon: AndroidResDrawable(name:'ic_play_custom'),
                                ),
                          );
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      playing: playing,
                    );
                  }),
                  /*
                  PlayerBuilder.volume(
                      player: _assetsAudioPlayer,
                      builder: (context, volume) {
                        return VolumeSelector(
                          volume: volume,
                          onChange: (v) {
                            _assetsAudioPlayer.setVolume(v);
                          },
                        );
                      }),
                   */
                  /*
                  PlayerBuilder.forwardRewindSpeed(
                      player: _assetsAudioPlayer,
                      builder: (context, speed) {
                        return ForwardRewindSelector(
                          speed: speed,
                          onChange: (v) {
                            _assetsAudioPlayer.forwardOrRewind(v);
                          },
                        );
                      }),
                   */
                  /*
                  PlayerBuilder.playSpeed(
                      player: _assetsAudioPlayer,
                      builder: (context, playSpeed) {
                        return PlaySpeedSelector(
                          playSpeed: playSpeed,
                          onChange: (v) {
                            _assetsAudioPlayer.setPlaySpeed(v);
                          },
                        );
                      }),
                   */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
