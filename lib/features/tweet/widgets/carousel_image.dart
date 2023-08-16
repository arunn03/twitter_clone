import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({super.key, required this.imageLinks});

  final List<String> imageLinks;

  @override
  State<CarouselImage> createState() {
    return _CarouselImageState();
  }
}

class _CarouselImageState extends State<CarouselImage> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map((image) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 10),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Pallete.greyColor.withOpacity(.2),
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    height: 300,
                    width: double.infinity,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _imageIndex = index;
                  });
                },
              ),
            ),
            if (widget.imageLinks.length > 1) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageLinks.map((e) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _imageIndex == widget.imageLinks.indexOf(e)
                          ? Pallete.whiteColor
                          : Pallete.whiteColor.withOpacity(.3),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
