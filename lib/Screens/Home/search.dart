// ignore_for_file: unnecessary_null_comparison

import 'package:anaj_bazar/Constants/customMediaQuery.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customSizedBox.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/networkImage.dart';
import 'package:anaj_bazar/Controllers/homeControllers.dart';
import 'package:anaj_bazar/Screens/Products/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customImage.dart';
import '../../Constants/customText.dart';
import '../../Constants/images.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    homeControllers = Provider.of<HomeControllers>(context, listen: false);
    homeControllers.resetSearchString();

    controller.addListener(() {
      homeControllers.getSearchProducts(controller.text);
    });
  }

  HomeControllers homeControllers = HomeControllers();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar(
              text: AppLocalizations.of(context)!.search, context: context),
          backgroundColor: tPrimaryColor,
          body: searchDetails(),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Column(
      children: [
        PhysicalModel(
          color: tPrimaryColor,
          elevation: 6,
          shadowColor: Colors.black.withOpacity(.3),
          borderRadius: BorderRadius.circular(40),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {
              Provider.of<HomeControllers>(context, listen: false)
                  .onChangedTexts(value);
            },
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchbyproductname,
                prefixIcon: CustomImage(
                  image: search_image,
                  color: Color(0XFF000000).withOpacity(.5),
                ),
                suffixIcon: CustomTap(
                  onTap: () {
                    controller.clear();
                    Provider.of<HomeControllers>(context, listen: false)
                        .resetSearchString();
                  },
                  child: CustomPadding(
                    padding: EdgeInsets.all(10),
                    child: CustomImage(
                      image: cancelled_image,
                      color: Color(0XFF000000).withOpacity(.5),
                    ),
                  ),
                ),
                hintStyle: customTextstyle(
                    color: Color(0XFF727280), fontWeight: FontWeight.w600),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                enabledBorder: inputBorder(),
                border: inputBorder(),
                disabledBorder: inputBorder(),
                errorBorder: inputBorder(),
                focusedBorder: inputBorder(),
                focusedErrorBorder: inputBorder()),
          ),
        ),
      ],
    );
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: tTransparrentColor),
      borderRadius: BorderRadius.circular(40),
    );
  }

  Widget searchListItems() {
    return Flexible(
      child: Consumer<HomeControllers>(
        builder: (context, value, child) => value.isLoading
            ? CustomSizedBox(
                height: size(context: context).height * .7,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : value.productsList.length == null
                ? CustomSizedBox(
                    height: size(context: context).height * .7,
                    child: Center(
                      child: CustomText(
                          text: AppLocalizations.of(context)!.errloading),
                    ),
                  )
                : value.productsList.isEmpty
                    ? noresults()
                    : ListView.builder(
                        itemCount: value.productsList.length,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var searchProducts = value.productsList[index];
                          var sellingPrice =
                              searchProducts['variants'][0]['sellingPrice'];
                          var Price = searchProducts['variants'][0]['price'];
                          var percentages =
                              (Price - sellingPrice) / Price * 100;
                          return CustomTap(
                            onTap: () async {
                              var isMultipleItems =
                                  searchProducts['variants'].length > 1
                                      ? true
                                      : false;
                              Routes().pushroute(
                                  context: context,
                                  pages: ProductDetailsScreen(
                                    isMultipleVarients: isMultipleItems,
                                    productId: searchProducts['productId'],
                                  ));
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                percentages == 0
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(bottom: 1),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 5),
                                        child: CustomText(
                                          textAlign: TextAlign.center,
                                          text:
                                              '${percentages.toStringAsFixed(0)}% OFF',
                                          fontSize: 12,
                                          color: tPrimaryColor,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0XFF643D22),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                      ),
                                Row(
                                  children: [
                                    CustomPadding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: tTransparrentColor,
                                        child: ClipOval(
                                          child: CustomNetworkImage(
                                            image: searchProducts['imageUrl'],
                                            fit: BoxFit.contain,
                                            width: customWidth(
                                                context: context, width: .3),
                                            height: customHeight(
                                                context: context, height: .15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: searchProducts['productName'],
                                            color: tTextSecondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          CustomPadding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7),
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  text:
                                                      searchProducts['variants']
                                                              [0]['metricValue']
                                                          .toString(),
                                                  color: tPinkColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                                CustomText(
                                                  text:
                                                      searchProducts['variants']
                                                              [0]['metricType']
                                                          .toString(),
                                                  color: tTextColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                                searchProducts['variants']
                                                            .length >
                                                        1
                                                    ? Icon(
                                                        Icons.expand_more,
                                                        size: 20,
                                                        color: tTextColor,
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                text: '₹${sellingPrice} ',
                                                color: tTextSecondaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              sellingPrice == Price
                                                  ? Container()
                                                  : CustomText(
                                                      text: '₹${Price}',
                                                      color: tPinkColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                CustomPadding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    color: tDividerColor,
                                    thickness: .5,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget noresults() {
    return controller.text.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                image: noresults_image,
                height: customHeight(context: context, height: .25),
                width: customWidth(context: context, width: .6),
                fit: BoxFit.contain,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.searchnoresult,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              CustomPadding(
                padding: EdgeInsets.only(top: 10),
                child: CustomText(
                  text: AppLocalizations.of(context)!.wecantfindsearch,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomSizedBox(
                height: customHeight(context: context, height: .04),
              ),
              CustomTap(
                onTap: () {
                  Routes().backroute(context: context);
                },
                child: CustomText(
                  text: AppLocalizations.of(context)!.backtohome,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: tTransparrentColor,
                  shadows: [
                    Shadow(color: tTextSecondaryColor, offset: Offset(0, -3))
                  ],
                  decorationColor: tTextColor,
                  decoration: TextDecoration.underline,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        : Container();
  }

  Widget searchDetails() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(height: customHeight(context: context, height: .015)),
          searchBar(),
          Consumer<HomeControllers>(
            builder: (context, value, child) => value.onChangesText.isEmpty
                ? Container()
                : CustomPadding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        CustomText(
                          text: AppLocalizations.of(context)!.showingresults,
                          color: tTextSecondaryColor,
                          fontSize: 16,
                        ),
                        CustomText(
                          text: ' “${value.onChangesText}”',
                          color: tTextSecondaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ],
                    )),
          ),
          searchListItems()
        ],
      ),
    );
  }
}
