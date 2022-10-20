import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/blockchainVars.dart';
import 'package:web3dart/web3dart.dart';

late Client httpClient;
late Web3Client ethClient;
final myAddress = address;
var myData;

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = "0xfE0a2Ad86B09eC0b246Ec355c6A99A16e0D105F9";
  final contract = DeployedContract(ContractAbi.fromJson(abi, "Vote"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.call(
      contract: contract, function: ethFunction, params: args);
  return result;
}

Future<void> getVotes(String targetAddress) async {
  List<dynamic> result = await query("getVotes", []);
  myData = [int.parse(result[0].toString()), int.parse(result[1].toString())];
  print(myData);
}

Future<String> submit(String functionName, List<dynamic> args) async {
  EthPrivateKey credential = EthPrivateKey.fromHex(
      "c24b664cd22ab4a6fd8f5b772e7a24404a5236cd169d69063c1a5baea051f284");
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
      credential,
      Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          maxGas: 100000),
      chainId: 11155111);
  return result;
}

Future<String> vote(bool team) async {
  String func = team ? "VoteA" : "VoteB";
  var response = await submit(func, []);
  return response;
}

class mainPage extends StatefulWidget {
  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(blockChainUrl, httpClient);
    getVotes(myAddress);
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              child: Text("Pick your side",
                  style: TextStyle(fontSize: 33, color: Colors.grey[800])),
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
  }
}

class leftSide extends StatefulWidget {
  const leftSide({super.key});
  @override
  State<leftSide> createState() => _leftSideState();
}

class _leftSideState extends State<leftSide> {
  int votes = 0;

  voteA() async {
    // await vote(true);
    getVotes(myAddress);
    votes = myData[0];
    // return votes.toString();
  }

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
                      vote(true);
                    });
                  },
                  child: const Text("Vote")),
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
    myData[1] += 1;
    votes = myData[1];
  }

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
                  child: const Text("vote"))
            ]),
      ),
    );
  }
}
