import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height * 0.32,
          child: PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (int currentIndex) {
              newIndex = currentIndex;
              setState(() {});
            },
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: FittedBox(
                  fit: BoxFit.none,
                  child: ClipRRect(
                    borderRadius:BorderRadius.circular(10),
                    child: Image.network(widget.items[index], scale: 4),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height:10,),
        SmoothIndicator(
          effect: const WormEffect(
            dotColor: Colors.white,
            activeDotColor: AppColors.kPrimaryColorTwo,
          ),
          offset: newIndex.toDouble(),
          count: widget.items.length,
        )
      ],
    );
  }
}
