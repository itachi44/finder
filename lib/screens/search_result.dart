import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  final dynamic searchResult;
  SearchResultPage({Key key, this.searchResult}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  dynamic searchResultList;
  @override
  void initState() {
    super.initState();
    searchResultList = widget.searchResult;
  }

  Widget resultCard(
      {String img, String title, String date, String price, String location}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(1),
                right: Radius.circular(1),
              ),
              child: Image.asset(
                'assets/images/onboarding2.jpeg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 360,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF162A49), width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 95),
                  child: Container(
                    width: 250,
                    child: Text("Un magnifique appartement près de la mer",
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 120),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '20-01-2022',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "300 \$",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 10),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 100),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.place, color: Colors.grey.shade400, size: 16),
                      Expanded(
                        child: Text(
                          'Dakar, Plateau Avenue Lamine Gueye',
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Color(0xFF162A49), fontSize: 13),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Column(
      children: [
        for (var result in searchResultList)
          resultCard(
              img: result["img"],
              title: result["title"],
              date: result["date"],
              price: result["price"],
              location: result["location"])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Results",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: resultCard(),
    ));
  }
}
