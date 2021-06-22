import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class GifyPage extends StatefulWidget {
  @override
  _GifyPageState createState() => _GifyPageState();
}

class _GifyPageState extends State<GifyPage> {
  var url = Uri.parse(
      "https://api.giphy.com/v1/gifs/search?api_key=V19AXbWQFDFH925hbC5ydUBRY4ZHtJso&limit=25&offset=0&rating=G&lang=en&q=");
  final String url2 =
      "https://api.giphy.com/v1/gifs/search?api_key=V19AXbWQFDFH925hbC5ydUBRY4ZHtJso&limit=25&offset=0&rating=G&lang=en&q=";

  final TextEditingController _searchController = TextEditingController();
  bool _showLoading = false;
  var data;

  @override
  void initState() {
    super.initState();
  }

  getData(String searchInput) async {
    _showLoading = true;
    setState(() {});
    final res = await http.get(Uri.parse(url2 + searchInput));
    data = jsonDecode(res.body)["data"];
    setState(() {
      _showLoading = false;
    });

    // if (searchInput != null) {
    //   var uriToUrl = url.toString();
    //   String finalUrl = uriToUrl + searchInput;
    //   print(finalUrl);
    //   url = Uri.parse(finalUrl);
    //   var response = await http.get(url);

    //   setState(() {
    //     data = jsonDecode(response.body)['data'];
    //     print(data);
    //   });
    // } else {
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray800,
      body: Theme(
        data: ThemeData.dark(),
        child: VStack(
          [
            "Giphy App".text.white.xl4.make().objectCenter().p12(),
            [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search Giphy",
                  ),
                ),
              ),
              30.widthBox,
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: () {
                  getData(_searchController.text);
                },
                shape: Vx.roundedSm,
                child: Text('Search'),
              ).h8(context),
            ]
                .hStack(
                  axisSize: MainAxisSize.max,
                  crossAlignment: CrossAxisAlignment.center,
                )
                .p24(),
            if (_showLoading)
              CircularProgressIndicator().centered()
            else
              VxConditional(
                condition: data != null,
                builder: (context) => GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.isMobile ? 2 : 3),
                  itemBuilder: (context, index) {
                    final imgUrl =
                        data[index]["images"]["fixed_height"]["url"].toString();
                    return ZStack(
                      [
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.8),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Image.network(
                          imgUrl,
                          fit: BoxFit.contain,
                        )
                      ],
                      fit: StackFit.expand,
                    ).card.roundedSM.make().p4();
                    // Image.network(
                    //   imgUrl,
                    //   fit: BoxFit.cover,
                    // ).card.roundedSM.make();
                  },
                  itemCount: data.length,
                ),
                fallback: (context) =>
                    "Nothing found".text.gray500.xl3.makeCentered(),
              ).h(context.percentHeight * 70),
          ],
        ).p16().scrollVertical(
              physics: NeverScrollableScrollPhysics(),
            ),
      ),
    );
  }
}
