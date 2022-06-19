import 'package:flutter/material.dart';

class MarkerPill extends StatefulWidget {
  const MarkerPill({Key? key}) : super(key: key);

  @override
  State<MarkerPill> createState() => _MarkerPillState();
}

class _MarkerPillState extends State<MarkerPill> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset.zero,
              )
            ]
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 40,
              child: Divider(height: 3, thickness: 3,color: Colors.grey),
            ),
            const SizedBox(height: 25,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: ClipOval(
                    child: Icon(
                      Icons.location_on,
                      size: 70.0,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Marker",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 30,)
          ],
        )
    );
  }
}