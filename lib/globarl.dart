import 'dart:collection';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Abc {
  static List<Contact> contacts;
  static Map<String, int> statusFlag;
  static HashSet customerSet = new HashSet();
  static refrestStatus() async {
    var contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();

    var url = 'http://demo6230403.mockable.io/test';
    http.post(url, body: {'name': 'doodle', 'color': 'blue'}).then((Response res){
           var resp = json.decode(res.body);
            Abc.customerSet.addAll(resp["values"]);
        });
 
   
    Abc.contacts = contacts;

    return Abc.contacts;
  }
  static asyncrefrestStatus() async {
        (ContactsService.getContacts(withThumbnails: false)).then((Iterable<Contact> contact ){
          Abc.contacts=contact.toList();
           var url = 'http://demo6230403.mockable.io/test';
           http.post(url, body: {'name': 'doodle', 'color': 'blue'}).then((Response res){   
           var resp = json.decode(res.body);
            Abc.customerSet.addAll(resp["values"]);
        });
        });
  }
}
