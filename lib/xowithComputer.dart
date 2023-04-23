import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class XoWithComputer extends StatefulWidget {
  const XoWithComputer({super.key});

  @override
  State<XoWithComputer> createState() => _XoWithComputerState();
}

List<int> tiles = List.filled(9, 0);

class _XoWithComputerState extends State<XoWithComputer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(children: [
        AspectRatio(
          aspectRatio: 1,
          child: GridView.count(
            //this should create a grid view of cross axis count of 3
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < 9; i++)
                InkWell(
                    onTap: () {
                      setState(() {
                        tiles[i] = 1;
                        runAi();
                      });
                    },
                    // the text shows 0 when i is zero and x when it is one
                    child: Center(
                      child: Icon(
                        tiles[i] == 0
                            ? Icons.radio_button_unchecked_outlined
                            : tiles[i] == 1
                                ? Icons.close
                                : Icons.circle,
                        size: 80.0,
                        color: tiles[i] == 2 ? Colors.blue : Colors.red,
                      ),
                    )),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
                isWinning(1, tiles)
                    ? 'You Won'
                    : isWinning(2, tiles)
                        ? 'You Lost'
                        : 'Your move',
                style: const TextStyle(fontSize: 20.0)),
            //if the human is winning it gives you won and
            //if the computer is winning it sa
            TextButton(
                onPressed: () {
                  setState(() {
                    tiles = List.filled(9, 0);
                  });
                },
                child: const Text('Retry'))
          ],
        )
      ]),
    );
  }

  void runAi() async {
    //to make the game more game alike
    await Future.delayed(Duration(
      milliseconds: 200,
    ));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++)
    //the ai goes through all the tiles and
    //constructs
    {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }
      var future = [...tiles]..[i] = 2;
      //so the var future takes in all the value of the
      // tiles and sets i to 2, that means it plays on the seconf move
      //
      if (isWinning(2, future)) {
        //then the if statement checks if it is
        // winning on its move it should play it
        winning = i;
      }
      if (isWinning(1, future)) {
        //if the opponent is winning on the next move
        //the computer should block it
        blocking = i;
      }
      normal = i;
    }
    var move = winning ?? blocking ?? normal;

    if (move != null) {
      //if winning is not null then try blocking and if not try normal
      //if there is a move to play then play it
      setState(() {
        tiles[move] = 2;
      });
    }
  }
}

// It waits for 200 milliseconds using the Future.delayed function.
// It initializes three integer variables named winning, blocking, and normal to null.
// It loops through each of the nine tiles in the tiles list.
// For each tile, it checks if the value is greater than 0.
// If it is, it means that the tile has already been played, so it skips to the next tile.
// It creates a new list named future that is a copy of the tiles list using the spread operator (...),
// and sets the value of the tile at index i to 2.
// It checks if the new list future represents a winning move for the AI player (whose value is 2).
// If it is, it sets the winning variable to the index of the tile.
// It checks if the new list future represents a blocking move for the human player (whose value is 1).
// If it is, it sets the blocking variable to the index of the tile.
// If there is no winning move for the AI, it sets the normal variable to the index of the tile.

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
