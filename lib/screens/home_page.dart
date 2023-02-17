import 'package:flutter/material.dart';
import 'package:sqf_lite/database/database_helper.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<Map<String, dynamic>> _journals = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = true;

  //retrive all the data from database
  void _refresh() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refresh();
    print("..number of items jimmmy: ${_journals.length}");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _descriptionController.text);
    _refresh();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data deleted")));
    _refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
    ("..number of items: ${_journals.length}");
  }

  void _showFrom(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element["id"] == id);
      _titleController.text = existingJournal["title"];
      _descriptionController.text = existingJournal["description"];
    }

    showModalBottomSheet(
        context: context,
        elevation: 20,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "description"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addItem();
                        }
                        if (id != null) {
                         await _updateItem(id);
                        }
                        _titleController.text = "";
                        _descriptionController.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? "Create New" : "Edit"))
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQFLite"),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.pinkAccent,
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_journals[index]['title']),
                    subtitle: Text(_journals[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _showFrom(_journals[index]['id']);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                _deleteItem(_journals[index]['id']);

                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFrom(null),
        child: Icon(Icons.edit),
      ),
    );
  }
}
