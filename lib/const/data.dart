import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// dio 반환해주는 provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  return dio;
});

//localhost
final ip = '3.34.216.149:8080';
final CATCHME_URL = 'http://3.34.216.149:8080';
final MATCHING_WS_URL = 'ws://3.34.216.149:9090';
final CHATTING_API_URL = 'http://10.0.2.2:9081';
final CHATTING_WS_URL = 'ws://10.0.2.2:9081/chat';
