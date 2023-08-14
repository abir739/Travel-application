import 'package:flutter/material.dart';

import '../modele/Event/Event.dart';

import 'package:get/get.dart';
class EventView extends StatelessWidget {
  final CalendarEvent event; // Replace with your event class

  EventView({required this.event});
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title ??
                  'No title', // Assuming your event class has a 'title' property
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(event.description ?? 'no description '),
            // SizedBox(height: Get.height*0.2,
            //   child: Expanded(
            //     child: Markdown(
            //       controller: controller,
            //       selectable: true, softLineBreak: true,
            //       data: "Insert emoji :smiley: &#9787; 😇	😈 here",
            //       extensionSet: md.ExtensionSet(
            //         md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            //         <md.InlineSyntax>[
            //           md.EmojiSyntax(),
            //           ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            //         ],
            //       ),
            //       styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            //       onTapLink: (url, text, title) {
            //         // Implement your custom onTapLink behavior
            //         // This is called when a link is tapped
            //       },
            //       imageBuilder: (uri, title, alt) {
            //         // Implement your custom imageBuilder
            //         // This is called to display images
            //         return YourCustomImageWidget(uri: uri, alt: alt ?? " ");
            //       },
            //       // You can customize other parameters as needed
            //     ),
            //   ),
            // ),
            Text(event.id ?? 'no id '), // Replace with appropriate property
            // You can display other event properties here
          ],
        ),
      ),
    );
  }
}

class YourCustomImageWidget extends StatelessWidget {
  final Uri uri;

  final String alt;

  YourCustomImageWidget({
    required this.uri,
    required this.alt,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your custom image widget here
    // You can use the provided 'uri', 'title', and 'alt' properties
    // to construct and display the image as desired.
    return Image.network(uri.toString(), semanticLabel: alt);
  }
}
