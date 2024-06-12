import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_animation/drawing_animation.dart';

import 'package:ticgotnotact/pages/mainMenu.dart';

import '../functionality.dart';
import 'mainMenu.dart';

class GameWindow extends StatefulWidget {
  const GameWindow({super.key});

  @override
  State<GameWindow> createState() => _GameWindowState();
}

class _GameWindowState extends State<GameWindow> with TickerProviderStateMixin{

  //mechanic
  int noOfMoves=0;
  int whichPlayer =1;
  List<List<int>> board=[[],[0,0,0,0],[0,0,0,0],[0,0,0,0],];

  //design
  double tileSize=100;
  double borderWidth=3;
  Color backgroundColor = backGround;
  Color tileBorderColor= Colors.black;
  Color player1Color = Colors.blue;
  Color player2Color = Colors.red;
  late List<Color> playerColor;
  late Icon xIcon;
  late Icon oIcon;

  //animation async function
  Future<void> triggerErrorAnimation() async {
    _errorController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _errorController.reverse();
  }
  Future<void> triggerTurnIndicatorAnimation(Size systemSize) async {
    //for turn indicator animation
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Center(
          child: RotationTransition(
            turns: Tween(
              begin: 0.0,
              end: 0.5,
            ).animate(CurvedAnimation(
              parent: _turnIndicatorController,
              curve: Curves.slowMiddle,
            )),
            child: Transform.translate(
              offset:   const Offset(0,-100),
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                    height: 120,
                    width: (systemSize.height*2)??1000,
                    decoration: BoxDecoration(
                      color: playerColor[whichPlayer],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 300),
                              child: Text('Player$whichPlayer ',
                                style: GoogleFonts.signikaNegative(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 50,
                                ),
                                //textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
        ),
      );
    });

    await _turnIndicatorController.forward(from: 0.0);

    Navigator.pop(context);
    _turnIndicatorController.reset();
  }

  late AnimationController _errorController;
  late Animation<Color?> errorAnimation;

  late AnimationController _turnIndicatorController;
  late AnimationController _winnerAnimation1;
  late AnimationController _winnerAnimation2;
  late AnimationController _winnerAnimation3;

