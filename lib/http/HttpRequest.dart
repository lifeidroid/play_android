import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:play_android/http/return_body_entity.dart';

import '../Config.dart';
import 'Code.dart';

///http请求管理类，可单独抽取出来
class HttpRequest {
  static String _baseUrl = "https://www.wanandroid.com/";
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  static setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static get(
      url, param, Function successCallBack, Function errorCallBack) async {
    return await request(
        _baseUrl + url,
        param,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: "GET"),
        successCallBack,
        errorCallBack);
  }

  static post(
      url, param, Function successCallBack, Function errorCallBack) async {
    return await request(
        _baseUrl + url,
        param,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'),
        successCallBack,
        errorCallBack);
  }

  static delete(
      url, param, Function successCallBack, Function errorCallBack) async {
    return await request(_baseUrl + url, param, null,
        new Options(method: 'DELETE'), successCallBack, errorCallBack);
  }

  static put(
      url, param, Function successCallBack, Function errorCallBack) async {
    return await request(_baseUrl + url, param, null,
        new Options(method: "PUT"), successCallBack, errorCallBack);
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static request(url, params, Map<String, String> header, Options option,
      Function successCallBack, Function errorCallBack,
      {noTip = false}) async {
    //没有网络
//    var connectivityResult = await (new Connectivity().checkConnectivity());
//    if (connectivityResult == ConnectivityResult.none) {
//      return new ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip), false, Code.NETWORK_ERROR);
//    }
    //header
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    //授权码
//    if (optionParams["authorizationCode"] == null) {
//      var authorizationCode = await getAuthorization();
//      if (authorizationCode != null) {
//        optionParams["authorizationCode"] = authorizationCode;
//      }
//    }

//    headers["Authorization"] = optionParams["authorizationCode"];
    // 设置 baseUrl

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    ///超时
    option.sendTimeout = 15000;

    Dio dio = new Dio();
    // 添加拦截器
    if (Config.DEBUG) {
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
      }, onResponse: (Response response) {
        print("\n================== 响应数据 ==========================");
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        print("\n");
      }, onError: (DioError e) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("\n");
      }));
    }

    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      // 请求错误处理
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常 url: ' + url);
      }
      if (null != errorCallBack) {
        errorCallBack(Code.NETWORK_TIMEOUT, "网络不稳定，请稍后重试");
      }
    }
    if (null != response.data) {
      ReturnBodyEntity returnBodyEntity =
          ReturnBodyEntity.fromJson(json.decode(response.data));
      if (null != returnBodyEntity) {
        if (null != returnBodyEntity && returnBodyEntity.errorCode == 0) {
          if (returnBodyEntity.errorCode == 0) {
            successCallBack(jsonEncode(returnBodyEntity.data));
          } else {
            errorCallBack(
                returnBodyEntity.errorCode, returnBodyEntity.errorMsg);
          }
        } else {
          errorCallBack(Code.NETWORK_JSON_EXCEPTION, "网络数据有问题");
        }
      }
    } else {
      errorCallBack(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
    }
  }

  ///清除授权
  static clearAuthorization() {
//    optionParams["authorizationCode"] = null;
//    SpUtils.remove(Config.TOKEN_KEY);
  }

  ///获取授权token
  static getAuthorization() async {
//    String token = await SpUtils.get(Config.TOKEN_KEY);
//    if (token == null) {
//      String basic = await SpUtils.get(Config.USER_BASIC_CODE);
//      if (basic == null) {
//        //提示输入账号密码
//      } else {
//        //通过 basic 去获取token，获取到设置，返回token
//        return "Basic $basic";
//      }
//    } else {
//      optionParams["authorizationCode"] = token;
//      return token;
//    }
  }
}
