import 'package:flutter/cupertino.dart';

int n=3;
List<int> N1=[0,1,2,3];

bool checkWinner(int x,int y,List<List<int>> board){
  int move=board[x][y];
  List<int> check=[0,0,0,0];
  bool isWon=false;
  for(int i=1;i<=3;i++){
    //column checking
    if(board[i][y]==move){
      check[0]++;
    }
    //row checking
    if(board[x][i]==move){
      check[1]++;
    }
    // diagonal-\ checking
    if(x==y){
      if(board[i][i]==move){
        check[2]++;
      }
    }
  }

  //diagonal -/ checking
  for(int i=1,j=3;i<4;i++,j--){
    if(j>0) {
      if (board[i][j] == move) {
        check[3]++;
      }
    }
  }
  debugPrint('\n');

  for(int i=0;i<=3;i++){
    if(check[i]==3){
      debugPrint('\n\nThe Winner is $move');
      isWon=true;
    }
  }
  return isWon;
}

