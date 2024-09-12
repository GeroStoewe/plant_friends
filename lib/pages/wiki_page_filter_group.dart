import 'package:flutter/material.dart';
import 'package:plant_friends/pages/wiki_page_filter_result_page.dart';

class GroupFilterPage extends StatelessWidget {
  const GroupFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plants by Group',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Succulents'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'succulents'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tropical Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'tropical plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Climbing Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'climbing plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Flowering Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'flowering plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Trees'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'trees'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Bamboo Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'bamboo plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Air Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'air plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Moss-like Plants'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'moss-like plants'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Ferns'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'ferns'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Palms'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantFilterResultPage(filterType: 'group', filterValue: 'palms'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
