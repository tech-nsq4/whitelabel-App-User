import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/offer_model.dart';

class OffersRepo {
  OffersRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await _dio.get(ApiEndpoints.offers);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => OfferModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<OfferModel> getOffer(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.offerDetails(id));
      return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
