import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:voting_dapp/Model/votes_model.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class VotesController extends ControllerMVC {
  factory VotesController() {
    if (_this == null) _this = VotesController._();
    return _this;
  }

  static VotesController _this = VotesController._();

  VotesController._();

  List<int> get myData => Votes.myData;
  Client get httpClient => Votes.httpClient;
  bool get canVote => Votes.canVote;

  set httpClient(Client client) => Votes.httpClient;
  set ethClient(Web3Client client) => Votes.ethClient;
  set canVote(bool bool) => Votes.canVote;
  // httpClient = Client();
  // ethClient = Web3Client(blockChainUrl, httpClient);
  // getVotes(myAddress);

  Future<void> voteA() async => await Votes.voteA();
  Future<void> voteB() async => await Votes.voteB();
  Future<List<dynamic>> readVotes() async => await Votes.readVotes();
}
