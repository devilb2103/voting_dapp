import 'package:flutter/material.dart';

class mainPage extends StatelessWidget {
  const mainPage({super.key});

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

class leftSide extends StatelessWidget {
  const leftSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.green[400],
      ),
    );
  }
}

class rightSide extends StatelessWidget {
  const rightSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.blue[400],
      ),
    );
  }
}
