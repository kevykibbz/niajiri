import 'package:Niajiri/components/nodata.dart';
import 'package:Niajiri/employer/proposal.dart';
import 'package:Niajiri/widgets/carousel_slider.dart';
import 'package:Niajiri/widgets/page_wrapper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/controllers/product_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/theme/colors.dart';

final ProductController controller = Get.put(ProductController());

class SelectedSkillPage extends StatefulWidget {
  final String employeeId;
  final String docId;
  const SelectedSkillPage(
      {super.key, required this.employeeId, required this.docId});

  @override
  State<SelectedSkillPage> createState() => _SelectedSkillPageState();
}

class _SelectedSkillPageState extends State<SelectedSkillPage> {
  String fullname = '';
  String rating = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.employeeId)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      setState(() {
        fullname = dataRef["FullName"];
        rating = dataRef["Rating"].toString();
        bio = dataRef["Bio"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> mediaStream = FirebaseFirestore.instance
        .collection("photos")
        .where(widget.employeeId, isEqualTo: true)
        .snapshots();

    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppColors.kPrimaryColorTwo,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: mediaStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.kPrimaryColor,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      } else {
                        final snap = snapshot.data!.docs;
                        if (snap.isEmpty) {
                          return const Nodata(message: "No media found.");
                        }
                        return productPageView(width, height, snap);
                      }
                    }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInLeftBig(
                        child: Text(
                          fullname,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInRightBig(
                        child: _ratingBar(
                          context: context,
                          rating: rating,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInLeftBig(
                        child: const Text(
                          "Bio",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInRightBig(child: Text(bio)),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: FadeInUpBig(
          child: SizedBox(
            width: size.width,
            height: 90,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    width: size.width - 70,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.kPrimaryColor,
                          AppColors.kPrimaryColorTwo
                        ],
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ProposalScreen(
                                employeeId: widget.employeeId,
                                docId: widget.docId,
                              ));
                        },
                        child: Text(
                          "Continue".toUpperCase(),
                          style: const TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget productPageView(double width, double height, snap) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: CarouselSlider(
        items: snap.map((pic) {
          return pic["Media"];
        }).toList(),
      ),
    );
  }

  Widget _ratingBar({required BuildContext context, required String rating}) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: double.tryParse(rating) as double,
          ignoreGestures: true,
          itemSize: 25,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
        ),
        Text(
          rating.toString(),
        )
      ],
    );
  }
}
