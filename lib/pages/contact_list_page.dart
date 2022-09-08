import 'package:contact_app/auth_prefs.dart';
import 'package:contact_app/db/db_helper.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/contact_provider.dart';
import 'new_contact_page.dart';

class ContactListPage extends StatefulWidget {
  static const String routeName='/contact_list';

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact List'),
      actions: [
        PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  setLoginStatus(false).then((value) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
                },
                child: const Text('Logout'),
              )
            ])
      ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Consumer<ContactProvider>(
          builder:(context, provider, _) =>BottomNavigationBar(
            currentIndex: selectedIndex,
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Colors.white,
              onTap: (value) {
              provider.loadContent(selectedIndex);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                  label: 'All'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorite'
                ),
              ],
          ),
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: ValueKey(contact.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: _showConfirmationDialog,
              onDismissed: (direction) {
                provider.deleteContact(contact.id!);
              },
              background: Container(
                alignment: Alignment.bottomRight,
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white,),
              ),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, ContactListPage.routeName, arguments: contact.id),
                title: Text(contact.name),
                subtitle: Text(contact.number),
                trailing: IconButton(
                  icon: Icon(contact.favorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    final value = contact.favorite ? 0 : 1;
                    provider.updateFavorite(contact.id!, value, index);
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator
              .pushNamed(context, NewContactPage.routeName);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new Contact',
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete Contact'),
      content: const Text('Are you sure to delete this contact?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('YES'),
        ),
      ],
    ));
  }
}
