import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchUserWidget extends StatefulWidget {
  final snap;
  const SearchUserWidget({super.key, required this.snap});

  @override
  State<SearchUserWidget> createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends State<SearchUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.snap['photoUrl']),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                widget.snap['username'],
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close_outlined))
          ],
        ));
  }
}
