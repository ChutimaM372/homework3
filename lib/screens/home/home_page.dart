import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<TodoItem>? _itemList;
  String? _error;
  int _uniqueNumber = 1;


  void getTodos() async {
    try {
      setState(() {
        _error = null;
      });



      final response =
      await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<dynamic> list = json.decode(response.data);
        setState(() {
          _itemList = list.map((item) => TodoItem.fromJson(item)).toList();
        });
      } else {
        throw Exception('เกิดข้อผิดพลาดในการโหลดข้อมูล');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  void incrementUniqueNumber() {
    setState(() {
      _uniqueNumber++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getTodos();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _itemList!.length,
              itemBuilder: (context, index) {
                var todoItem = _itemList![index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todoItem.title, style: TextStyle(fontSize: 18)),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: Color(0xDAFD89AE),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(11.0),
                              ),
                              child: Text(
                                'Album ID: $_uniqueNumber ',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 6), // ระยะห่างระหว่างข้อความ
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: Color(0xDD7CCBFD),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(11.0),
                              ),
                              child: Text(
                                'User ID: $_uniqueNumber ',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );

    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Photo Albums')),
      ),
      body: body,
    );
  }
}
