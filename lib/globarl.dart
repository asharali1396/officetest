import 'dart:collection';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Abc {
  static List<Contact> contacts;
  static Map<String, int> statusFlag;
  static HashSet customerSet = new HashSet();
  static asyncrefrestStatus() async {
     print("Hello############################");
    var contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
         print("Hello############################");
    var url = 'http://demo6230403.mockable.io/test';
    http.post(url, body: {'name': 'doodle', 'color': 'blue'}).then((Response res){
           var resp = json.decode(res.body);
            Abc.customerSet.addAll(resp["values"]);
        });
         print("Hello############################");
 
     print("Hello#########################qqq###");
   
    Abc.contacts = contacts;
    print("Hello############################");
    return Abc.contacts;
  }
}
