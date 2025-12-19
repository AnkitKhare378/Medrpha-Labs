// shimmer_loading_list.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingList({Key? key, this.itemCount = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: ShimmerListItem(),
        ),
      ),
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget mimics the structure of your RadioListTile address item
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder for the Radio button
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Placeholder for the Title (Address Title)
              Container(
                width: double.infinity,
                height: 14.0,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              // Placeholder for the Subtitle (Formatted Address Line 1)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 12.0,
                color: Colors.white,
              ),
              const SizedBox(height: 4.0),
              // Placeholder for the Subtitle (Formatted Address Line 2)
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 12.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        // Placeholder for the Menu Button
        Container(
          width: 24.0,
          height: 24.0,
          color: Colors.white,
        ),
      ],
    );
  }
}