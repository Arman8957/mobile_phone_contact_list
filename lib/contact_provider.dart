import 'package:flutter/material.dart';
import 'contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void deleteContact(int index) {
    _contacts.removeAt(index);
    notifyListeners();
  }

  void editContact(int index, String name, String number) {
    _contacts[index].name = name;
    _contacts[index].number = number;
    notifyListeners();
  }
}
