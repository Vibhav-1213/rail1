import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;
import 'Train.dart';

var stringResponse = '';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List STATIONS = [];
  FocusNode fromFocusNode = FocusNode();
  FocusNode toFocusNode = FocusNode();
  String? _selectedtrain;
  TextEditingController fromController = new TextEditingController();
  TextEditingController toController = new TextEditingController();
  Map items = {};

  Future fetchItems() async {
    // final queryParameters = {
    //   'fromStationCode': fromController.text.toLowerCase(),
    //   'toStationCode': toController.text.toLowerCase(),
    // };

    // http.Response response = await http.get(
    //     Uri.https('irctc1.p.rapidapi.com', '/api/v2/trainBetweenStations',
    //         queryParameters),
    //     headers: {
    //       'X-RapidAPI-Key':
    //           'c4e4d2b032mshd1829607d4a7c66p1adda2jsnaa8893ec0075',
    //       'X-RapidAPI-Host': 'irctc1.p.rapidapi.com'
    //     });
    // log(response.body);
    // Future.delayed(const Duration(seconds: 2));

    // if (response.statusCode == 200) {
    //   items = json.decode(response.body);
    // }
    final String response =
        await rootBundle.loadString('assets/Responses.json');
    final data = await json.decode(response);
    items = data["items"];
  }

  Future<void> fetchStationList() async {
    final String response = await rootBundle.loadString('assets/Stations.json');
    final data = await json.decode(response);
    setState(() {
      STATIONS = (data["features"] as List)
          .map((e) => e["properties"]["code"])
          .toList();
      STATIONS.sort();
    });
    log("done");
  }

  @override
  void initState() {
    fetchStationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black87,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.blueAccent,
                height: 4.0,
              ),
            ),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Bookings...',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView(
                      children: [
                        const Align(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Select From Station",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                              ]),
                          child: SearchField(
                            controller: fromController,
                            focusNode: fromFocusNode,
                            suggestions: (STATIONS.isNotEmpty ? STATIONS : [])
                                .map((e) => SearchFieldListItem(e))
                                .toList(),
                            hint: 'Search Departure Station',
                            searchInputDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey.shade200,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.withOpacity(0.8),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            itemHeight: 50,
                            onSubmit: (p0) {
                              setState(() {
                                if (STATIONS.contains(p0.toUpperCase())) {
                                  fromController.text = p0.toUpperCase();
                                  fromFocusNode.unfocus();
                                }
                              });
                            },
                            maxSuggestionsInViewPort: 6,
                            suggestionsDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSuggestionTap: (value) {
                              setState(() {
                                fromController.text = value.searchKey;
                                fromFocusNode.unfocus();
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Select To Station",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                              ]),
                          child: SearchField(
                            controller: toController,
                            focusNode: toFocusNode,
                            suggestions: (STATIONS.isNotEmpty ? STATIONS : [])
                                .map((e) => SearchFieldListItem(e))
                                .toList(),
                            hint: 'Search Arrival Station',
                            searchInputDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey.shade200,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.withOpacity(0.8),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onSubmit: (p0) {
                              setState(() {
                                if (STATIONS.contains(p0.toUpperCase())) {
                                  toController.text = p0.toUpperCase();
                                  toFocusNode.unfocus();
                                }
                              });
                            },
                            itemHeight: 50,
                            maxSuggestionsInViewPort: 6,
                            suggestionsDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSuggestionTap: (value) {
                              setState(() {
                                toController.text = value.searchKey;
                                toFocusNode.unfocus();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (fromController.text.isNotEmpty &&
                                  toController.text.isNotEmpty) {
                                await fetchItems();
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrainPage(
                                              items: items,
                                              fromStation: fromController.text,
                                              toStation: toController.text,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please select both stations")));
                              }
                            },
                            child: Text("Search Trains"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
