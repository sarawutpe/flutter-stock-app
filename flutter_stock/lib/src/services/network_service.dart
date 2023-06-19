import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_mystock/src/constants/api.dart';
import 'package:flutter_mystock/src/models/posts.dart';
import 'package:http_parser/http_parser.dart';

class NetworkService {
  NetworkService._internal();

  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  // Use Dio and Interceptors
  static final _dio = Dio()
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.baseUrl = Api.baseURL;
      options.connectTimeout = 5000;
      options.receiveTimeout = 3000;
      options.headers = {
        'Authorization': "",
      };

      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      return handler.next(e); //continue
    }));

  Future<List<Product>> getAllProduct() async {
    const url = Api.product;
    final Response response = await _dio.get(url);

    if (response.statusCode == 200) {
      return productFromJson(jsonEncode(response.data));
    }

    throw Exception('Network failed');
  }

  Future<String> addProduct(Product product, {File? imageFile}) async {
    const url = Api.product;

    // Create form data
    FormData data = FormData.fromMap({
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      if (imageFile != null)
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          contentType: MediaType('image', 'jpg')
        )
    });

    final Response response = await _dio.post(url, data: data);

    if (response.statusCode == 201) {
      return 'Add Successfully';
    }

    throw Exception('Network failed');
  }

  Future<String> editProduct(Product product, {File? imageFile}) async {
    final url = '${Api.product}/${product.id}';

    // Create form data
    FormData data = FormData.fromMap({
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      if (imageFile != null)
        'photo': await MultipartFile.fromFile(
            imageFile.path,
            contentType: MediaType('image', 'jpg')
        )
    });

    final Response response = await _dio.put(url, data: data);

    if (response.statusCode == 200) {
      return 'Edit Successfully';
    }

    throw Exception('Network failed');
  }

  Future<String> deleteProduct(int productId) async {
    final url = '${Api.product}/$productId';

    final Response response = await _dio.delete(url);

    if (response.statusCode == 204) {
      return 'Delete Successfully';
    }

    throw Exception('Network failed');
  }

}
