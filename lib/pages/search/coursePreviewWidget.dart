import 'package:fludip/pages/course/tabs/info.dart';
import 'package:fludip/provider/course/coursePreviewModel.dart';
import 'package:fludip/provider/course/courseProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:easy_localization/easy_localization.dart';

class CoursePreviewWidget extends StatelessWidget {
  CoursePreviewWidget(CoursePreview preview) : _coursePreview = preview;

  final CoursePreview _coursePreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            FutureBuilder(
              future:
                  Provider.of<CourseProvider>(context, listen: false).getImage(_coursePreview.courseID, _coursePreview.type),
              builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
                if (snapshot.hasData) {
                  return FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: snapshot.data,
                    width: 32,
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            VerticalDivider(),
            Flexible(
              child: Text(
                _coursePreview.title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(),
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                InfoLineWidget("number".tr(), _coursePreview.number ?? ""),
                InfoLineWidget("subtitle".tr(), _coursePreview.subtitle ?? ""),
                InfoLineWidget("description".tr(), _coursePreview.description ?? ""),
                InfoLineWidget("location".tr(), _coursePreview.location ?? ""),
                InfoLineWidget("start".tr(), _coursePreview.startSemester.title ?? ""),
                InfoLineWidget("end".tr(), _coursePreview.endSemester?.title ?? "unlimited"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
