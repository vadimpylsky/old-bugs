// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fix _$FixFromJson(Map<String, dynamic> json) => Fix(
      link: json['link'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$FixToJson(Fix instance) => <String, dynamic>{
      'link': instance.link,
      'createdAt': instance.createdAt,
    };

FixEntity _$FixEntityFromJson(Map<String, dynamic> json) => FixEntity(
      id: json['id'] as String?,
      link: json['link'] as String?,
      fixedAt: json['fixedAt'] == null
          ? null
          : DateTime.parse(json['fixedAt'] as String),
    );

Map<String, dynamic> _$FixEntityToJson(FixEntity instance) => <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'fixedAt': instance.fixedAt?.toIso8601String(),
    };

FixInfo _$FixInfoFromJson(Map<String, dynamic> json) => FixInfo(
      name: json['name'] as String?,
      issue: json['issue'] as String?,
      points: json['points'] as int?,
    );

Map<String, dynamic> _$FixInfoToJson(FixInfo instance) => <String, dynamic>{
      'name': instance.name,
      'issue': instance.issue,
      'points': instance.points,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://localhost:7173/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<void> addFix(fix) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(fix.toJson());
    await _dio.fetch<void>(_setStreamType<void>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/bugs/create',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<List<FixInfo>> getFixesInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<FixInfo>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/bugs/feed',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => FixInfo.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<FixEntity>> getMyFixes() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<FixEntity>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/bugs',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => FixEntity.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<void> delete(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.fetch<void>(_setStreamType<void>(
        Options(method: 'DELETE', headers: _headers, extra: _extra)
            .compose(_dio.options, '/bugs/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
