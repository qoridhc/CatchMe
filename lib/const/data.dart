import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// dio 반환해주는 provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  return dio;
});

//localhost
final emulatorIp = '10.0.2.2:8080';
final simulatorIp = '127.0.0.1:8080';

// 현재 사용하는 플랫폼 종류에(ios인지 android인지) 따라 ip 반환
final ip = Platform.isIOS ? simulatorIp : emulatorIp;