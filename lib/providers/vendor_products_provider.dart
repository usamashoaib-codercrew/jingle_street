import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';

class GetVendorProductsProvider extends ChangeNotifier{
  late Map<String, dynamic> _getVendorItemsList;

  Map<String, dynamic> get getVendorItemsList => _getVendorItemsList;

  Future<void> getVendorItemsApi (BuildContext context, String id) async {

    try {
      var response = await AppDio(context).post(
          path: AppUrls.getVendorProducts, data: {'v_id': '${id}'});
      var responseData = response.data;
      _getVendorItemsList = responseData;
      print("getting_idddddd $id");
      print("getting provider_data of vendor products $_getVendorItemsList");
      notifyListeners();
    } catch (e) {
      print("getVendorProducts exception $e");
    }
  }

}