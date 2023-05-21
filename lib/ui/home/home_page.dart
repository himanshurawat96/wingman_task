import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wingman_task/ui/home/widgets/bar_action.dart';
import 'package:wingman_task/utils/constants.dart';

class HomePage extends StatefulWidget {
  static const route = "/HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f8f9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(

              decoration: const ShapeDecoration(
                color: K.themeColorPrimary,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.vertical(
                    bottom: SmoothRadius(
                      cornerRadius: 50,
                      cornerSmoothing: 1,
                    ),
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  "https://randomuser.me/api/portraits/men/62.jpg",
                                  height: 45,
                                  width: 45,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(PhosphorIcons.user),
                                    );
                                  },
                                ),
                              ),
                              const Icon(PhosphorIcons.bell_bold, color: Colors.white,),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text("Available Balance", style: TextStyle(
                            color: Colors.white,
                          ),),
                          const Text("AED 12342.12", style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600
                          ),),
                          const SizedBox(height: 70),
                        ],
                      ),
                      Positioned(
                        bottom: -70,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 120,
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 20,
                                  cornerSmoothing: 1,
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0,2),
                                  blurRadius: 15,
                                  spreadRadius: -5,
                                )
                              ]
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: BarAction(
                                  title: "Add Money",
                                  icon: PhosphorIcons.plus_bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: BarAction(
                                  title: "Send Money",
                                  icon: PhosphorIcons.arrows_down_up_bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: BarAction(
                                  title: "Pay Money",
                                  icon: PhosphorIcons.arrow_up_right_bold,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 90)),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0,2),
                      blurRadius: 15,
                      spreadRadius: -5,
                    )
                  ]
              ),
              child: Row(
                children: [
                  Column(
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: K.themeColorPrimary,
                        child: Icon(PhosphorIcons.magnifying_glass_bold, color: Colors.white,),
                      ),
                      SizedBox(height: 10),
                      Text("Search", style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),)
                    ],
                  ),
                  const SizedBox(
                    height:120,
                    width: 40,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: K.themeColorPrimary,
                              backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/62.jpg"),
                              onBackgroundImageError: (exception, stackTrace) => Icon(PhosphorIcons.user, color: Colors.white,),
                            ),
                            const SizedBox(height: 10),
                            const Text("Azeem", style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),)
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 20), itemCount: 6,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0,2),
                      blurRadius: 15,
                      spreadRadius: -5,
                    )
                  ]
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Transactions", style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),),
                      Text("View All", style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),),
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.indigo.withOpacity(0.2),
                            child: const Icon(PhosphorIcons.house_bold, color: Colors.indigo,),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Home", style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),),
                                Text("25 Sept 2022", style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: const [
                              Text('AED 550', style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),),
                              const SizedBox(width: 10),
                              Icon(PhosphorIcons.arrow_up_right_bold, color: Colors.red,)
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

