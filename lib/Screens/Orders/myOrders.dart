import 'package:anaj_bazar/Constants/customImage.dart';
import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customTap.dart';
import 'package:anaj_bazar/Constants/images.dart';
import 'package:anaj_bazar/Controllers/orderControllers.dart';
import 'package:anaj_bazar/Screens/Home/tabs.dart';
import 'package:anaj_bazar/Screens/Orders/orderDetails.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Constants/colors.dart';
import '../../Constants/customAppbar.dart';
import '../../Constants/customMediaQuery.dart';
import '../../Constants/customSizedBox.dart';
import '../../Constants/customText.dart';
import '../../Model/currentorders.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key, required this.isFromOrderConfirm});
  final bool isFromOrderConfirm;

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    Provider.of<OrdersControllers>(context, listen: false)
        .getCurrentOrders(true);
    // Provider.of<OrdersControllers>(context, listen: false)
    //     .getCurrentOrders(false);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        // ordersListsLength = 0;
        // ordersLists.clear();
        Provider.of<OrdersControllers>(context, listen: false)
            .getCurrentOrders(true);
      } else {
        // ordersListsLength = 0;
        // ordersLists.clear();
        Provider.of<OrdersControllers>(context, listen: false)
            .getCurrentOrders(false);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final pagestorekey = const PageStorageKey<String>('controllerA');
  final pagestorekey2 = const PageStorageKey<String>('controllerB');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.isFromOrderConfirm
            ? Routes().pushroute(context: context, pages: HomeScreenTabs())
            : Navigator.pop(context);
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Material(
          child: SafeArea(
            child: Scaffold(
                appBar: customappbar(),
                backgroundColor: tPrimaryColor,
                body: tabBarBody()),
          ),
        ),
      ),
    );
  }

  Widget tabBarBody() {
    return CustomPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          orders(1),
          orders(0),
        ],
      ),
    );
  }

  Widget noOrdersContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: CustomImage(
          image: no_orders_image,
          height: customHeight(context: context, height: .4),
          width: customWidth(context: context, width: .8),
          fit: BoxFit.contain,
        )),
        CustomPadding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: CustomText(
            text: AppLocalizations.of(context)!.norders,
            fontSize: 23,
            color: tTextSecondaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomText(
          textAlign: TextAlign.center,
          text: AppLocalizations.of(context)!.lookslikenoorders,
          fontSize: 17,
          // color: tTextSecondaryColor,
          // fontWeight: FontWeight.w700,
        ),
        CustomSizedBox(
          height: customHeight(context: context, height: .04),
        )
      ],
    );
  }

  Widget orders(int isCurrent) {
    return Consumer<OrdersControllers>(builder: (context, value, child) {
      var myOrders = isCurrent == 1
          ? value.currentOrdersModel?.orders
          : value.pastOrdersModel?.orders;
      return value.isLoading
          ? CustomSizedBox(
              height: size(context: context).height * .7,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : myOrders?.length == null
              ? CustomSizedBox(
                  height: size(context: context).height * .7,
                  child: Center(
                    child: CustomText(
                        text: AppLocalizations.of(context)!.errloading),
                  ),
                )
              : myOrders?.length == 0
                  ? noOrdersContainer()
                  : ListView.builder(
                      itemCount: myOrders?.length,
                      padding: const EdgeInsets.only(top: 40),
                      shrinkWrap: true,
                      key: isCurrent == 1 ? pagestorekey : pagestorekey2,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var orders = myOrders?[index];
                        return OrdersList(
                          isCurrent: isCurrent,
                          orders: orders,
                        );
                        // return ordersDetails(isCurrent, orders);
                      },
                    );
    });
  }

  // Widget ordersDetails(
  //   int isCurrent,
  //   Order? orders,
  // ) {
  //   return
  // }

  PreferredSizeWidget customappbar() {
    return appBar(
      text: AppLocalizations.of(context)!.myorders,
      context: context,
      onTap: () {
        widget.isFromOrderConfirm
            ? Routes().pushroute(context: context, pages: HomeScreenTabs())
            : Navigator.pop(context);
      },
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              decoration: const BoxDecoration(
                  color: tProductsbgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0,
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: tButtonColor),
                labelColor: tPrimaryColor,
                unselectedLabelColor: tTextColor,
                labelStyle: customTextstyle(
                    // color: tPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                unselectedLabelStyle: customTextstyle(
                    // color: tTabColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
                physics: const BouncingScrollPhysics(),
                indicatorColor: tPrimaryColor,
                dragStartBehavior: DragStartBehavior.start,
                tabs: [
                  Tab(
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.currentorders,
                    )),
                  ),
                  Tab(
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.pastorders,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrdersList extends StatefulWidget {
  const OrdersList({super.key, this.orders, required this.isCurrent});
  final Order? orders;
  final int isCurrent;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<String> ordersLists = [];
  List<String> filterList = [];
  var filterOrders;
  int ordersListsLength = 0;
  String commas = ',';
  @override
  Widget build(BuildContext context) {
    return CustomTap(
      onTap: () {
        Routes().pushroute(
            context: context,
            pages: OrdersDetailsScreen(
              orderId: widget.orders?.orderId ?? 0,
              isPastOrders: widget.isCurrent,
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text:
                    '${AppLocalizations.of(context)!.orderidorders} ${widget.orders?.orderId.toString()}',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: tTextSecondaryColor,
              ),
              CustomText(
                text: '₹${widget.orders?.grandTotal.toString()}',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: tTextSecondaryColor,
              ),
            ],
          ),
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomText(
              text:
                  '${widget.orders?.itemsCount.toString()} ${AppLocalizations.of(context)!.items}',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: tTextSecondaryColor,
            ),
          ),
          checkRowLists(widget.orders),
          widget.isCurrent == 1
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomPadding(
                        padding: EdgeInsets.only(right: 10),
                        child: CustomImage(
                          image: widget.orders?.orderStatus == 1
                              ? delivered_image
                              : cancelled_image,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        )),
                    CustomPadding(
                      padding: EdgeInsets.only(top: 10),
                      child: CustomText(
                        text: widget.orders?.orderStatus == 1
                            ? AppLocalizations.of(context)!.delivered
                            : widget.orders?.orderStatus == 3
                                ? AppLocalizations.of(context)!.cancelledbyuser
                                : widget.orders?.orderStatus == 4
                                    ? AppLocalizations.of(context)!
                                        .cancelledbyadmin
                                    : '',
                        fontSize: 16,
                        color: Color(0XFF23AA49),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
          CustomPadding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: tDividerColor,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget checkRowLists(
    Order? orders,
  ) {
    // List<Widget> rowWidget = <Widget>[];
    for (var i = 0; i < orders!.orderItems.length; i++) {
      var names = orders.orderItems[i].productName;
      var quantity = orders.orderItems[i].quantity.toString();
      ordersListsLength = orders.orderItems.length;
      ordersLists.add('${names} x${quantity},');
      if (ordersLists.length <= 1) {
        filterOrders = ordersLists[0].substring(0, ordersLists[0].length - 1);
        // print(filterOrders);
        // print(ordersListsLength);
      }
      // rowWidget.add(CustomText(
      //   text: '${names} x${quantity},',
      // color: tTextSecondaryColor,
      // fontWeight: FontWeight.w500,
      //   overflow: TextOverflow.ellipsis,
      //   maxLines: 1,
      // ));
    }

    // print(ordersLists.join());

    return Text(
      '$filterOrders${ordersListsLength > 1 ? ',' : ''} ${ordersListsLength < 2 ? '' : ordersLists[1]} ${ordersListsLength < 3 ? '' : ordersLists[2]} ${ordersListsLength < 4 ? '' : ordersLists[3]} ${ordersListsLength < 5 ? '' : ordersLists[4]}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: customTextstyle(
          fontSize: 15,
          color: tTextSecondaryColor,
          fontWeight: FontWeight.w400),
    );
  }
}
