import 'dart:math';


import 'package:chess_bot/MainGameModel/FreePlay/chess_board/chess.dart';
import 'package:chess_bot/MainGameModel/FreePlay/chess_board/src/chess_board.dart';
import 'package:chess_bot/MainGameModel/FreePlay/chess_board/src/sd.dart';
import 'package:chess_bot/MainGameModel/FreePlay/chess_control/chess_controller.dart';
import 'package:chess_bot/MainGameModel/FreePlay/util/online_game_utils.dart';
import 'package:chess_bot/MainGameModel/FreePlay/util/utils.dart';
import 'package:chess_bot/MainGameModel/FreePlay/util/widget_utils.dart';
import 'package:chess_bot/MainGameModel/FreePlay/widgets/divider.dart';
import 'package:chess_bot/MainGameModel/FreePlay/widgets/fancy_button.dart';
import 'package:chess_bot/MainGameModel/FreePlay/widgets/fancy_options.dart';
import 'package:chess_bot/MainGameModel/FreePlay/widgets/modal_progress_hud.dart';
import 'package:chess_bot/generated/i18n.dart';
import 'package:chess_bot/main.dart';

import 'package:chess_bot/wholeproject/Dashboard/dashboard.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:chess_bot/MainGameModel/FreePlay/chess_board/src/chess_sub.dart' as chess_sub;



S stringsd;
ChessControllerd _chessControllerd;
OnlineGameControllerd _onlineGameControllerd;
SharedPreferences prefsd;
String uuid;


class CreateTable extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //set fullscreen
    SystemChrome.setEnabledSystemUIOverlays([]);
    //and portrait only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    //create the material app
    return MaterialApp(
      //manage resources first
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //define title etc.
      title: app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomePage> {
  Future<void> _loadEverythingUp() async {
    //load the old game
    await _chessControllerd.loadOldGame();
    //set the king in chess board
    _chessControllerd.setKingInCheckSquare();
    //await prefs
    prefsd = await SharedPreferences.getInstance();
    //load values from prefsd
    //the chess controller has already been set here!
    _chessControllerd.botColor =
        chess_sub.Color.fromInt(prefsd.getInt('bot_colord') ?? 0) ;
    _chessControllerd.whiteSideTowardsUser =
        prefsd.getBool('whiteSideTowardsUser') ?? true;
    _chessControllerd.botBattle = prefsd.getBool('botbattled') ?? false;
    //load user id and if not available create and save one
    uuid = prefsd.getString('uuidd');
    if (uuid == null) {
      uuid =      await PlatformDeviceId.getDeviceId;
      prefsd.setString('uuidd', uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    //set stringsd object
    stringsd ??= S.of(context);
    //init the context singleton object
    ContextSingleton(context);
    //build the chess controller,
    //if needed set context newly
    if (_chessControllerd == null)
      _chessControllerd = ChessControllerd(context);
    else
      _chessControllerd.context = context;
    //create the online game controller if is null
    _onlineGameControllerd ??= OnlineGameControllerd(_chessControllerd);
    //future builder: load old screen and show here on start the loading screen,
    //when the future is finished,
    //with setState show the real scaffold
    //return the view
    return (_chessControllerd.game == null)
        ? FutureBuilder(
      future: _loadEverythingUp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            var error = snapshot.error;
            print('$error');
            return Center(child: Text(stringsd.error));
          }

          return MyHomePageAfterLoading();
        } else {
          return Center(
              child: ModalProgressHUD(
                child: Container(),
                inAsyncCall: true,
              ));
        }
      },
    )
        : MyHomePageAfterLoading();
  }
}

class MyHomePageAfterLoading extends StatefulWidget {
  MyHomePageAfterLoading({Key key}) : super(key: key);

  @override
  _MyHomePageAfterLoadingState createState() => _MyHomePageAfterLoadingState();
}

