import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/blockchainVars.dart';
import 'package:web3dart/web3dart.dart';

class mainPage extends StatefulWidget {
  late Client httpClient;
  late Web3Client ethClient;
  final myAddress = address;
  var myData;
  // const mainPage({super.key});

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

  Future<void> vote2(bool team) async {
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

  Future vote(bool team) async {
    String func = team ? "VoteA" : "VoteB";
    var response = await submit(func, []);
    return response;
  }

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  void initState() {
    super.initState();
    widget.httpClient = Client();
    widget.ethClient = Web3Client(blockChainUrl, widget.httpClient);
    widget.getVotes(widget.myAddress);
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () async {
                Null;
                await widget.vote2(true);
                print("voted for A");
              },
              child: Text("Team 1"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                print("voted for B");
              },
              child: Text("Team 2"),
            ),
          ),
        ]),
      ),
    );
  }
}
