import 'dart:core';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:voting_dapp/blockchain_vars.dart';
import 'package:web3dart/web3dart.dart';

class Votes {
  static Client httpClient = Client();
  static Web3Client ethClient = Web3Client(blockChainUrl, httpClient);
  static const myAddress = address;
  static List<int> myData = [0, 0];
  static bool canVote = true;

  static Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xfE0a2Ad86B09eC0b246Ec355c6A99A16e0D105F9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Vote"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  static Future<List<dynamic>> query(
      String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  static Future<List<int>> getVotes(String targetAddress) async {
    List<dynamic> result = await query("getVotes", []);
    myData = [int.parse(result[0].toString()), int.parse(result[1].toString())];
    print(myData);
    return myData;
  }

  static Future<void> vote(bool team) async {
    if (!canVote) {
      print("Cannot vote! please wait");
      return;
    }

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

    // Timer(Duration(seconds: 20), () {
    //   print("Voted for ${team ? "green" : "blue"}");
    //   canVote = true;
    // });
  }

  static Future<void> voteA() async {
    await Votes.vote(true)
        .then((value) => Future.delayed(const Duration(seconds: 20), () async {
              await readVotes();
            }))
        .then((value) => canVote = true);
  }

  static Future<void> voteB() async {
    await Votes.vote(false)
        .then((value) => Future.delayed(const Duration(seconds: 20), () async {
              await readVotes();
            }))
        .then((value) => canVote = true);
  }

  static Future<List<dynamic>> readVotes() async {
    return await getVotes(myAddress);
  }
}
