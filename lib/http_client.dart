import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:old_bugs/server_error.dart';

import 'rest_client.dart';

class HttpClient {
  static RestClient? _client;

  static Future<void> addFix(Fix fix) async {
    try {
      final client = await _getClient();
      await client.addFix(fix);
    } catch (e) {
      throw ServerError();
    }
  }

  static Future<List<FixInfo>> getFixes() async {
    try {
      final client = await _getClient();
      final result = await client.getFixesInfo();
      return result;
    } catch (e) {
      throw ServerError();
    }
  }

  static Future<List<FixEntity>> getMyFixes() async {
    try {
      final client = await _getClient();
      final result = await client.getMyFixes();
      return result;
    } catch (e) {
      return <FixEntity>[];
    }
  }

  static Future<void> delete(String id) async {
    try {
      final client = await _getClient();
      await client.delete(id);
    } catch (e) {
      //
    }
  }

  static Future<RestClient> _getClient() async {
    if (_client == null) {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user!.getIdToken();
      _client =
          RestClient(Dio()..options.headers["Authorization"] = "Bearer $token");
    }

    return _client!;
  }
}
