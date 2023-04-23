import 'dart:ffi';
import 'dart:math';

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
  bool _isPlayingWithFriend = false;
  List<int> tiles = List.filled(9, 0);

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = 'X';
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
        if (_board[row][col] == '' && _isPlayingWithFriend == false) {
          _computerMove();
          _makeComputerMove();
          runAi();
        }
        _checkGameEnd();
      }
    });
  }

  void _computerMove() {
    bool moved = false;
    while (!moved) {
      final int row = Random().nextInt(3);
      final int col = Random().nextInt(3);

      if (_board[row][col] == '') {
        setState(() {
          _board[row][col] = _currentPlayer;
          _currentPlayer = (_currentPlayer == 'O') ? 'X' : 'O';
        });
        moved = true;
      }
    }
  }

  _checkGameEnd() {
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
        _showGameOverDialog(_board[0][col]);
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
    if (_board[2][0] != '' &&
        _board[2][0] == _board[1][1] &&
        _board[1][1] == _board[0][2]) {
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
              Text(message),
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

  void _showOpponentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('choose opponent'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop;
                      setState(() {
                        _isPlayingWithFriend = true;
                        _board = List.generate(
                            3, (_) => List.generate(3, (_) => ""));
                      });
                    },
                    child: const Text('play with friend'),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop;
                        setState(() {
                          _isPlayingWithFriend = false;
                          _board = List.generate(
                              3, (_) => List.generate(3, (_) => ""));
                        });
                      },
                      child: const Text('Play with computer'))
                ],
              ),
            ),
          );
        });
  }

  void _makeComputerMove() {
    // Wait for 1 second to simulate "thinking"
    Future.delayed(Duration(seconds: 1), () {
      // Generate a random number between 0 and 8
      int index = Random().nextInt(9);

      // Check if the cell at the generated index is empty
      if (_board[index ~/ 3][index % 3] == "") {
        setState(() {
          // Make the move on the empty cell
          _board[index ~/ 3][index % 3] = "O";

          // Switch to the other player
          _currentPlayer = "X";
        });
      } else {
        // If the cell is not empty, call this method again to generate a new random index
        _makeComputerMove();
      }
    });
  }

  void runAi() async {
    await Future.delayed(Duration(
      milliseconds: 200,
    ));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }
      var future = [...tiles]..[i] = 2;
      if (isWinning(2, future)) {
        winning = i;
      }
      if (isWinning(1, future)) {
        blocking = i;
      } else {
        normal = i;
      }
      var move = winning ?? blocking ?? normal;

      if (move != null) {
        setState(() {
          tiles[move] = 2;
        });
      }
    }
  }

  bool isWinning(int who, List<int> tiles) {
    if (tiles.length < 9) {
      return false;
    }
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who) ||
        (tiles[6] == who && tiles[4] == who && tiles[2] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _showOpponentDialog,
            child: const Text('Change Opponent'),
          )
        ],
      ),
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
            TextButton(
                onPressed: () {
                  setState(() {
                    _board =
                        List.generate(3, (_) => List.generate(3, (_) => ''));
                  });
                },
                child: const Text('Retry')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop;
                  setState(() {
                    _isPlayingWithFriend = true;
                    _board =
                        List.generate(3, (_) => List.generate(3, (_) => ""));
                  });
                },
                child: const Text('Play with Friend')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop;
                  setState(() {
                    _isPlayingWithFriend = false;
                    _board =
                        List.generate(3, (_) => List.generate(3, (_) => ""));
                  });
                },
                child: const Text('Play with Computer')),
          ],
        ),
      ),
    );
  }
}
