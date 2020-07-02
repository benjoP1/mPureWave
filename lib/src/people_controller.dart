import 'package:http_server/http_server.dart';
import 'dart:io' show HttpRequest;
import 'package:mongo_dart/mongo_dart.dart';


class PeopleController{
  final HttpRequestBody _reqBody;
  final Db db;
  final DbCollection _store;
  final HttpRequest _req;


  PeopleController(this._reqBody, this.db)
      : _req = _reqBody.request,
       _store =db.collection('people'){
    handle();
  }

  handle()async{
    switch(_req.method) {
      case 'GET':
        await handleGet();
        break;

      case 'POST':
        await handlePost();
        break;

      case 'DELETE':
        await handleDelete();
        break;

      default:
        _req.response.statusCode = 405;
    }

    await _req.response.close();
  }

  handleGet()async {
    _req.response.write(await _store.find().toList());
  }
   handlePost() async {
     _req.response.write(await _store.save(_reqBody.body));
   }
   handleDelete() async {
        var id = int.parse(_req.uri.queryParameters['id']);
        var itemToDelete = await _store.findOne(where.eq('id', id));
        await _store.remove(itemToDelete);
   }

}

