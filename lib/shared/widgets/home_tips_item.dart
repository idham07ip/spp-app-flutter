import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTipsItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String url;

  const HomeTipsItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _HomeTipsItemState createState() => _HomeTipsItemState();
}

class _HomeTipsItemState extends State<HomeTipsItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(widget.url)) {
          launch(widget.url);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                widget.imageUrl,
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 11,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              // added Flexible widget
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: isExpanded
                    ? Text(
                        widget.title,
                        style: blackTextStyle.copyWith(
                          fontWeight: regular,
                        ),
                      )
                    : Text(
                        widget.title,
                        style: blackTextStyle.copyWith(
                          fontWeight: regular,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
