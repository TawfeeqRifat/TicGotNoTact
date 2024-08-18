import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:ticgotnotact/Animations/FallAnimation.dart';

import '../Animations/custom.dart';

Color backGround=Colors.white.withOpacity(0.95);

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: Stack(
        children: [
           FallingAnimation(),


          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: SeeThroughText(
                  text: 'TIC GOT NO TACT',
                  fontSize: 90,
                  opacity: 0.9,
                )
              ),
              const SizedBox(height: 100,),

              //play button
              Padding(padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/GameWindow');
                  },
                  child: CustomPaint(
                    painter: customShape(),
                    child: const SizedBox(
                      height: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SeeThroughText(
                              text: 'PLAY',
                              fontSize: 60.0,
                              opacity: 0.7,
                            ),
                            SizedBox(width: 40,),
                          ],
                        )
                      )
                    ),
                  ),
                )
              ),
              const SizedBox(height:30,),

              //exit button
              Padding(padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: ()=> exit(0),
                    child: Transform.flip(
                      flipX: true,
                      child: CustomPaint(
                        painter: customShape(),
                        child: SizedBox(
                            height: 100,
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Transform.flip(
                                      flipX: true,
                                      child: const SeeThroughText(
                                        text: 'EXIT',
                                        fontSize: 60.0,
                                        opacity: 0.7,
                                      ),
                                    ),
                                    const SizedBox(width: 40,),
                                  ],
                                )
                            )
                        ),
                      ),
                    ),
                  )
              ),

            ],
          ),
        ],
      ),

    );
  }
}

class SeeThroughText extends StatelessWidget {
  const SeeThroughText({super.key,required this.text,this.opacity,required this.fontSize});
  final String text;
  final double? opacity;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity?? 0.9,
      child: Stack(
          children: [
            Text(text,
              style: GoogleFonts.signikaNegative(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: backGround,
                  shadows: [
                    const Shadow( // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.black,
                    ),
                    const Shadow( // bottomRight
                        offset: Offset(1.5, -1.5),
                        color: Colors.black
                    ),
                    const Shadow( // topRight
                        offset: Offset(1.5, 1.5),
                        color: Colors.black
                    ),
                    const Shadow( // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.black,
                    ),
                  ]
              ),
              textAlign: TextAlign.center,

            ),
          ]
      ),
    );
  }
}
