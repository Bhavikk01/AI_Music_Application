// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/app/utils/ai_util.dart';

import '../../models/music.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<MyMusic> musics = [];
  late MyMusic _selectedMusic;
  late Color _selectedColor;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    fetchAllMusics();
    setUpAlan();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == AudioPlayerState.PLAYING){
        _isPlaying = true;
      }else{
        _isPlaying = false;
      }
    });
    super.initState();
  }

  setUpAlan(){
    AlanVoice.addButton(
        "766636234342b5d332a97ad92d5476432e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT
    );
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response['command']) {
      case 'play':
        _playMusic(_selectedMusic.url);
        break;

      case 'play_channel':
        final id = response['id'];
        // _audioPlayer.pause();
        MyMusic newRadio = musics.firstWhere((element) => element.id == id);
        musics.remove(newRadio);
        musics.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;

      case 'stop':
        _audioPlayer.stop();
        break;
      case 'next':
        final index = _selectedMusic.id;
        MyMusic newRadio;
        if (index + 1 > musics.length) {
          newRadio = musics.firstWhere((element) => element.id == 1);
          musics.remove(newRadio);
          musics.insert(0, newRadio);
        } else {
          newRadio = musics.firstWhere((element) => element.id == index + 1);
          musics.remove(newRadio);
          musics.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;

      case 'prev':
        final index = _selectedMusic.id;
        MyMusic newRadio;
        if (index - 1 <= 0) {
          newRadio = musics.firstWhere((element) => element.id == 1);
          musics.remove(newRadio);
          musics.insert(0, newRadio);
        } else {
          newRadio = musics.firstWhere((element) => element.id == index - 1);
          musics.remove(newRadio);
          musics.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      default:
        log('Command was ${response['command']}');
        break;
    }
  }

  fetchAllMusics() async {
    final musicJson = await rootBundle.loadString('assets/music.json');
    musics = MyMusicList.fromJson(musicJson).musics;
    _selectedMusic = musics[0];
    _selectedColor = Color(int.tryParse(_selectedMusic.color)!);
    setState((){});
  }

  _playMusic(String url){
    _audioPlayer.play(url);
    _selectedMusic = musics.firstWhere((element) => element.url == url);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Container(
              color: _selectedColor,
              child: [
              100.heightBox,
              'All Channels'.text.xl.white.semiBold.make().px16(),
              20.heightBox,
              ListView(
                padding: Vx.m0,
                shrinkWrap: true,
                children: musics
                    .map((e) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(e.icon),
                  ),
                  title: '${e.name} Music'.text.white.make(),
                  subtitle: e.tagline.text.white.make(),
                ))
                    .toList(),
              ).expand()
              ].vStack(crossAlignment: CrossAxisAlignment.start),
          ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                  LinearGradient(
                      colors: [
                        AIColors.primaryColor2,
                        _selectedColor,
                      ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
              ).make(),
          AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'AI Power music',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white
                ),
            ),
          ),
          VxSwiper.builder(
            itemCount: musics.length,
            aspectRatio: context.mdWindowSize == MobileWindowSize.xsmall
                ? 1.0
                : context.mdWindowSize == MobileWindowSize.medium
                    ? 2.0
                    : 3.0,
            enlargeCenterPage: true,
            onPageChanged: (index){
              _selectedMusic = musics[index];
              final colorHex = musics[index].color;
              _selectedColor = Color(int.tryParse(colorHex)!);
              setState((){});
            },
            itemBuilder: (context, index){
                final music = musics[index];
                return VxBox(
                    child: ZStack(
                      [
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(
                            child:
                            music.category.text.uppercase.white.make().px16(),
                          )
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 10.0)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              music.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              music.tagline.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              const Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              'Double tap to play'.text.gray300.make(),
                            ].vStack())
                      ],
                    )
                ).clip(Clip.antiAlias)
                    .bgImage(
                    DecorationImage(
                        image: NetworkImage(music.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        )
                    )
                  ).border(color: Colors.black, width: 5.0)
                    .withRounded(value: 60)
                    .make()
                    .onInkDoubleTap(() {
                      _playMusic(music.url);

                    }).p16();
            },
          ).centered(),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              _isPlaying
                  ? 'Playing Now - ${_selectedMusic.name}'.text.makeCentered()
                  : ''.text.makeCentered(),
              Icon(
              _isPlaying
                  ? CupertinoIcons.stop_circle
                  : CupertinoIcons.play_circle,
              color: Colors.white,
              size: 50,
            ).onInkTap(() {
              if(_isPlaying){
                _audioPlayer.stop();
              }else{
                _playMusic(_selectedMusic.url);
              }
            })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12),

        ],
      ),
    );
  }
}