class _MyHomePageAfterLoadingState extends State<MyHomePageAfterLoading>
    with WidgetsBindingObserver {
  @override
  void initState() {
// prefsd.clear();
    // _chessControllerd?.controller.resetBoard();
    super.initState();
    bot();
    // _chessControllerd.game?.reset();
    //
    //  prefsd.setBool("botd", true);
    //make move if needed
    // _chessControllerd?.makeBotMoveIfRequired();
    addLicenses();
    WidgetsBinding.instance.addObserver(this);
  }
bot() {
  //inverse the bot color and save it
  _chessControllerd.botColor =
      chess_sub.Color.flip(
          _chessControllerd.botColor) ;
  //save value int to prefsd
  // prefsd.setInt('bot_color',
  //     _chessControllerd.botColor.value);
  // //set state, update the views
  // _chessControllerd.makeBotMoveIfRequired();

  setState(() {});
  //make move if needed
}
  @override
  void dispose() {
   // _chessControllerd?.controller.resetBoard();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _chessControllerd.saveOldGame();
        break;
      default:
        break;
    }
  }


  void update() {
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    _chessControllerd.saveOldGame();
    return true;
  }

  void _onAbout() async {
    //show the about dialog
    showAboutDialog(
      context: context,
      applicationVersion: version,
      applicationIcon: Image.asset(
        'res/drawable/ic_launcher.png',
        width: 50,
        height: 50,
      ),
      applicationLegalese: await rootBundle.loadString('res/licenses/this'),
      children: [
        FancyButton(
          onPressed: () => launch(stringsd.privacy_url),
          text: stringsd.privacy_title,
        )
      ],
    );
  }

  void _onWarning() {
    showAnimatedDialog(
        title: stringsd.warning,
        forceCancelText: 'no',
        onDoneText: 'yes',
        icon: Icons.warning,
        onDone: (value) {},
        children: [Image.asset('res/drawable/moo.png')]);
  }

  void _onJoinCode() {
    //dialog to enter a code
    showAnimatedDialog(
        title: stringsd.enter_game_id,
        onDoneText: stringsd.join,
        icon: Icons.transit_enterexit,
        withInputField: true,
        inputFieldHint: stringsd.game_id_ex,
        onDone: (value) {
          _onlineGameControllerd.joinGame(value);
        });
  }

  void _onCreateCode() {

    _chessControllerd.game?.reset();

    //if is currently in a game, this will disconnect from all local games, reset the board and create a firestore document
    showAnimatedDialog(
      title: stringsd.warning,
      text: stringsd.game_reset_join_code_warning,
      onDoneText: stringsd.proceed,
      icon: Icons.warning,
      onDone: (value) {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>bottom()));
        prefsd.setBool("botd",false);
        addLicenses();

        if (value == 'ok') _onlineGameControllerd.finallyCreateGameCode();
        _chessControllerd.controller.resetBoard();
        // _chessControllerd.controller.makeBotMoveIfRequired();

      },
    );
  }

  void _onLeaveOnlineGame() {
    _chessControllerd.game?.reset();
    //show dialog to leave the online game
    showAnimatedDialog(
      title: stringsd.leave_online_game,
      text: stringsd.deleting_as_host_info,
      icon: Icons.warning,
      onDoneText: stringsd.ok,
      onDone: (value) {
        if (value == 'ok') _onlineGameControllerd.leaveGame();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>bottom()));
        _chessControllerd.controller.resetBoard();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //get the available height for the chess board
    double availableHeight = MediaQuery.of(context).size.height - 184.3;
    //set the update method
    _chessControllerd.update = update;
    //set the update method in the online game controller
    _onlineGameControllerd.update = update;
    //the default scaffold
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: ChessControllerd.loadingBotMoves,
        progressIndicator: kIsWeb
            ? Text(
          // stringsd.loading_moves_web
          '',
          style: Theme.of(context).textTheme.subtitle2,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              '',
              // stringsd.moves_done(_chessControllerd.progress),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.brown[50],
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Visibility(
                              visible: !inOnlineGame,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    shape: roundButtonShape,
                                    onPressed: () {
                                      //inverse the bot color and save it
                                      _chessControllerd.botColor =
                                          chess_sub.Color.flip(
                                              _chessControllerd.botColor) ;
                                      //save value int to prefsd
                                      prefsd.setInt('bot_color',
                                          _chessControllerd.botColor.value);
                                      //set state, update the views
                                      setState(() {});
                                      //make move if needed
                                      _chessControllerd.makeBotMoveIfRequired();
                                    },
                                    child: Text(
                                        (_chessControllerd.botColor ==
                                            chess_sub.Color.WHITE)
                                            ? stringsd.white
                                            : stringsd.black,
                                        style:
                                        Theme.of(context).textTheme.button),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  LiteRollingSwitch(
                                    value: (prefsd?.getBool("bot") ?? false),
                                    onChanged: (pos) {
                                      prefsd.setBool("bot", pos);
                                      //make move if needed
                                      _chessControllerd?.makeBotMoveIfRequired();
                                    },
                                    iconOn: Icons.done,
                                    iconOff: Icons.close,
                                    textOff: stringsd.bot_off,
                                    textOn: stringsd.bot_on,
                                    colorOff: Colors.red[800],
                                    colorOn: Colors.green[800],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableText(
                                  // '',
                                  currentGameCode,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                    stringsd.turn_of_x(
                                        (_chessControllerd?.game?.game?.turn ==
                                            chess_sub.Color.BLACK)
                                            ? stringsd.black
                                            : stringsd.white),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                      inherit: true,
                                      color: (_chessControllerd?.game
                                          ?.in_check() ??
                                          false)
                                          ? ((_chessControllerd.game
                                          .inCheckmate(
                                          _chessControllerd.game
                                              .moveCountIsZero()))
                                          ? Colors.purple
                                          : Colors.red)
                                          : Colors.black,
                                    )),
                              ],
                            ),
                          ),
                          Center(
                            // Center is a layout widget. It takes a single child and positions it
                            // in the middle of the parent.
                            child: SafeArea(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:AssetImage("assets/images/chessboard_frame.png")
                                  )
                                ),
                                child: ChessBoard(
                                  boardType: boardTypeFromString(
                                      prefsd.getString('board_styled') ?? 'd'),
                                  size: min(MediaQuery.of(context).size.width,
                                      availableHeight),
                                  onCheckMate: _chessControllerd.onCheckMate,
                                   onDraw: _chessControllerd.onDraw,
                                   onMove: _chessControllerd.onMove,
                                   onCheck: _chessControllerd.onCheck,
                                   chessBoardController:
                                   _chessControllerd.controller,
                                  chess: _chessControllerd.game,
                                  whiteSideTowardsUser:
                                  _chessControllerd.whiteSideTowardsUser,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                // GestureDetector(
                //   onTap: () {
                //     collapseFancyOptions = true;
                //     setState(() {});
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height,
                //     child: Align(
                //       alignment: Alignment.bottomCenter,
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: SingleChildScrollView(
                //               scrollDirection: Axis.horizontal,
                //               child: Row(
                //                 mainAxisSize: MainAxisSize.min,
                //                 crossAxisAlignment: CrossAxisAlignment.end,
                //                 children: [
                //                   FancyOptions(
                //                     up: true,
                //                     rootIcon: Icons.online_prediction,
                //                     rootText: stringsd.online_game_options,
                //                     children: [
                //                       FancyButton(
                //                         onPressed: _onJoinCode,
                //                         text: stringsd.join_code,
                //                         icon: Icons.transit_enterexit,
                //                         animation: FancyButtonAnimation.pulse,
                //                       ),
                //                       FancyButton(
                //
                //                         onPressed: _onCreateCode,
                //                         text: stringsd.create_code,
                //                         icon: Icons.add,
                //                         animation: FancyButtonAnimation.pulse,
                //                       ),
                //                       FancyButton(
                //                         text: stringsd.leave_online_game,
                //                         animation: FancyButtonAnimation.pulse,
                //                         icon: Icons.exit_to_app,
                //                         visible: inOnlineGame,
                //                         onPressed: _onLeaveOnlineGame,
                //                       ),
                //                     ],
                //                   ),
                //                   Divider8(),
                //                   FancyButton(
                //                     visible: !inOnlineGame,
                //                     onPressed: _chessControllerd.undo,
                //                     animation: FancyButtonAnimation.pulse,
                //                     icon: Icons.undo,
                //                     text: stringsd.undo,
                //                   ),
                //                   DividerIfOffline(),
                //                   FancyButton(
                //                     onPressed: _chessControllerd.resetBoard,
                //                     icon: Icons.autorenew,
                //                     text: stringsd.replay,
                //                   ),
                //                   Divider8(),
                //                   FancyButton(
                //                     visible: !inOnlineGame,
                //                     onPressed: _chessControllerd.switchColors,
                //                     icon: Icons.switch_left,
                //                     text: stringsd.switch_colors,
                //                   ),
                //                   DividerIfOffline(),
                //                   FancyButton(
                //                     visible: !inOnlineGame,
                //                     onPressed: _chessControllerd.onSetDepth,
                //                     icon: Icons.upload_rounded,
                //                     animation: FancyButtonAnimation.pulse,
                //                     text: stringsd.difficulty,
                //                   ),
                //                   DividerIfOffline(),
                //                   FancyButton(
                //                     onPressed:
                //                     _chessControllerd.changeBoardStyle,
                //                     icon: Icons.style,
                //                     animation: FancyButtonAnimation.pulse,
                //                     text: stringsd.choose_style,
                //                   ),
                //                   Divider8(),
                //                   FancyButton(
                //                     visible: !inOnlineGame,
                //                     onPressed: _chessControllerd.onFen,
                //                     text: 'fen',
                //                   ),
                //                   DividerIfOffline(),
                //                   Visibility(
                //                     visible: !inOnlineGame,
                //                     child: Container(
                //                       width: 150,
                //                       child: CheckboxListTile(
                //                         shape: roundButtonShape,
                //                         title: Text(stringsd.bot_vs_bot),
                //                         value: _chessControllerd.botBattle,
                //                         onChanged: (value) {
                //                           prefsd.setBool('botbattle', value);
                //                           _chessControllerd.botBattle = value;
                //                           setState(() {});
                //                           //check if has to make bot move
                //                           if (!_chessControllerd
                //                               .makeBotMoveIfRequired()) {
                //                             //since move has not been made, inverse the bot color and retry
                //                             _chessControllerd.botColor =
                //                                 Chess.swap_color(
                //                                     _chessControllerd.botColor);
                //                             _chessControllerd
                //                                 .makeBotMoveIfRequired();
                //                           }
                //                         },
                //                       ),
                //                     ),
                //                   ),
                //                   DividerIfOffline(),
                //                   FancyOptions(
                //                     up: true,
                //                     rootIcon: Icons.devices,
                //                     rootText:
                //                     stringsd.availability_other_devices,
                //                     children: [
                //                       FancyButton(
                //                         onPressed: () =>
                //                             launch(stringsd.playstore_url),
                //                         text: stringsd.android,
                //                         icon: Icons.android,
                //                         animation: FancyButtonAnimation.pulse,
                //                       ),
                //                       FancyButton(
                //                         onPressed: () =>
                //                             launch(stringsd.website_url),
                //                         text: stringsd.web,
                //                         icon: Icons.web,
                //                         animation: FancyButtonAnimation.pulse,
                //                       ),
                //                     ],
                //                   ),
                //                   Divider8(),
                //                   FancyButton(
                //                     onPressed: () =>
                //                     (random.nextInt(80100) == 420)
                //                         ? _onWarning()
                //                         : _onAbout(),
                //                     icon: Icons.info,
                //                     animation: FancyButtonAnimation.pulse,
                //                   ),
                //
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// (_chessControllerd?.game?.game?.turn ==
//     chess_sub.Color.BLACK)
//     ? CircleAvatar(
//   radius: 40,
//           backgroundColor:Colors.black,
//               child: Image.asset("assets/images/crown.png"),
//             ):
//     CircleAvatar(
//       radius: 40,
//         backgroundColor:Colors.white,
//       child: Image.asset("assets/images/crown.png"),
//         ),