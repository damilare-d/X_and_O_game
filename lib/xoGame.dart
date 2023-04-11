import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class XoxoGame extends StatefulWidget {
  const XoxoGame({super.key});

  @override
  State<XoxoGame> createState() => _XoxoGameState();
}

class _XoxoGameState extends State<XoxoGame> {
  List<List<String>> _board = [];
  String _currentPlayer = 'x';

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = 'o';
  }

  _handleTap(int index) {
    setState(() {
      final row = index ~/ 3;
      final col = index % 3;

      if (_board[row][col] == '') {
        setState(() {
          _board[row][col] = _currentPlayer;

          if (_currentPlayer == "X") {
            _currentPlayer = "O";
          } else {
            _currentPlayer = "X";
          }
        });
        _checkGameEnd();
      }
    });
  }

  void _checkGameEnd() {
    bool emptyBoxesExist = false;

    //to check for horizontal wins
    for (int row = 0; row < 3; row++) {
      if (_board[row][0] != '' &&
          _board[row][0] == _board[row][1] &&
          _board[row][1] == _board[row][2]) {
        //the game is run with the player with all three boxes
        _showGameOverDialog(_board[row][0]);
        return;
      }
    }

    //to check for verical wins
    for (int col = 0; col < 3; col++) {
      if (_board[0][col] != '' &&
          _board[0][col] == _board[1][col] &&
          _board[1][col] == _board[2][col]) {
        //the game is run with the player with all three boxes
        _showGameOverDialog(_board[col][0]);
        return;
      }
    }

    //to check for diagonal wins
    if (_board[0][0] != '' &&
        _board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2]) {
      //the game is run with the player with all three boxes
      _showGameOverDialog(_board[0][0]);
      return;
    }
    if (_board[0][2] != '' &&
        _board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][2]) {
      //the game is run with the player with all three boxes
      _showGameOverDialog(_board[0][2]);
      return;
    }

    // to check for empty boxes
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col] == '') {
          emptyBoxesExist = true;
          break;
        }
      }
    }
    //to check if the game is drawn
    if (!emptyBoxesExist) {
      _showGameOverDialog('drawn');
    }
  }

  void _showGameOverDialog(String winner) {
    String message = '';
    if (winner == 'drawn') {
      message = 'Game over! the game is drawn';
    } else {
      message = 'Game over! $winner player wins';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _board =
                          List.generate(3, (_) => List.generate(3, (_) => ''));
                    });
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 150,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Retry'))
          ],
        ),
      ),
    );
  }
}
