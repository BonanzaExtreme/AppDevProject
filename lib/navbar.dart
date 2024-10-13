import 'package:flutter/material.dart';
import 'package:project/favoritescreen.dart';
import 'package:project/notificationscreen.dart';
import 'package:project/settingscreen.dart';

class Navbar extends StatelessWidget{
  const Navbar({super.key});
  
  @override
  Widget build(BuildContext context) {
  
    return Drawer(
     child: Material(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        
        children: [
          Container(
          padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
          child: const Text('Menu',style: TextStyle(color: Colors.black, fontSize: 24),),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            hoverColor: Colors.white,
            onTap: () => selectedItem(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            hoverColor: Colors.white ,
            onTap: () => selectedItem(context, 1),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            hoverColor: Colors.white ,
            onTap: () => selectedItem(context, 2),
          )
        ],
      ),
    ),
    );
    
  }
   void selectedItem(BuildContext context, int index){
      switch(index){
        case 0:
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favoritescreen(),));
          break;
        
        case 1:
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Notificationscreen(),));

        case 2:
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settingscreen(),));
      }
    }
}