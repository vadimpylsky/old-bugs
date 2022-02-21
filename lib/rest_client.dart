import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://localhost:7173/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/bugs/create")
  Future<void> addFix(@Body() Fix fix);

  @GET("/bugs/feed")
  Future<List<FixInfo>> getFixesInfo();

  @GET("/bugs")
  Future<List<FixEntity>> getMyFixes();

  @DELETE("/bugs/{id}")
  Future<void> delete(@Path() String id);
}

@JsonSerializable()
class Fix {
  String? link;
  String? createdAt;

  Fix({this.link, this.createdAt});

  factory Fix.fromJson(Map<String, dynamic> json) => _$FixFromJson(json);

  Map<String, dynamic> toJson() => _$FixToJson(this);
}

@JsonSerializable()
class FixEntity {
  String? id;
  String? link;
  DateTime? fixedAt;

  FixEntity({this.id, this.link, this.fixedAt});

  factory FixEntity.fromJson(Map<String, dynamic> json) =>
      _$FixEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FixEntityToJson(this);
}

@JsonSerializable()
class FixInfo {
  String? name;
  String? issue;
  int? points;

  FixInfo({this.name, this.issue, this.points});

  factory FixInfo.fromJson(Map<String, dynamic> json) =>
      _$FixInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FixInfoToJson(this);
}
