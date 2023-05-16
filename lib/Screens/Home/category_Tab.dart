import 'package:anaj_bazar/Constants/customText.dart';
import 'package:anaj_bazar/Constants/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customNavigation.dart';
import '../../Constants/customPadding.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customTap.dart';
import '../../Controllers/homeControllers.dart';
import '../Products/products.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeControllers>(context, listen: false).getCategorydata();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(
            text: AppLocalizations.of(context)!.shopbycategory,
            color: tPrimaryColor,
            context: context,
            onTap: () {
              Provider.of<HomeControllers>(context, listen: false)
                  .changeIndex(0);
            },
          ),
          backgroundColor: tPrimaryColor,
          body: SingleChildScrollView(
            child: categoriesAndTopTrendingList(),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget categoriesAndTopTrendingList() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: customHeight(context: context, height: .03),
          ),
          categoryItems()
        ],
      ),
    );
  }

  Widget categoryItems() {
    return Consumer<HomeControllers>(builder: (context, value, child) {
      var categories = value.categoryTabModel?.categories;
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
              : value.categoryTabModel!.categories.isEmpty
                  ? CustomSizedBox(
                      height: size(context: context).height * .7,
                      child: Center(
                        child: CustomText(
                            text: AppLocalizations.of(context)!.nodata),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3 / 4,
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var categoriesList = categories[index];
                        return CustomTap(
                          onTap: () {
                            Routes().pushroute(
                                context: context,
                                pages: ProductsPage(
                                  ProductName: categoriesList.categoryName,
                                  categoryId: categoriesList.categoryId,
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFFFFFAF5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: CustomPadding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: CustomNetworkImage(
                                      image: categoriesList.imageUrl,
                                      height: customHeight(
                                          context: context, height: .08),
                                      width: customWidth(
                                          context: context, width: .3),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                CustomPadding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: CustomText(
                                    text: categoriesList.categoryName,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.center,
                                    color: tTextSecondaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
    });
  }
}
