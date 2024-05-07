import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../../components/app_scaffold.dart';

class EnlargeImageViewScreen extends StatefulWidget {
  final String filePath;

  const EnlargeImageViewScreen(this.filePath, {Key? key}) : super(key: key);

  @override
  EnlargeImageViewState createState() => EnlargeImageViewState();
}

class EnlargeImageViewState extends State<EnlargeImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            elevation: 0.0,
            leading: InkWell(
                onTap: () => Get.back(),
                child: const Icon(Icons.clear, color: Colors.white))),
        body: PhotoView(imageProvider: Image.network(widget.filePath).image));
  }
}
