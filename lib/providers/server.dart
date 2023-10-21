import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/models/message.dart';
import 'package:together_online/models/session.dart';
import 'package:together_online/models/user.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/restClient.dart';

import 'dataBinding.dart';

class Server {
  final _binding = DataBindingBase.getInstance();
  final dio = Dio();
  late RestClient client;

  static Server? _instance;

  Server._() {
    client = RestClient(dio);
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
    dio.options.headers["Accept"] = "application/json";
  }

  static Server? getInstance() {
    if (_instance == null) {
      _instance = Server._();
    }
    return _instance;
  }

  addToken(String token) {
    dio.options.headers["Authorization"] = "Bearer " + token;
  }

  Future<bool> login(String token,
      {String? groupId, String? groupPassword, String? name}) async {
    Session session = Session.init(
        token: token,
        groupId: groupId,
        groupPassword: groupPassword,
        name: name);
    Session s = await client.login(session);
    if (s.auth!.id! > 0) {
      final _binding = DataBindingBase.getInstance();
      _binding.setSession(s);

      dio.options.headers["Authorization"] = "Bearer " + s.auth!.apiKey!;

      if (Auth.rememberMe!) Auth.saveToken(s.auth!.apiKey);

      return true;
    } else {
      print('Something went wrong... ');
      return false;
    }
  }

  getMissions() async {
    _binding.session!.auth!.language = _binding.selectedLanguage.language;
    await editUser();
    _binding.isMissionLoad = false;
    client.getMissions().then((missions) {
      _binding.isMissionLoad = true;
      _binding.setMissions(missions);
    });
  }

   loadUser() async {
    try {
      final user = await client.getUser();
      if (!user.blocked) {
        _binding.session = Session(auth: user);
      }
    } catch (e){

     }
  }

  editUser() async {
    String uId = _binding.session!.auth!.id.toString();
    User u = _binding.session!.auth!;
    client.editUser(uId, u).then((user) => _binding.session!.auth = user);
  }

  loadTopUsers() {
    client.getTopUsers().then((users) => _binding.topUsers
      ..clear()
      ..addAll(users));
  }

  loadTopGroups() {
    client.getTopGroups().then((groups) => _binding.topGroups
      ..clear()
      ..addAll(groups));
  }

  loadMyActivities() {
    client.getMyActivities().then((activities) => _binding.activities
      ..clear()
      ..addAll(activities));
  }

  loadLanguages() async {
    List<Language> languages = await client.getLanguages();
    _binding.languages..clear()..addAll(languages);
  }

  Future<dynamic> sendReport(Message message) {
    message.title = 'Report Link';
    return client.sendMessage(message);
  }
}
