// ignore_for_file: unnecessary_null_comparison

import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Constants/networkImage.dart';
import 'package:anaj_bazar/Controllers/cartControllers.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Controllers/locationControllers.dart';
import 'package:anaj_bazar/Screens/Home/search.dart';
import 'package:anaj_bazar/Screens/Location/myAdresses.dart';
import 'package:anaj_bazar/Screens/Products/mycart.dart';
import 'package:anaj_bazar/Screens/Products/productDetails.dart';
import 'package:anaj_bazar/Screens/Products/products.dart';
import 'package:app_settings/app_settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customText.dart';
import '../../Model/homeTab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var isChangeLocation = true;
  @override
  void initState() {
    super.initState();
    homeControllers = Provider.of<HomeControllers>(context, listen: false);

    locationControllers =
        Provider.of<LocationControllers>(context, listen: false);
    getHomeData();
    debugPrint(homeControllers.getToken.toString());
  }

  getHomeData() async {
    await homeControllers.getHomedata(context, true, false);
  }

  LocationControllers locationControllers = LocationControllers();
  HomeControllers homeControllers = HomeControllers();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            CustomSizedBox(
              height: customHeight(context: context, height: .03),
            ),
            appbar(),
            CustomSizedBox(
              height: customHeight(context: context, height: .026),
            ),
            searchBar(),
            CustomSizedBox(
              height: customHeight(context: context, height: .05),
            ),
            categoriesAndTopTrendingList(1),
            CustomSizedBox(
              height: customHeight(context: context, height: .03),
            ),
            categoriesAndTopTrendingList(3),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Column(
      children: [
        PhysicalModel(
          color: Color(0XFFEFEFEF),
          // elevation: 6,
          // shadowColor: Colors.black.withOpacity(.3),
          borderRadius: BorderRadius.circular(40),
          child: TextFormField(
            readOnly: true,
            onTap: () {
              Routes().pushroute(context: context, pages: const SearchScreen());
            },
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchbyproductname,
                prefixIcon: const CustomImage(image: search_image),
                hintStyle: customTextstyle(
                    color: const Color(0XFF727280),
                    fontWeight: FontWeight.w600),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: inputBorder(),
                border: inputBorder(),
                disabledBorder: inputBorder(),
                errorBorder: inputBorder(),
                focusedBorder: inputBorder(),
                focusedErrorBorder: inputBorder()),
          ),
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .03),
        ),
        slider(),
      ],
    );
  }

  Widget categoriesAndTopTrendingList(int type) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTap(
              onTap: () async {
                AppSettings.openAppSettings();
              },
              child: CustomText(
                text: type == 1
                    ? AppLocalizations.of(context)!.shopbycategory
                    : AppLocalizations.of(context)!.dealsoftheday,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: tTextSecondaryColor,
              ),
            ),
            CustomTap(
              onTap: () {
                Provider.of<HomeControllers>(context, listen: false)
                    .changeIndex(2);
              },
              child: CustomText(
                text: type == 3 ? '' : AppLocalizations.of(context)!.seeall,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .03),
        ),
        categoryItems(type)
      ],
    );
  }

  Widget categoryItems(int type) {
    return Consumer<HomeControllers>(builder: (context, value, child) {
      var categories = type == 3
          ? value.homeTabModel?.dealsoftheday
          : value.homeTabModel?.categories;
      var checknull = type == 3
          ? value.homeTabModel?.dealsoftheday
          : value.homeTabModel?.categories;
      var dealsOfday = value.homeTabModel?.dealsoftheday;
      var categoryItems = value.homeTabModel?.categories;
      return value.isLoading
          ? CustomSizedBox(
              height: size(context: context).height * .7,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : categories == null
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: Center(
                    child: CustomText(
                        text: AppLocalizations.of(context)!.errloading),
                  ),
                )
              : checknull?.isEmpty ?? categories == null
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.nodata),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: type == 3 ? 3 / 3.6 : 3 / 4.3,
                          crossAxisCount: type == 3 ? 2 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // var categoriesList = categories[index];
                        // var dealoftheDayproducts = dealsOfday[index];

                        return GridViewProductsList(
                          dealindex: 0,
                          dealsOfday: dealsOfday!,
                          type: type,
                          index: index,
                          categoriesList: categoryItems!,
                        );
                      },
                    );
    });
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: tTransparrentColor),
      borderRadius: BorderRadius.circular(40),
    );
  }

  Widget slider() {
    return Consumer<HomeControllers>(builder: (context, value, child) {
      var banner = value.homeTabModel?.banners;
      return banner?.length != 0
          ? CarouselSlider.builder(
              itemCount: banner?.length ?? 0,
              itemBuilder: (context, index, realIndex) {
                var bannerDetails = banner?[index].imageUrl;
                return CustomTap(
                  onTap: () {
                    var categoryID = banner?[index].categoryId ?? 0;
                    var categoryName = banner?[index].categoryName ?? '';
                    Routes().pushroute(
                        context: context,
                        pages: ProductsPage(
                            categoryId: categoryID, ProductName: categoryName));
                  },
                  child: CustomNetworkImage(
                    image: bannerDetails ?? '',
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    height: customHeight(context: context, height: .2),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                height: customHeight(context: context, height: .2),
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ))
          : Container(
              alignment: Alignment.center,
              height: customHeight(context: context, height: .2),
              child: CustomText(text: AppLocalizations.of(context)!.nodata),
            );
    });
  }

  Widget appbar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        CustomTap(
          onTap: () {
            Routes().pushroute(
              context: context,
              pages: MyAdressesScreen(
                isfromAddADress: true,
                whenNoAdress: false,
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomImage(image: location_image),
                    const CustomSizedBox(
                      width: 15,
                    ),
                    Consumer<LocationControllers>(
                      builder: (context, value, child) => Flexible(
                        child: value.getSelectedAdressIdFromPrefs != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: CustomText(
                                          text: value.homePageadress1,
                                          // .substring(
                                          //     0,
                                          //     value.homePageadress1.length - 1),
                                          fontWeight: FontWeight.w700,
                                          color: tTextSecondaryColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                        ),
                                      ),
                                      // value.isLocationEnabled
                                      //     ?
                                      CustomPadding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: const Icon(Icons.expand_more))
                                      //     :
                                      // const Icon(Icons.expand_less)
                                    ],
                                  ),
                                  CustomSizedBox(
                                    height: customHeight(
                                        context: context, height: .003),
                                  ),
                                  // value.isLocationEnabled
                                  //     ?
                                  CustomText(
                                    text: value.homePgeupdatedAdress,
                                    fontWeight: FontWeight.w500,
                                    color: tTextSecondaryColor,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                  )
                                  // : Container(),
                                ],
                              )
                            : CustomText(
                                text: AppLocalizations.of(context)!.noadress,
                                fontWeight: FontWeight.w700,
                                color: tTextSecondaryColor,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomTap(
                  onTap: () {
                    Routes().pushroute(
                        context: context,
                        pages: const MyCartDetails(
                          isFromMenuScreen: true,
                        ));
                  },
                  child: CustomPadding(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, bottom: 10, right: 10),
                      child: const CustomImage(image: cart_image)))
            ],
          ),
        ),
        Consumer<LocationControllers>(
          builder: (context, value, child) => Positioned(
            right: 13,
            top: value.getSelectedAdressIdFromPrefs != 0 ? -3 : -5,
            child: CustomPadding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CircleAvatar(
                  backgroundColor: tButtonColor,
                  radius: 8,
                  child: Consumer<CartControllers>(
                      builder: (context, value, child) {
                    return FittedBox(
                      child: CustomText(
                        text: value.itemsLength.toString(),
                        fontWeight: FontWeight.w800,
                        color: tPrimaryColor,
                      ),
                    );
                  })),
            ),
          ),
        )
      ],
    );
  }
}

