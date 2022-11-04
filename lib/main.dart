import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_channel_poc/channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          ImageDataView(
            key: UniqueKey(),
          ),
          ImageDataView(
            key: UniqueKey(),
          ),
          ImageDataView(
            key: UniqueKey(),
          ),
          ImageDataView(
            key: UniqueKey(),
          ),
          ImageDataView(
            key: UniqueKey(),
          ),
          ImageDataView(
            key: UniqueKey(),
          ),
          ...List.generate(
            15,
            (_) => DataView(
              key: UniqueKey(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  Map<String, dynamic> data = {};
  final dataChannel = DataChannel();

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final value = data.values.elementAt(i);
          return ListTile(
            title: Text(value.toString()),
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    final newData = await dataChannel.getData();
    if (mounted) {
      setState(() => data = newData);
    }
  }
}

class ImageDataView extends StatefulWidget {
  const ImageDataView({super.key});

  @override
  State<ImageDataView> createState() => _ImageDataViewState();
}

class _ImageDataViewState extends State<ImageDataView> {
  Uint8List? data;
  final dataChannel = DataChannel();

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Image(
        image: MemoryImage(data!),
      ),
    );
  }

  Future<void> _refresh() async {
    final newData = await dataChannel.getImage();
    if (mounted) {
      setState(() => data = newData);
    }
  }
}
