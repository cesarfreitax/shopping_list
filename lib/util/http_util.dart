import 'package:http/http.dart';

class HttpUtil {
  void printHttpResponseLog(Response response) {
    print('HTTP Request - Method: ${response.request} - StatusCode: ${response.statusCode} - Content: ${response.body}');
  }
}