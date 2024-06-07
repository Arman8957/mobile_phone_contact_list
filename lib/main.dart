import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contact_provider.dart';
import 'contact.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.grey[800], // Header color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10, width: double.infinity,),
                ElevatedButton(

                  onPressed: () {
                    final name = nameController.text;
                    final number = numberController.text;
                    if (name.isNotEmpty && number.isNotEmpty) {
                      final contact = Contact(name, number);
                      Provider.of<ContactProvider>(context, listen: false)
                          .addContact(contact);
                      nameController.clear();
                      numberController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.grey[700], // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Add', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ContactProvider>(
              builder: (context, contactProvider, child) {
                return ListView.builder(
                  itemCount: contactProvider.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contactProvider.contacts[index];
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Contact'),
                            content: Text('Are you sure you want to delete ${contact.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<ContactProvider>(context, listen: false)
                                      .deleteContact(index);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(contact.name),
                        subtitle: Text(contact.number),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Edit') {
                              nameController.text = contact.name;
                              numberController.text = contact.number;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Edit Contact'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                        ),
                                      ),
                                      TextField(
                                        controller: numberController,
                                        decoration: InputDecoration(
                                          labelText: 'Number',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (nameController.text.isNotEmpty &&
                                            numberController.text.isNotEmpty) {
                                          Provider.of<ContactProvider>(context, listen: false)
                                              .editContact(index, nameController.text, numberController.text);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (value == 'Delete') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Contact'),
                                  content: Text('Are you sure you want to delete ${contact.name}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<ContactProvider>(context, listen: false)
                                            .deleteContact(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
