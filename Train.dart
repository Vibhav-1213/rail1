// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;

class TrainPage extends StatefulWidget {
  Map items;
  String fromStation;
  String toStation;
  TrainPage({
    super.key,
    required this.items,
    required this.fromStation,
    required this.toStation,
  });
  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  bool loading = true;
  List trainInfo = [];

  Future<void> getRelevantTrainData() async {
    // for (var element in widget.items["data"]) {
    //   final queryParameters = {
    //     'trainNo': element["train_number"],
    //   };

    //   http.Response response = await http.get(
    //       Uri.https('irctc1.p.rapidapi.com', '/api/v1/getTrainSchedule',
    //           queryParameters),
    //       headers: {
    //         'X-RapidAPI-Key':
    //             'c4e4d2b032mshd1829607d4a7c66p1adda2jsnaa8893ec0075',
    //         'X-RapidAPI-Host': 'irctc1.p.rapidapi.com'
    //       });
    //   log(response.body);
    //   await Future.delayed(const Duration(seconds: 2));

    //   if (response.statusCode == 200) {
    //     trainInfo.insert(trainInfo.length, json.decode(response.body));
    //   }
    // }

    // log(trainInfo.length.toString());
    final String response =
        await rootBundle.loadString('assets/Responses.json');
    final data = await json.decode(response);
    trainInfo = data["trainInfo"];
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getRelevantTrainData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trains from ${widget.fromStation} to ${widget.toStation}"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.items["data"].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text(
                            widget.items["data"][index]["train_name"].length >
                                    20
                                ? widget.items["data"][index]["train_name"]
                                        .substring(0, 20) +
                                    "..."
                                : widget.items["data"][index]["train_name"],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            widget.items["data"][index]
                                    ["train_origin_station_code"] +
                                " - " +
                                widget.items["data"][index]
                                    ["train_destination_station_code"] +
                                " | " +
                                widget.items["data"][index]["depart_time"]
                                    .substring(0, 5) +
                                " - " +
                                widget.items["data"][index]["arrival_time"]
                                    .substring(0, 5),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17)),
                        leading: Text(
                            widget.items["data"][index]["train_number"],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.trailing,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: trainInfo[index]["data"] == {} ||
                                trainInfo[index]["data"] == null
                            ? [
                                const Text(
                                    "No Information is available on this Train",
                                    style: const TextStyle(color: Colors.white))
                              ]
                            : [
                                Text(
                                    widget.items["data"][index]["distance"] +
                                        " km",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    widget.items["data"][index]["run_days"]
                                        .map((e) => e.substring(0, 2))
                                        .join(", "),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    widget.items["data"][index]["class_type"]
                                        .join(", "),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                  (trainInfo[index]["data"]["route"] as List)
                                          .where((element) =>
                                              element["station_code"] ==
                                              widget.fromStation)
                                          .toList()
                                          .isEmpty
                                      ? "Train Doesn't stop at " +
                                          widget.fromStation
                                      : "Platform Number at " +
                                          widget.fromStation +
                                          " : " +
                                          (trainInfo[index]["data"]["route"]
                                                  as List)
                                              .where((element) =>
                                                  element["station_code"] ==
                                                  widget.fromStation)
                                              .toList()[0]["platform_number"]
                                              .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  (trainInfo[index]["data"]["route"] as List)
                                          .where((element) =>
                                              element["station_code"] ==
                                              widget.toStation)
                                          .toList()
                                          .isEmpty
                                      ? "Train Doesn't stop at " +
                                          widget.toStation
                                      : "Platform Number at " +
                                          widget.toStation +
                                          " : " +
                                          (trainInfo[index]["data"]["route"]
                                                  as List)
                                              .where((element) =>
                                                  element["station_code"] ==
                                                  widget.toStation)
                                              .toList()[0]["platform_number"]
                                              .toString(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                      ),
                      const Divider(
                        color: Colors.white,
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Text(widget.items["data"][index]["train_name"],
//                     style: TextStyle(color: Colors.white)),
//                 Text(widget.items["data"][index]["train_number"],
//                     style: TextStyle(color: Colors.white)),
//                 Text(
//                     widget.items["data"][index]["train_origin_station_code"] +
//                         " - " +
//                         widget.items["data"][index]
//                             ["train_destination_station_code"],
//                     style: TextStyle(color: Colors.white)),
//                 Text(widget.items["data"][index]["depart_time"],
//                     style: TextStyle(color: Colors.white)),
//                 Text(widget.items["data"][index]["arrival_time"],
//                     style: TextStyle(color: Colors.white)),
//                 Text(widget.items["data"][index]["distance"] + " km",
//                     style: TextStyle(color: Colors.white)),
//               ],
//             ),
//           );
