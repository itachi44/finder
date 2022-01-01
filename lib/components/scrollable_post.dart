import 'package:flutter/material.dart';
import 'package:finder/components/loading.dart';

class ScrollablePostView extends StatefulWidget {
  @override
  _ScrollablePostViewState createState() => _ScrollablePostViewState();
}

//TODO: Add search bar on the top
//TODO : show loading view until data is fetching
class _ScrollablePostViewState extends State<ScrollablePostView> {
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(1),
                right: Radius.circular(1),
              ),
              child: Image.asset(
                'assets/images/efe-kurnaz.jpeg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 250,
            height: 100,
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xFF162A49))),
            child: Column(
              children: <Widget>[
                Text("title", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Text(
                      '1 ticket',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "date",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Icon(Icons.place, color: Colors.grey.shade400, size: 16),
                    Text(
                      'Science Park 10 25A',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _buildContent()));
  }
}
