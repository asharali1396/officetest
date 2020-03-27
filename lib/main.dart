import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'globarl.dart';

void main() => runApp(ContactsExampleApp());

class ContactsExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: Abc.asyncrefrestStatus(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return LandingPage();
            } else {
              return SafeArea(child: Center(child: Text("Loading")));
            }
          }),
    
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPagePageState createState() => _LandingPagePageState();
}

class _LandingPagePageState extends State<LandingPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts Plugin Example')),
      body: SafeArea(
          child: Center(
              child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactListPage())).then((_) {
                      Abc.asyncrefrestStatus();
                    });
                  },
                  child: Text("Open")))),
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  HashSet selectContacts=new HashSet();
  Map<String,bool> selec=new Map<String,bool>();
  @override
  initState() {
    super.initState();
    refreshContacts();
  }

  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Load without thumbnails initially.
     // Abc.asyncrefrestStatus();
      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in Abc.contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts Plugin Example')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          String _select="";
          selectContacts.forEach((Object a){
            _select+=a.toString()+"\n";
          });
         showDialog(
    context: context,
    builder: (BuildContext context){
        return AlertDialog(
          title: Text("Selected Contacts"),
          content: Text(_select),
        );
    }
  );
        },
      ),
      body: SafeArea(
        child: Abc.contacts != null
            ? ListView.builder(
                itemCount: Abc.contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  
                  Contact c = Abc.contacts?.elementAt(index);
                 selec[c.identifier]==null?selec[c.identifier]=false: null;
                  return ListTile(
                    onTap: () {
                    
                    },
                    leading: (c.avatar != null && c.avatar.length > 0)
                        ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                        : CircleAvatar(child: Text(c.initials())),
                    title: Text(c.displayName ?? ""),
                    subtitle: Text(Abc.customerSet.contains(
                            (c.phones != null && c.phones.length > 0
                                ? c.phones.elementAt(0).value
                                : ""))
                        ? "yes"
                        : "No"),
                      trailing: Checkbox(
        activeColor: Colors.green,
        value: selec[c.identifier],
        onChanged: (bool value) {
         if(value)
         {
           setState(() {
           selec[c.identifier]=value;
           selectContacts.add(c.phones.elementAt(0).value);
         });
           
           
         }
         else
         {
          setState(() {
           selec[c.identifier]=value;
           selectContacts.remove(c.phones.elementAt(0).value);
         });
           
           
         }
        }),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

