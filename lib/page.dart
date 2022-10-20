import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/blockchainVars.dart';
import 'package:web3dart/web3dart.dart';

late Client httpClient;
late Web3Client ethClient;
final myAddress = address;
var myData = [0, 0];
bool canVote = true;

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

Future<List<int>> getVotes(String targetAddress) async {
  List<dynamic> result = await query("getVotes", []);
  myData = [int.parse(result[0].toString()), int.parse(result[1].toString())];
  return myData;
}

Future<void> vote(bool team) async {
  canVote = false;
  Credentials key = EthPrivateKey.fromHex(
      "c24b664cd22ab4a6fd8f5b772e7a24404a5236cd169d69063c1a5baea051f284");

  //obtain our contract from abi in json file
  final contract = await loadContract();

  // extract function from json file
  final function = contract.function(
    team ? "voteA" : "voteB",
  );

  //send transaction using the our private key, function and contract
  await ethClient.sendTransaction(
      key,
      Transaction.callContract(
          contract: contract, function: function, parameters: []),
      chainId: 11155111);
  // ScaffoldMessenger.of(context).removeCurrentSnackBar();
  // snackBar(label: "verifying vote");
  //set a 20 seconds delay to allow the transaction to be verified before trying to retrieve the balance
  // Future.delayed(const Duration(seconds: 20), () {
  //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
  //   snackBar(label: "retrieving votes");
  //   getTotalVotes();

  //   ScaffoldMessenger.of(context).clearSnackBars();
  // });
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
  int votes = myData[0];

  Future VoteA() async {
    if (!canVote) return;
    setState(() {
      canVote = false;
    });

    await vote(true);
    Future.delayed(Duration(seconds: 20), () async {
      var data = await getVotes(myAddress);
      votes = data[0];
      print(data);

      setState(() {
        canVote = true;
      });
    });
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
                  onPressed: canVote
                      ? () async {
                          await VoteA();
                        }
                      : null,
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
  Future VoteB() async {
    if (!canVote) return;
    setState(() {
      canVote = false;
    });

    await vote(false);
    Future.delayed(Duration(seconds: 20), () async {
      var data = await getVotes(myAddress);
      votes = data[1];
      print(data);

      setState(() {
        canVote = true;
      });
    });
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
                  onPressed: canVote
                      ? () async {
                          await VoteB();
                        }
                      : null,
                  child: const Text("vote"))
            ]),
      ),
    );
  }
}
