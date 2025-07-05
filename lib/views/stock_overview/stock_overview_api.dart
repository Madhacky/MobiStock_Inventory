import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smartbecho/views/stock_overview/stock_overview_model.dart';

class StockOverviewApi {
  Dio dio = Dio();
  String baseUrl =
      'https://backend-production-91e4.up.railway.app/api/mobiles/stock-details';

  String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdXBlckFkbWluQGdtYWlsLmNvbSIsImV4cCI6MTc1MjE1MTc1MiwiaWF0IjoxNzUxNTQ2OTUyfQ.JTQREkpCpgPwQa_qRGqsBCS_MklPmTjHz_TmofOaaJI';
  Future<List<StockOverviewModel>> getStockOverview() async {
    try {
      Response response = await dio.get(
        baseUrl,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        // print(" ${response.data}");
        final List<dynamic> data = jsonDecode(response.data["payload"]);
        return data.map((e)=>StockOverviewModel.fromJson(e)).toList();

        // return (response.data['payload'] as List)
        //     .map((data) => StockOverviewModel.fromJson(data))
        //     .toList();
      } else {
        throw Exception('Failed to load stock overview');
      }
    } catch (error) {
      print("error ${error}");
      rethrow;
    }
  }
}