  late final Animation<Offset> _winnerAnimation1Offest = Tween<Offset>(
    begin: Offset(-1.0,0),
    end: Offset(1.0,0.0)
  ).animate(
    CurvedAnimation(
        parent: _winnerAnimation1,
        curve: Curves.easeInCirc
    )
  );
  late final Animation<Offset> _winnerAnimation2Offest = Tween<Offset>(
      begin: Offset(1.0,0),
      end: Offset(-1.0,0.0)
  ).animate(
      CurvedAnimation(
          parent: _winnerAnimation1,
          curve: Curves.slowMiddle
      )
  );
  Future<void> announcementAnimation(Size systemSize,String announcementMessage,String flashMessage) async {
    //first slide
    showDialog(context: context,
        builder: (ContextBuilder){
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Stack(
                children: [
                  SlideTransition(
                    position: _winnerAnimation1Offest,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Center(
                        child: Container(
                          height: 100,
                          width: systemSize.width*2,
                          color: playerColor[whichPlayer],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: systemSize.height/2- 35,
                      child: SlideTransition(
                        position: _winnerAnimation2Offest,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Center(
                            child: Container(
                              height: 100,
                              width: systemSize.width*2,
                              color: playerColor[whichPlayer],
                              child: DefaultTextStyle(
                                style: TextStyle(),
                                child: Text(
                                  flashMessage,
                                  style: GoogleFonts.signikaNegative(
                                    color: Colors.white,
                                    fontSize: 75,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          );
        }
    );

    _winnerAnimation1.forward();
    await _winnerAnimation2.forward();
    Navigator.pop(context);
    _winnerAnimation1.reset();
    _winnerAnimation2.reset();

    //animation 3
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
            child: RotationTransition(
              turns: Tween(
                begin: 0.0,
                end: -0.015,
              ).animate(_winnerAnimation3),
              child: Container(
                height: systemSize.height/2,
                width: systemSize.width/1.2,
                decoration: BoxDecoration(
                  //color: playerColor[whichPlayer],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                //color: Colors.white,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(0.015),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      DefaultTextStyle(
                        style: const TextStyle(),
                        child: Text(announcementMessage,
                            style: GoogleFonts.signikaNegative(
                              fontSize: 45,
                              color: playerColor[whichPlayer],
                            )
                        ),
                      ),
                      const SizedBox(height: 50,),

                      //play again button
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              whichPlayer=1;
                              noOfMoves=0;
                              for(int i=1;i<=n;i++){
                                for(int j=1;j<=n;j++){
                                  board[i][j]=0;
                                }
                              }
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            height: systemSize.height/15,
                            width: systemSize.width/1.7,
                            decoration: BoxDecoration(
                              color: playerColor[whichPlayer],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: DefaultTextStyle(
                                style: TextStyle(),
                                child: Text('PLAY AGAIN',
                                  style: GoogleFonts.signikaNegative(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 20),

                      //MAinMenu button
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamedAndRemoveUntil(context,'/MainMenu',
                            ModalRoute.withName('/MainMenu'));
                          },
                          child: Container(
                            height: systemSize.height/15,
                            width: systemSize.width/1.7,
                            decoration: BoxDecoration(
                              color: playerColor[whichPlayer],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: DefaultTextStyle(
                                style: TextStyle(),
                                child: Text('MAINMENU',
                                  style: GoogleFonts.signikaNegative(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
    await _winnerAnimation3.forward(from: 0.0);

  }
  @override
  void initState(){
    super.initState();


    playerColor = [Colors.transparent,player1Color,player2Color];
    xIcon= Icon(Icons.close,
      size: tileSize,
      color: playerColor[1],
    );
    oIcon= Icon(Icons.circle_outlined,
      size: tileSize,
      color: playerColor[2],
    );

    //animations
    _errorController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    errorAnimation = ColorTween(
      begin: backgroundColor,
      end: Colors.red.shade400,
    ).animate(_errorController)
      ..addListener(() {
        setState(() {});
      });

    _turnIndicatorController= AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _winnerAnimation1= AnimationController(vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _winnerAnimation2= AnimationController(vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _winnerAnimation3= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
    );

    triggerTurnIndicatorAnimation(Size(1000,1000));
  }

  @override
  Widget build(BuildContext context) {
    Size systemSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: errorAnimation.value,


        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Center(
                  child: Container(
                    height: tileSize*3+borderWidth*2,
                    width: tileSize*3+borderWidth*2,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: tileBorderColor,
                          width: borderWidth,
                        )
                    ),
                    child: Column(
                      children: [
                        for(int i=1;i<=3;i++)
                          Row(
                            children: [
                              for(int j=1;j<=3;j++)
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      if(board[i][j]==0){

                                        //writing player move
                                        board[i][j]= whichPlayer;
                                        noOfMoves++;

                                        //if player won
                                        if(checkWinner(i,j,board)){
                                          debugPrint('\n\nThe Winner is ${board[i][j]}');
                                          //trigger winner animation
                                          announcementAnimation(systemSize,'Player$whichPlayer Won!','TIC TAC TOE');

                                        }

                                        //if game draw
                                        else if(noOfMoves>=9){
                                          announcementAnimation(systemSize, 'Draw!', 'TIC GOT NO TACT');
                                        }
                                        //if a game continues
                                        else{

                                          //change player
                                          whichPlayer=(whichPlayer==1)?2:1;



                                          //triggering that animation
                                          triggerTurnIndicatorAnimation(systemSize);
                                        }
                                      }
                                      //when player selects already selected box
                                      else{
                                        triggerErrorAnimation();
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: tileSize,
                                    width: tileSize,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: tileBorderColor,
                                            width: borderWidth
                                        )
                                    ),
                                    child: (board[i][j]==1)?xIcon:(board[i][j]==2)?oIcon:null,

                                  ),
                                )
                            ],
                          ),

                      ],
                    ),

                  )
              ),

              //player indicator
              Positioned(
                  bottom: systemSize.height/3.6,
                  right: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.rotate(
                        angle: 6,
                        child: Container(
                            height: 40,
                            width: 160,
                            decoration: BoxDecoration(
                              color: playerColor[whichPlayer],

                            ),
                            child: Center(
                                child: Text('Player$whichPlayer ',
                                  style: GoogleFonts.signikaNegative(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 30,
                                  ),
                                )
                            )

                        ),
                      )
                    ],
                  )
              ),

              //pause Button
              Positioned(
                  top: systemSize.height/15,
                  left: systemSize.width/1.18,
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return Center(
                              child: RotationTransition(
                                turns: Tween(
                                  begin: 0.0,
                                  end: -0.015,
                                ).animate(_winnerAnimation3),
                                child: Container(
                                  height: systemSize.height/2,
                                  width: systemSize.width/1.2,
                                  decoration: BoxDecoration(
                                    //color: playerColor[whichPlayer],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  //color: Colors.white,
                                  child: RotationTransition(
                                    turns: const AlwaysStoppedAnimation(0.015),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20,),
                                        DefaultTextStyle(
                                          style: const TextStyle(),
                                          child: Text('PAUSE',
                                              style: GoogleFonts.signikaNegative(
                                                fontSize: 45,
                                                color: playerColor[whichPlayer],
                                                fontWeight: FontWeight.bold
                                              )
                                          ),
                                        ),
                                        const SizedBox(height: 50,),

                                        //continue
                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: systemSize.height/15,
                                              width: systemSize.width/1.7,
                                              decoration: BoxDecoration(
                                                color: playerColor[whichPlayer],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text('CONTINUE',
                                                    style: GoogleFonts.signikaNegative(
                                                      fontSize: 40,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        const SizedBox(height: 20),

                                        //play again button
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                whichPlayer=1;
                                                noOfMoves=0;
                                                for(int i=1;i<=n;i++){
                                                  for(int j=1;j<=n;j++){
                                                    board[i][j]=0;
                                                  }
                                                }
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              height: systemSize.height/15,
                                              width: systemSize.width/1.7,
                                              decoration: BoxDecoration(
                                                color: playerColor[whichPlayer],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text('RESTART',
                                                    style: GoogleFonts.signikaNegative(
                                                      fontSize: 40,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        const SizedBox(height: 20),

                                        //exit button
                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamedAndRemoveUntil(context,'/MainMenu',
                                                  ModalRoute.withName('/MainMenu'));
                                            },
                                            child: Container(
                                              height: systemSize.height/15,
                                              width: systemSize.width/1.7,
                                              decoration: BoxDecoration(
                                                color: playerColor[whichPlayer],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: DefaultTextStyle(
                                                  style: TextStyle(),
                                                  child: Text('MAINMENU',
                                                    style: GoogleFonts.signikaNegative(
                                                      fontSize: 40,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        const SizedBox(height: 20,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                      await _winnerAnimation3.forward(from: 0.0);
                    },
                    child: const Icon(Icons.pause,
                      color: Colors.black54,
                      size: 40,
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}

