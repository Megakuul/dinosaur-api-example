import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class dinosaurList extends StatefulWidget {
  const dinosaurList({this.list});

  final List<dynamic>? list;

  @override
  State<dinosaurList> createState() => _dinosaurListState();
}

class _dinosaurListState extends State<dinosaurList> {

  Expanded title(String text) {
    return Expanded(
      child: Text(text, style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.grey,

            borderRadius: BorderRadius.circular(8),
          ),
          height: 50,
          child: Row(
            children: [
              title("Dinosaur name"),
              title("Description"),
              title("Creator"),
              title("Creation time")
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height / 10 * 6
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 10 * 6,
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: widget.list!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text('${widget.list![index]['name']}'),
                      ),
                      Expanded(
                        child: Text('${widget.list![index]['description']}'),
                      ),
                      Expanded(
                        child: Text('${widget.list![index]['creator']}'),
                      ),
                      Expanded(
                        child: Text(DateFormat.yMMMMd().format(DateTime.parse(widget.list![index]['creationTime']))),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            )
          )
        )
      ],
    );
  }
}