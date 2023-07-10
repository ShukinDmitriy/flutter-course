import 'package:chat_app/components/shimmer-loading.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';

import '../models/message.dart';

class MessageItem extends StatelessWidget {
  final bool isShimmer;
  final Message? message;

  const MessageItem({this.message, this.isShimmer = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return ShimmerLoading(
          isLoading: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 75.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                          color: Color(0xffe1e1e1),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Container(
                      width: 120.0,
                      height: 13.0,
                      decoration: const BoxDecoration(
                          color: Color(0xffe1e1e1),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Container(
                      width: 150.0,
                      height: 16.0,
                      decoration: const BoxDecoration(
                          color: Color(0xffe1e1e1),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ],
                ),
              ],
            ),
          ));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                message!.userId.substring(0, 8),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(StringToHex.toColor(StringToHex.toHexString(message!.userId.substring(0, 6))))),
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                timeago.format(message!.timestamp),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                  fontSize: 13.0,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            message!.text,
            style: const TextStyle(fontSize: 16.0),
          )
        ],
      ),
    );
  }
}
