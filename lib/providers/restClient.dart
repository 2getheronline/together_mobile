import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:together_online/models/activity.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/models/message.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/models/session.dart';
import 'package:together_online/models/tag.dart';
import 'package:together_online/models/translate.dart';
import 'package:together_online/models/user.dart';
part 'restClient.g.dart';


@RestApi(baseUrl:
    "https://api.together-il.online/api/")


abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST("/sessions")
  Future<Session> login(@Body() Session session);

  @GET('/users/me')
  Future<User> getUser();

  @PUT("/users/{id}")
  Future<User> editUser(@Path() String id, @Body() User user);

  @GET('/users')
  Future<List<User>> getTopUsers();

  @GET('/groups')
  Future<List<Group>> getTopGroups();

  @GET("/missions")
  Future<List<Mission>> getMissions();

  @POST("/activities")
  Future<dynamic> createActivity(@Body() Activity activity);

  @GET('/activities')
  Future<List<Activity>> getMyActivities();

  @POST('/messages')
  Future<dynamic> sendMessage(@Body() Message message);

  @GET('/translations')
  Future<List<Language>> getLanguages();

  @GET('/translations/{lang}?group=mobile')
  Future<Translate> getTranslations(@Path() String lang);

}

