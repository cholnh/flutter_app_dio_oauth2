import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio/dio_core.dart';

class ResourceRepository {

  get({
    @required String url,
    Locale locale,
  }) async {
    var res = await DioCore().resource.get(url,
        options: Options(headers: {
          'Accept-Language': locale == null ? 'ko' : locale.languageCode,
        }),
    );
    if(res != null && res.statusCode == 200) {
      return res.data;
    }
    return null;
  }

  post({
    @required String url,
    Locale locale,
    FormData formData
  }) async {
    var res = await DioCore().resource.post(url,
      options: Options(headers: {
        'Accept-Language': locale == null ? 'ko' : locale.languageCode,
      }),
      data: formData
    );
    if(res != null && res.statusCode == 200) {
      return res.data;
    }
    return null;
  }
}