class GridViewProductsList extends StatefulWidget {
  const GridViewProductsList({
    super.key,
    required this.categoriesList,
    required this.dealsOfday,
    required this.index,
    required this.type,
    required this.dealindex,
  });
  final List<TopTrending> categoriesList;
  final List<Dealsoftheday> dealsOfday;
  final int index;
  final int dealindex;
  final int type;

  @override
  State<GridViewProductsList> createState() => _GridViewProductsListState();
}

class _GridViewProductsListState extends State<GridViewProductsList> {
  @override
  Widget build(BuildContext context) {
    return CustomTap(
      onTap: () {
        var isMultipleItems;
        if (widget.type == 3) {
          if (widget.dealsOfday.isNotEmpty) {
            isMultipleItems =
                widget.dealsOfday[widget.index].variants.length > 1
                    ? true
                    : false;
          }
        }

        widget.type == 3
            ? Routes().pushroute(
                context: context,
                pages: ProductDetailsScreen(
                    isMultipleVarients: isMultipleItems,
                    productId: widget.dealsOfday[widget.index].productId))
            : Routes().pushroute(
                context: context,
                pages: ProductsPage(
                  ProductName: widget.categoriesList[widget.index].categoryName,
                  categoryId: widget.categoriesList[widget.index].categoryId,
                ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0XFFFFFAF5),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPadding(
              padding: const EdgeInsets.only(top: 15),
              child: CustomNetworkImage(
                image: widget.type == 3
                    ? widget.dealsOfday[widget.index].imageUrl
                    : widget.categoriesList[widget.index].imageUrl,
                height: customHeight(context: context, height: .08),
                width: customWidth(context: context, width: .3),
                fit: BoxFit.contain,
              ),
            ),
            CustomPadding(
              padding: EdgeInsets.symmetric(
                  vertical: 15, horizontal: widget.type == 3 ? 15 : 0),
              child: Column(
                children: [
                  Text(
                    widget.type == 3
                        ? widget.dealsOfday[widget.index].productName
                        : widget.categoriesList[widget.index].categoryName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: customTextstyle(
                      fontWeight: FontWeight.w700,
                      color: tTextSecondaryColor,
                    ),
                  ),
                  // CustomText(
                  //   text: widget.type == 3
                  //       ? widget.dealsOfday[widget.index].productName
                  //       : widget.categoriesList[widget.index].categoryName,
                  //   fontWeight: FontWeight.w700,
                  //   color: tTextSecondaryColor,
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 2,
                  // ),
                  widget.type == 3
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomPadding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text:
                                        '₹ ${widget.dealsOfday[widget.index].variants[0].sellingPrice.toString()}',
                                    fontWeight: FontWeight.w700,
                                    color: tTextSecondaryColor,
                                  ),
                                  CustomText(
                                    text:
                                        '₹ ${widget.dealsOfday[widget.index].variants[0].price.toString()}',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                    color: tPinkColor,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            CustomText(
                              text:
                                  '${widget.dealsOfday[widget.index].variants[0].metricValue.toString()} ${widget.dealsOfday[widget.index].variants[0].metricType.toString()}',
                              fontWeight: FontWeight.w700,
                              color: tTextSecondaryColor,
                              // fontSize: 12,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
