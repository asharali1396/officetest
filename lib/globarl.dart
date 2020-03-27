import 'dart:collection';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;

class Abc {
  static List<Contact> contacts;
  static Map<String, int> statusFlag;
  static HashSet customerSet = new HashSet();
  static asyncrefrestStatus() async {
    var contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    var url = 'http://demo6230403.mockable.io/test';
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    var res = json.decode(response.body);
    Abc.customerSet.addAll(res["values"]);
    Abc.contacts = contacts;
    return Abc.contacts;
  }
}
