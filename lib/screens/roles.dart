import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/screens/phone.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:Niajiri/controllers/signup_controllers.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';


class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  String valueChoose = "Employee";
  var items = ["Employee", "Employer"];
  final fullNameFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Choose your account type",style:TextStyle(fontSize:25,fontWeight:FontWeight.bold)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 450, 
                      child: CreateFormSegment()
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  String valueChoose = "Employee";
  var items = ["Employee", "Employer"];
  final fullNameFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          FadeInUpBig(
              child: const Text("Choose your account type",style:TextStyle(fontSize:25,fontWeight:FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical:30),
            child:CreateFormSegment()
          ),
        ]));
  }
}


class CreateFormSegment extends StatefulWidget {
  const CreateFormSegment({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  String valueChoose = "Employee";
  var items = ["Employee", "Employer"];
  final roleFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: roleFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        FadeInLeftBig(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *0.8,
            child:DropdownButtonHideUnderline(
              child:ClipRRect(
                borderRadius:BorderRadius.circular(30),
                child: DropdownButton(
                  value: valueChoose,
                  isExpanded:true,
                  hint: const Text('Select account category'),
                  //dropdownColor:AppColors.kPrimaryColor,
                  style: const TextStyle(
                    color:AppColors.kPrimaryColor,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (newValue) {
                    setState((){
                      valueChoose = newValue!;
                    });
                  },
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                ),
              )
            ),
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        isloading
        ? const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation(AppColors.kPrimaryColor),)
        : FadeInRightBig(
          child: CustomBtn(
              label: 'Continue'.toUpperCase(),
              tag: "Continue_btn",
              onPressed: () async{
                if (roleFormKey.currentState!.validate()) {
                  setState(() {
                    isloading = true;
                  });
                  final user = CustomModel(
                    role: valueChoose,  
                  );
                  await AuthRepository.instance
                  .updateRole(context, user)
                  .then((value) {
                    setState(() {
                      isloading = false;
                    });
                    roleFormKey.currentState!.reset();
                    Get.to(()=>const PhoneScreen());
                  }).onError((e, stackTrace) {
                    setState(() {
                      isloading = false;
                    });
                  });
                }
              }),
        ),
      ]),
    );
  }
}