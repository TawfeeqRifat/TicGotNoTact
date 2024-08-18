import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';

 List<Widget> fallingWidgets= <Widget>[];

void addwidgets(int index) {
  int size= Random().nextInt(50)+50;
  double initialOffset = Random().nextDouble() * (0.5 - 0.0) + 0.0;
  double endOffset = Random().nextDouble() * (0.5 - 0.0) + 0.0;
  double angle = Random().nextDouble() * (0.7 - 0.0) +0.0;
  int time = Random().nextInt(10)+5;


  fallingWidgets.insert(index, SlideContainer(
    index: index,
    timeDuration: time,
    icon: Random().nextBool()?
    Icon(Icons.close,
      color: Colors.blue,
      size: size.toDouble(),
    ):
    Icon(Icons.circle_outlined,
      color: Colors.red,
      size: size.toDouble(),
    ),
    initialOffset: initialOffset,
    endOffset: endOffset,
    angle: angle,
  ));


}


class FallingAnimation extends StatefulWidget {
  const FallingAnimation({super.key});


  @override
  State<FallingAnimation> createState() => _FallingAnimationState();
}


class _FallingAnimationState extends State<FallingAnimation> {


  void callMultitpleWidgets(){
    for(int i=0;i<15;i++){
      addwidgets(i);
    }
  }

  @override
  void initState(){
    super.initState();
    callMultitpleWidgets();
  }

  @override
  Widget build(BuildContext context) {

    // Timer timer=Timer(const Duration(seconds: 3), (){
    //   setState(() {
    //       if(fallingWidgets.length<10){
    //         addwidgets();
    //       }
    //       else{
    //         fallingWidgets.remove(1);
    //       }
    //   });
    //   print(fallingWidgets.length);
    // });

    // Timer timer= Timer(const Duration(seconds: 5), (){
    //     addwidgets();
    // };

    return Stack(
        children: [
          ListView(
              children: fallingWidgets
          )
        ],
      );
  }
}



class SlideContainer extends StatefulWidget {
  SlideContainer({super.key, required this.timeDuration, required this.icon, required this.initialOffset, required this.endOffset, required this.angle,required this.index});
  int timeDuration;
  Icon icon;
  double initialOffset;
  double endOffset;
  double angle;
  int index;
  @override
  State<SlideContainer> createState() => _SlideContainerState();
}

class _SlideContainerState extends State<SlideContainer> with SingleTickerProviderStateMixin{


  late final AnimationController _controller= AnimationController(
    duration: Duration(seconds: widget.timeDuration),
    vsync: this,
  )..repeat();

  late final Animation<Offset> _offsetAnimtion= Tween<Offset>(
    begin: Offset(Random().nextBool()?widget.initialOffset:(-widget.initialOffset),-1),
    end: Offset(Random().nextBool()?widget.endOffset:(-widget.endOffset), 15),
  ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear
  ));

  late Timer timer;

  @override
  void dispose(){
    _controller.stop();
    _controller.dispose();
    super.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

    // timer= Timer(Duration(seconds: widget.timeDuration),(){
    //    setState(() {
    //      fallingWidgets.removeAt(widget.index);
    //      addwidgets(widget.index);
    //      print("add widgets");
    //      print(fallingWidgets.length);
    //    });
    //    dispose();
    // });
    return SlideTransition(
        position: _offsetAnimtion,
      child: Transform.rotate(
          angle: widget.angle,
          child: widget.icon,
      )
    );
  }
}
