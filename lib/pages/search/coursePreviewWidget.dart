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
  CoursePreviewWidget(CoursePreview preview, Future<http.Response> response)
      : _coursePreview = preview,
        _response = response;

  final CoursePreview _coursePreview;
  final Future<http.Response> _response;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            FutureBuilder(
              future: _response,
              builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.statusCode == 200) {
                    return FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: MemoryImage(snapshot.data.bodyBytes),
                      width: 32,
                      height: 32,
                    );
                  }
                  return FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image:
                        NetworkImage(Provider.of<CourseProvider>(context, listen: false).getEmptyLogo(_coursePreview.type)),
                    width: 32,
                    height: 32,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("number".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.number ?? "", style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("subtitle".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.subtitle ?? "", style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("description".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.description ?? "", style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("location".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.location ?? "", style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("start".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.startSemester.title ?? "", style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("end".tr(), style: GoogleFonts.montserrat())],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(_coursePreview.endSemester?.title ?? "unlimited".tr(), style: GoogleFonts.montserrat())],
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Icon(FontAwesome.sign_in))
        ],
      ),
    );
  }
}
