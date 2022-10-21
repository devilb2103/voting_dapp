import 'package:flutter/material.dart';
import 'package:voting_dapp/Controller/votes_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

final VotesController con = VotesController();

class _MainPageState extends State<MainPage> {
  // final VotesController con = VotesController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: con.readVotes(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Text("Pick your side",
                          style:
                              TextStyle(fontSize: 33, color: Colors.grey[800])),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: const [
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
          } else {
            return Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    const CircularProgressIndicator(),
                    Expanded(child: Container())
                  ],
                ));
          }
        });
  }
}

class leftSide extends StatefulWidget {
  const leftSide({super.key});
  @override
  State<leftSide> createState() => _leftSideState();
}

class _leftSideState extends State<leftSide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.green[400],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'votes: ${con.myData[0]}',
                style: TextStyle(fontSize: 21, color: Colors.grey[800]),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () async {
                    setState(() {});
                    await con.voteA().then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text("Vote")),
              !con.canVote
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator())
                  : Container(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.blue[400],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'votes: ${con.myData[1]}',
                style: TextStyle(fontSize: 21, color: Colors.grey[800]),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () async {
                    setState(() {});
                    await con.voteB().then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text("vote")),
              !con.canVote
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator())
                  : Container(),
            ]),
      ),
    );
  }
}
