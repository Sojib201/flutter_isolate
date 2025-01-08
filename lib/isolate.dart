import 'dart:isolate';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/gif/gif.gif'),
              ElevatedButton(
                onPressed: () async {
                  var total = await complexTask1();
                  debugPrint('Result 1: $total');
                },
                child: Text('Task 1'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  await Isolate.spawn(complexTask2, receivePort.sendPort);
                  receivePort.listen((total) {
                    debugPrint('Result 2: $total');
                  });
                },
                child: Text('Task 2'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final receivePort = ReceivePort();
                  await Isolate.spawn(
                    complexTask3,
                    Task3(9879800000, receivePort.sendPort),
                  );
                  receivePort.listen((total3) {
                    debugPrint('Result 3: $total3');
                  });
                },
                child: Text('Task 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> complexTask1() async {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}
//--End of HomePage--

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1100000000; i++) {
    total += i;
  }
  sendPort.send(total);
}

class Task3 {
  final int iteration;
  final SendPort sendPort;

  Task3(this.iteration, this.sendPort);
}

complexTask3(Task3 data) {
  var total3 = 0.0;
  for (var i = 0; i < data.iteration; i++) {
    total3 += i;
  }
  data.sendPort.send(total3);
}
