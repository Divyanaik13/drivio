import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../utils/CommonFunctions.dart';
import '../utils/ConstStrings.dart';
import '../utils/LocalStorage.dart';
import 'WebService.dart';
import 'package:http/http.dart' as http;

class DioServices extends GetxService {
  static final DioServices dioServices = DioServices._internal();

  factory DioServices() {
    return dioServices;
  }
  DioServices._internal();

  final DIO.Dio dio = DIO.Dio();
  static final int timeoutInSeconds = 30;
  final DIO.LogInterceptor loggingInterceptor = DIO.LogInterceptor();
  LocalStorage sp = LocalStorage();
  static var client = http.Client();

  //For getMethod
  Future<DIO.Response> getMethod(String endPoint, dynamic header) async {
    var response;
    if (await checkNetwork()) {
      print("internet");
      try {
        response = await dio.get(WebService().baseUrl + endPoint,
            options: DIO.Options(headers: header));
        return returnResponse(response);
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          }
        } else {
          log("No Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }
    return returnResponse(response);
  }

  //For postMethod
  Future<DIO.Response> postMethod1(
      String endPoint, Map<String, dynamic>? body, header) async {
    DIO.FormData formData = DIO.FormData.fromMap(body!);
    var response;
    if (await checkNetwork()) {
      try {
        response = await dio.post(
          WebService().baseUrl + endPoint,
          data: formData,
          options: DIO.Options(headers: header),
        );

        return returnResponse(response);
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          } else {
            log("Error:-- ${e.message}");
          }
        } else {
          log("NO Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }

  Future<DIO.Response> postMethod(
      String endPoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header,
      ) async {
    var response;

    if (await checkNetwork()) {
      try {
        response = await dio.post(
          WebService().baseUrl + endPoint,
          data: body,
          options: DIO.Options(
            headers: {
              "Content-Type": "application/json",
              ...?header,
            },
          ),
        );

        return returnResponse(response);
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            return returnResponse(e.response!);
          } else {
            log("Error:-- ${e.message}");
          }
        } else {
          log("NO Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }


  //For put Method
  Future<DIO.Response> putMethod(
      String endPoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header,) async {
  //  DIO.FormData formData = DIO.FormData.fromMap(body);
    var response;
    if (await checkNetwork()) {
      try {
        response = await dio.put(
          WebService().baseUrl + endPoint,
          data: body,
          options: DIO.Options(
            headers: {
              "Content-Type": "application/json",
              ...?header,
            },
          ),
        );

        return returnResponse(response);
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          } else {
            log("Error:-- ${e.message}");
          }
        } else {
          log("No Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }

  //For patch Method
  Future<DIO.Response> patchMethod(
      String endPoint, dynamic header, dynamic data) async {
    var response;
    if (await checkNetwork()) {
      print("internet");
      try {
        response = await dio.patch(
          WebService().baseUrl + endPoint,
          data: data, // Add the data parameter for PATCH requests
          options: DIO.Options(headers: header),
        );
        return returnResponse(response);
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          }
        } else {
          log("No Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }
    return returnResponse(response);
  }

  //For delete Method
 /* Future<DIO.Response> deleteData(
      String endPoint, dynamic headerBody, dynamic data) async {
    var response;
    if (await checkNetwork()) {
      try {
        response = await dio.delete(
          WebService().baseUrl + endPoint,
          data: data,
          options: Options(headers: headerBody),
        );

        return returnResponse(response);
      } on DioException catch (e) {
        print("Error: \$${e.message}");
        return e.response ??
            DIO.Response(
                requestOptions: RequestOptions(path: endPoint),
                statusCode: 500);
      }
    } else {
      print("no internet");
    }
    return returnResponse(response);
  }*/
  Future<Map<String, dynamic>> deleteData(
      String endPoint, dynamic headerBody, dynamic data) async {
    var response;
    if (await checkNetwork()) {
      try {
        response = await dio.delete(
          WebService().baseUrl + endPoint,
          data: data,
          options: Options(headers: headerBody),
        );

        return response.data;
      } on DioException catch (e) {
        print("Error: ${e.message}");
        return {
          "success": 0,
          "message": e.message ?? "Server error",
          "error": e.response?.data ?? {},
        };
      }
    } else {
      print("no internet");
      return {
        "success": 0,
        "message": "No internet connection",
        "error": {}
      };
    }
  }


  //For multipart method
  Future<dynamic> multipartPostMethod1(String endPoint, String keyName,
      String filePath, Map<String, dynamic> body, header) async {
    if (filePath.isNotEmpty) {
      body[keyName] = await DIO.MultipartFile.fromFile(filePath, //modify 1 line
          contentType: DIO.DioMediaType(
              'image', filePath.split('/').last.split('.').last),
          filename: filePath.split('/').last);
    }

    final formData = DIO.FormData.fromMap(body);
    var response;
    if (await checkNetwork()) {
      try {
        response = await dio.post(
          WebService().baseUrl + endPoint,
          data: formData,
          options: DIO.Options(headers: header),
        );
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          } else {
            log("Error: ${e.message}");
          }
        } else {
          log("NO Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }

  //For multipart put method
  Future<dynamic> multipartPutMethod(String endPoint, String keyName,
      String filePath, Map<String, dynamic> body, header) async {
    if (filePath.isNotEmpty) {
      body[keyName] = await DIO.MultipartFile.fromFile(filePath,
          contentType: DIO.DioMediaType(
              'image', filePath.split('/').last.split('.').last),
          filename: filePath.split('/').last);
    }

    final formData = DIO.FormData.fromMap(body);
    var response;
    if (await checkNetwork()) {
      try {
        checkNetwork();
        response = await dio.put(
          WebService().baseUrl + endPoint,
          data: formData,
          options: DIO.Options(headers: header),
        );
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            response = e.response;
            return returnResponse(e.response!);
          } else {
            log("Error: ${e.message}");
          }
        } else {
          log("NO Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }

  //For multiple files multipart post method
  Future<dynamic> multipartPostMethod(
      String endPoint,
      String keyName,
      List<String> filePaths,
      Map<String, dynamic> body,
      Map<String, dynamic> header,
      ) async {
    if (filePaths.isNotEmpty) {
      List<DIO.MultipartFile> files = [];

      for (String path in filePaths) {
        String extension = path.split('.').last.toLowerCase();
        print("exteintion $extension");
        String mimeTypeMain = (['jpg', 'jpeg', 'png', 'gif'].contains(extension))
            ? 'image'
            : (['mp4', 'mov', 'avi', 'mkv'].contains(extension))
            ? 'video'
            : 'application';

        files.add(await DIO.MultipartFile.fromFile(
          path,
          contentType: DIO.DioMediaType(mimeTypeMain, extension),
          filename: path.split('/').last,
        ));
      }

      body[keyName] = files;
    }

    final formData = DIO.FormData.fromMap(body);
    var response;

    if (await checkNetwork()) {
      try {
        response = await dio.post(
          WebService().baseUrl + endPoint,
          data: formData,
          options: DIO.Options(headers: header),
        );
      } catch (e) {
        if (e is DioException) {
          if (e.response != null) {
            return returnResponse(e.response!);
          } else {
            log("Error: ${e.message}");
          }
        } else {
          log("NO Dio Error: $e");
        }
      }
    } else {
      print("no internet");
    }

    return returnResponse(response);
  }



  // to handle api error's
  returnResponse(DIO.Response response) {
    return response;
  }

  // Get default headers
  Future<Map<String, String>> getDefaultHeader() async {
    Map<String, String> defaultHeaders = {
     /* "device-token":
      "abcxyz", //Platform.isAndroid? LocalStorage().getStringValue(sp.deviceToken): "dfndlfdf",
      "device-type": Platform.isAndroid ? "android" : "ios",
      //"device-id": await CommonFunctions().getDeviceId(name: true) ?? "",
      "api-key": "NtE]yUS%tF7eqAePNT6|WWlQxhJQNgb8,)M*|y8y59HkAv6nZs",*/
      'Content-Type': 'application/json',
    };

    print("getDefaultHeader $defaultHeaders");

    return defaultHeaders;
  }

  // Get all headers
  Future<Map<String, String>> getAllHeaders() async {
    Map<String, String> allHeaders = {
      "Authorization": "Bearer ${LocalStorage().getStringValue(sp.authToken)}",
     // "device-token": LocalStorage().getStringValue(sp.deviceToken),
    //  "device-type": Platform.isAndroid ? "android" : "ios",
    //  "device-id": await CommonFunctions().getDeviceId(name: true) ?? "",
    //  "api-key": "NtE]yUS%tF7eqAePNT6|WWlQxhJQNgb8,)M*|y8y59HkAv6nZs",
      'Content-Type': 'application/json',
    };
    return allHeaders;
  }

  // Check network connectivity
  Future<bool> checkNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print("connectivityResult $connectivityResult");
    if (connectivityResult[0] == ConnectivityResult.none) {
      // Internet is not available
      CommonFunctions().alertDialog(
        ConstStrings().alertTxt,
        ConstStrings().noInternetTxt,
        ConstStrings().okTxt,
            () {
          Get.back();
        },
      );
      return false;
    }
    // Internet is available
    return true;
  }
}