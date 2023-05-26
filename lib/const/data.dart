import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// dio 반환해주는 provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  return dio;
});

//localhost
final ip = 'ec2-3-34-216-149.ap-northeast-2.compute.amazonaws.com:8080';
