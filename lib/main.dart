import 'dart_mongo.dart';

void main(List<String> arguments) async {
  var port = 6062;
  final server = await HttpServer.bind('192.168.0.18', port);

  final newDb = Db('mongodb://localhost:27017/test');
  await newDb.open();

  print('Connected to database');
  final  coll = newDb.collection('people');

  server.transform(HttpBodyHandler()).listen((HttpRequestBody reqBody) async {
    switch(reqBody.request.uri.path){
      case '/':
        reqBody.request.response.write('Hello World');
        await  reqBody.request.response.close();
        break;

      case '/people':
        PeopleController(reqBody,newDb);
        break;

      default:
        reqBody.request.response
          ..statusCode = HttpStatus.notFound
          ..write('404,not found');
        await  reqBody.request.response.close();
    }
  });

  print('Server is listening on port : $port');

//  await newDb.close();
}
