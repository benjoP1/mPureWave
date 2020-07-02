import 'package:mongo_dart/mongo_dart.dart';

main(List<String> arguments) async {
  final newDb = Db('mongodb://localhost:27017/test');
  await newDb.open();

  print('Connected to database');

  //READ PEOPLE
  final  coll = newDb.collection('people');
//  var people = await coll.find().toList();
  var people = await coll.find(where.eq('first_name', 'Calypso')).toList();
//  print(people);

  //gt means greater than.There is also >= 'gte'
  var person = await coll.findOne(where.match('first_name', 'B').and(where.gt('id', 40)));
  //OR YOU CAN WRITE AS
  var pers = await coll.findOne(where.match('first_name', 'B').gt('id', 40));
  var jsResult = await coll.findOne(where.jsQuery('''
    return this.first_name.startsWith('B') && this.id>40;
  '''));
  print(person);
//  print(pers);
//  print(jsResult);

  //CREATE A PERSON
  //JUST SAY coll.save({ details of the new persone.g "id" : 66, "ugu" : "hgjk"})

  //UPDATE PERSON
  await coll.update(await coll.findOne(where.eq('id', 66)), {
    r'$set' : {
      'gender' : 'Male'
    }
  });
  print('updated person');
//  print(await coll.findOne(where.eq('id', 66)));

  //DELETE PERSON
  await coll.remove(await coll.findOne(where.eq('id', 66)));
  print(await coll.findOne(where.eq('id', 66)));



  await newDb.close();
}
