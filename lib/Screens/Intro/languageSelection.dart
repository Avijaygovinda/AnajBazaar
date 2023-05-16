import 'package:anaj_bazar/Constants/colors.dart';
import 'package:anaj_bazar/Constants/customAppbar.dart';
import 'package:anaj_bazar/Constants/customButton.dart';
import 'package:anaj_bazar/Constants/customPadding.dart';
import 'package:anaj_bazar/Constants/customText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Model/languages/languages_list.dart';
import '../../language.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key, required this.isStartingApp});
  final bool isStartingApp;

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int isSelected = 0;
  int selectedValue = 0;
  AppLanguage appLanguage = AppLanguage();
  @override
  void initState() {
    super.initState();
    fetchLocal();
  }

  fetchLocal() async {
    appLanguage = await Provider.of<AppLanguage>(context, listen: false);
    await appLanguage.fetchLocale();
    print(appLanguage.selectedLanguage);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (appLanguage != '') {
        selectedValue = appLanguage.selectedLanguage;
      } else {
        selectedValue = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        backgroundColor: tPrimaryColor,
        appBar: !widget.isStartingApp
            ? appBar(
                text: AppLocalizations.of(context)!.selectlanguage,
                context: context,
                color: tPrimaryColor)
            : PreferredSize(
                child: Container(), preferredSize: Size.fromHeight(5)),
        body: locationSelectionBody(),
      )),
    );
  }

  Widget locationSelectionBody() {
    return Center(
      child: CustomPadding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isStartingApp
                ? CustomPadding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CustomText(
                      text: AppLocalizations.of(context)!.selectlanguage,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Container(),
            languagesListWidget(),
            CustomPadding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: CustomButton(
                  text: AppLocalizations.of(context)!.submit,
                  onTap: () async {
                    appLanguage.changeLanguage(
                        Locale(LanguagesList.languages[selectedValue]['code']!),
                        widget.isStartingApp,
                        context);

                    await appLanguage.fetchLocale();
                    // setState(() {});
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget languagesListWidget() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: LanguagesList.languages.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            debugPrint('Tapped language');
            setState(() {
              selectedValue = index;
            });
            print(selectedValue);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color:
                        selectedValue != index ? tTabColor : tTabSelectedColor),
                color:
                    selectedValue != index ? tPrimaryColor : tTabSelectedColor),
            child: Row(children: [
              Expanded(
                flex: 8,
                child: Text(
                  LanguagesList.languages[index]['title']!,
                  style: customTextstyle(
                      color: selectedValue != index
                          ? tTextSecondaryColor
                          : tPrimaryColor),
                ),
              ),
              Visibility(
                visible: selectedValue != index ? false : true,
                child: Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.check_circle,
                    color: tPrimaryColor,
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
