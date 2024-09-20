import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router(notFoundHandler: _notFoundHandler)
  ..get('/', _rootHandler)
  ..get('api/v1/check', _checkHandler)
  ..get('api/v1/echo/<message>', _echoHandler)
  ..post('api/v1/submit', _submitHandler);

final _header = {'Content-Type' : 'application/json'};

Response _notFoundHandler(Request req){
  return Response.notFound('Không tìm thấy đường dẫn "${req.url}" trên server');
}

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _checkHandler(Request req){
  return Response.ok(
    json.encode({'message' : 'Chào mừng đến với web động' }),
    headers: _header
  );
}

Future<Response> _submitHandler(Request req) async {
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final name = data['name'] as String?;

    if(name != null && name.isNotEmpty){
      final response = {'message' : 'Xin chào $name'};

      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    }
    else{
      final response = {'message' : 'Server không nhận được tên của bạn !'};

      return Response.badRequest(
        body : json.encode(response),
        headers: _header,
      );
    }
  } catch(e){
    final response =  {'message' :  'Yêu cầu không hợp lệ . Lỗi ${e.toString()}'};
    return Response.badRequest(
      body : json.encode(response),
      headers: _header,
    );
  }
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final corHeader = createMiddleware(
    requestHandler: (req) {
      if(req.method == 'OPTIOINS'){
        return Response.ok('' , headers : {
          'Access-Control-Allow-Origin' : '*',
          'Access-Control-Allow-Methods' : 'GET , POST , PUT , DELETE , PATCH , HEAD',
          'Access-Control-Allow-Headeres' : 'Content-Type , Authorization',
        });
      }
      return null;
    },
    responseHandler: (res) {
      return res.change(headers : {
        'Access-Control-Allow-Origin' : '*',
        'Access-Control-Allow-Methods' : 'GET , POST , PUT , DELETE , PATCH , HEAD',
        'Access-Control-Allow-Headeres' : 'Content-Type , Authorization',
      });
    }
  );

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
  .addMiddleware(corHeader)
  .addMiddleware(logRequests())
  .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server dang chay tai http://${server.address.host}: ${server.port}');
}
