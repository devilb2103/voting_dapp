import 'package:flutter/material.dart';

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              child: Text("Pick your side",
                  style: TextStyle(fontSize: 33, color: Colors.grey[800])),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: leftSide(),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: rightSide(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class leftSide extends StatefulWidget {
  const leftSide({super.key});

  @override
  State<leftSide> createState() => _leftSideState();
}

class _leftSideState extends State<leftSide> {
  int votes = 0;
  void voteA() {
    votes += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.green[400],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'votes: ${votes}',
                style: TextStyle(fontSize: 21, color: Colors.grey[800]),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    setState(() {
                      voteA();
                    });
                  },
                  child: Text("Vote")),
            ]),
      ),
    );
  }
}

class rightSide extends StatefulWidget {
  const rightSide({super.key});

  @override
  State<rightSide> createState() => _rightSideState();
}

class _rightSideState extends State<rightSide> {
  int votes = 0;
  void voteB() {
    votes += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.blue[400],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'votes: ${votes}',
                style: TextStyle(fontSize: 21, color: Colors.grey[800]),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () => {
                        setState(() {
                          voteB();
                        })
                      },
                  child: Text("vote"))
            ]),
      ),
    );
  }
}
