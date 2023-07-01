import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  static const String player_x = "X";
  static const String player_o = "O";

  late String currntPlayer;
  late bool gameEnd;
  late List<String> places;

  @override
  void initState() {
    initGame();
    super.initState();
  }

  void initGame() {
    currntPlayer = player_x;
    gameEnd = false;
    places = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        title: const Text(
          "X-O Game",
        ),
      ),
      body: Container(
        color: Colors.purple,
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              introUi(),
              bodyOfGame(),
              playAgain(),
            ],
          ),
        )),
      ),
    );
  }

  // title of game :
  introUi() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Let's Start Player X ;)",
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // body of game :
  bodyOfGame() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 0.2,
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, int index) {
          return boxUi(index);
        },
      ),
    );
  }

  boxUi(int index) {
    return InkWell(
      onTap: () {
        // if click more then one :-
        if (gameEnd || places[index].isNotEmpty) {
          return;
        }
        // on click of
        setState(() {
          places[index] = currntPlayer;
          changePlayer();
          checkIfWinning();
          checkIfDraw();
        });
      },
      child: Container(
        color: places[index].isEmpty
            ? Colors.grey
            : places[index] == player_x
                ? Colors.orange
                : Colors.teal,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            places[index],
            style: const TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  changePlayer() {
    if (currntPlayer == player_x) {
      currntPlayer = player_o;
    } else {
      currntPlayer = player_x;
    }
  }

  checkIfWinning() {
    // posiotion winnning
    List<List<int>> winningPositions = [
      [0, 1, 2],
      [0, 3, 6],
      [0, 4, 8],
      [1, 4, 7],
      [2, 4, 6],
      [2, 5, 8],
      [3, 4, 5],
      [6, 7, 8],
    ];

    // all of cases :
    for (var winning in winningPositions) {
      String p0 = places[winning[0]];
      String p1 = places[winning[1]];
      String p2 = places[winning[2]];

      if (p0.isNotEmpty) {
        if (p0 == p1 && p0 == p2) {
          messageGameOver("Player $p0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  messageGameOver(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over :)\n$s",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  playAgain() {
    return InkWell(
      onTap: () {
        setState(() {
          initGame();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.32,
        color: Colors.green,
        child: const Text(
          "Play Again",
          style: TextStyle(
            color: Colors.purple,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  checkIfDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var place in places) {
      if (place.isEmpty) {
        draw = false;
      }
    }

    if (draw) {
      messageGameOver("It's Draw :(");
      gameEnd = true;
    }
  }
}
