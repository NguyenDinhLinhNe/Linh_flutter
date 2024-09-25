import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:intl/intl.dart';

// Configure routes.
final _router = Router(notFoundHandler: _notFoundHandler)
  ..get('/', _rootHandler)
  ..get('/api/v1/echo/<message>', _echoHandler)
  ..get('/api/v1/check', _checkHandler)
  ..post('/api/v1/sendName', _submitName)
  ..post('/api/v1/sendAge', _submitAge)
  ..post('/api/v1/sendAddress', _submitAddress)
  ..post('/api/v1/sendPhone', _submitPhone)
  ..post('/api/v1/sendSex', _submitSex)
  ..post('/api/v1/sendAll', _submitAll);


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

Future<Response> _submitName(Request req) async {
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final name = data['name'] as String?;

    if(name != null && name.isNotEmpty){
      final response = {'message' : 'Tên của bạn là : $name'};

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
    final response =  {'message' : 'Yêu cầu không hợp lệ . Lỗi ${e.toString()}'};
    return Response.badRequest(
      body : json.encode(response),
      headers: _header,
    );
  }
}

Future<Response> _submitAge(Request req) async {
  try {
    final payload = await req.readAsString();

    // Giải mã JSON từ payload
    final data = json.decode(payload);

    // Lấy ngày sinh từ JSON (ví dụ: '27-11-2004')
    final birthDateStr = data['age'] as String?;

    if (birthDateStr != null && birthDateStr.isNotEmpty) {
      // Định dạng ngày tháng phù hợp với chuỗi đầu vào
      final dateFormat = DateFormat('dd-MM-yyyy');

      // Chuyển chuỗi ngày sinh thành DateTime
      final birthDate = dateFormat.parse(birthDateStr);

      // Tính tuổi từ ngày sinh
      final currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;

      // Kiểm tra nếu sinh nhật chưa qua trong năm nay
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
        age--;
      }

      // Trả về kết quả tuổi
      final response = {'message': 'Tuổi của bạn là : $age'};
      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    } else {
      final response = {'message': 'Ngày sinh không hợp lệ hoặc trống!'};
      return Response.badRequest(
        body: json.encode(response),
        headers: _header,
      );
    }
  } catch (e) {
    final response = {'message': 'Yêu cầu không hợp lệ. Lỗi: ${e.toString()}'};
    return Response.badRequest(
      body: json.encode(response),
      headers: _header,
    );
  }
}

Future<Response> _submitAddress(Request req) async{
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final address = data['address'] as String?;

    if(address != null && address.isNotEmpty){
      final response = {'message' : 'Địa chỉ của bạn ở $address'};

      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    }
    else{
      final response = {'message' : 'Bạn chưa điền địa chỉ'};

      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    }
  } catch(e){
    final response = {'message' : 'Yeu cau khong hop le . Loi ${e.toString()}'};
    return Response.badRequest(
      body : json.encode(response),
      headers: _header,
    );
  }
}

Future<Response> _submitPhone(Request req) async{
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final phone = data['phone'] as String?;

    if(phone != null && phone.isNotEmpty && phone.length == 10){
      final response = {'message' : 'Số điện thoại của bạn là : $phone'};

      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    }
    else{
      final response = {'message' : 'Bạn chưa điền số hoặc bạn chưa nhập đúng định dạng của 1 số điện thoại'};

      return Response.badRequest(
        body : json.encode(response),
        headers: _header,
      );
    }
  } catch(e){
    final response = {'message' : 'Yêu cầu không hợp lệ . Lỗi ${e.toString()}'};

    return Response.badRequest(
      body : json.encode(response),
      headers: _header,
    );
  }
}

Future<Response> _submitSex(Request req) async{
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final sex = data['sex'] as String?;

    if(sex != null && sex.isNotEmpty && (sex == 'Nam' || sex == 'Nữ')){
      final response = {'message' : 'Bạn là : $sex'};

      return Response.ok(
        json.encode(response),
        headers: _header,
      );
    }
    else{
      final response = {'message' : 'Bạn không phải nam hoặc nữ ư ?'};

      return Response.badRequest(
        body : json.encode(response),
        headers: _header,
      );
    }
  } catch(e){
    final response = {'message' : 'Yêu cầu không hợp lệ . Lỗi ${e.toString()}'};

    return Response.badRequest(
      body : json.encode(response),
      headers: _header,
    );
  }
}

Future<Response> _submitAll(Request req) async{
  List<String> responses = [];
  try{
    final payload = await req.readAsString();

    final data = json.decode(payload);

    final name = data['name'] as String?,
    age = data['age'] as String?,
    address = data['address'] as String?,
    phone = data['phone'] as String?,
    sex = data['sex'] as String?;

    if(name != null && age != null && address != null
    && phone != null && sex != null && name.isNotEmpty
    && age.isNotEmpty && address.isNotEmpty && phone.isNotEmpty
    && sex.isNotEmpty){
      responses.add('Name : $name');
      responses.add('Age : $age');
      responses.add('Address : $address');
      responses.add('Phone : $phone');
      responses.add('Sex : $sex');

      final response = responses.join('\n');

      return Response.ok(
        json.encode({'message' : response}),
        headers: _header,
      );
    }
    else{
      final response = {'message' : 'Server chưa nhận đủ thông tin của bạn'};

      return Response.badRequest(
        body : json.encode(response),
        headers: _header,
      );
    }
  } catch(e){
    final response = {'message' : 'Không nhận được dữ liệu'};

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
      if(req.method == 'OPTIONS'){
        return Response.ok('' , headers : {
          'Access-Control-Allow-Origin' : '*',
          'Access-Control-Allow-Methods' : 'GET , POST , PUT , DELETE , PATCH , HEAD',
          'Access-Control-Allow-Headers' : 'Content-Type , Authorization',
        });
      }
      return null;
    },
    responseHandler: (res) {
      return res.change(headers : {
        'Access-Control-Allow-Origin' : '*',
        'Access-Control-Allow-Methods' : 'GET , POST , PUT , DELETE , PATCH , HEAD',
        'Access-Control-Allow-Headers' : 'Content-Type , Authorization',
      });
    },
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
