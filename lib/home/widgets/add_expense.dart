// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:field_master/auth/bloc/auth_bloc.dart';
// import 'package:field_master/home/home.dart';
// import 'package:field_master/home/widgets/maps_screen.dart';
// import 'package:field_master/main/cubit/main_cubit.dart';
// import 'package:field_master/models/models.dart';
// import 'package:field_master/utils/utils.dart';
// import 'package:field_master/widgets/widgets.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class AddExpense extends StatefulWidget {
//   const AddExpense({super.key});

//   @override
//   State<AddExpense> createState() => _AddExpenseState();
// }

// class _AddExpenseState extends State<AddExpense> {
//   final formkey = GlobalKey<FormState>();
//   final categoryCtlr = TextEditingController();
//   final dateCtlr = TextEditingController();
//   final amount = TextEditingController();
//   final description = TextEditingController();
//   final location = TextEditingController();
//   final ImagePicker picker = ImagePicker();
//   String? category;
//   String? imageGropdownValue;
//   XFile? photo;
//   final now = DateTime.now();
//   final dateFormat = DateFormat('yyyy-MM-dd');
//   Position? locData;
//   LatLng? pickedlocation;
//   @override
//   void initState() {
//     _getCurrentUserLocation();
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final categories = context.read<HomeCubit>().state.expenseCategory;
//       if (categories.isNotEmpty) {
//         category = categories.first.name;
//       }
//       dateCtlr.text = dateFormat.format(now);
//     });
//   }

//   Future<void> _getCurrentUserLocation() async {
//     try {
//       await context.read<MainCubit>().setupLocation();
//       locData = await Geolocator.getCurrentPosition();
//       await _selectLocation(LatLng(locData!.latitude, locData!.longitude));
//       if (mounted) {
//         setState(() {});
//       }
//     } catch (error) {
//       log(error.toString());
//       return;
//     }
//   }

//   Future<void> _selectOnMap() async {
//     final selectedLocation = await Navigator.of(context).push<LatLng>(
//       MaterialPageRoute(
//         builder: (ctx) => MapsScreen(
//           initialLocation: PlaceLocation(
//             latitude: locData!.latitude,
//             longitude: locData!.longitude,
//           ),
//         ),
//       ),
//     );
//     log(selectedLocation.toString());

//     if (selectedLocation == null) {
//       return;
//     }
//     await _selectLocation(
//       LatLng(selectedLocation.latitude, selectedLocation.longitude),
//     );
//   }

//   Future<void> _selectLocation(LatLng selectedLocation) async {
//     log('lat ${selectedLocation.latitude}');
//     log('lng ${selectedLocation.longitude}');
//     location.text = await getAddressFromLatLng(
//       selectedLocation.latitude,
//       selectedLocation.longitude,
//     );
//     // _addressController.text = address;
//     setState(() {
//       pickedlocation = selectedLocation;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final categories = context.read<HomeCubit>().state.expenseCategory;
//     // final expenseCategory = categories.map((e) => e.name).toList();
//     // category ??= expenseCategory.first;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Expense'),
//       ),
//       body: BlocConsumer<HomeCubit, HomeState>(
//         listener: (context, state) {
//           if (state.status == CurrentStatus.saved) {
//             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//               context.read<HomeCubit>().getExpenses();
//               Navigator.pop(context, true);
//             });
//           }
//           if (state.status == CurrentStatus.error) {
//             EasyLoadingService.error(text: state.message);
//           }
//         },
//         builder: (context, state) {
//           return Form(
//             key: formkey,
//             child: AppListViewPage(
//               children: [
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Expense Category'),
//                 DropdownButtonFormField(
//                   decoration: kTextFieldDecoration,
//                   value: category,
//                   items: expenseCategory
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (v) {
//                     category = v;
//                     setState(() {});
//                   },
//                   validator: (value) => validateTxtFiled(value: value),
//                 ),
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Date'),
//                 TextFormField(
//                   decoration: kTextFieldDecoration,
//                   controller: dateCtlr,
//                   textInputAction: TextInputAction.next,
//                   readOnly: true,
//                   onTap: () async {
//                     final pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1950),
//                       lastDate: DateTime(2100),
//                     );

//                     if (pickedDate != null) {
//                       final formattedDate = dateFormat.format(pickedDate);
//                       setState(() {
//                         dateCtlr.text = formattedDate;
//                       });
//                     } else {}
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Amount'),
//                 TextFormField(
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   controller: amount,
//                   textInputAction: TextInputAction.next,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
//                   ],
//                   validator: (value) => validateTxtFiled(value: value),
//                   decoration: kTextFieldDecoration,
//                 ),
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Short description'),
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: description,
//                   textInputAction: TextInputAction.next,
//                   decoration:
//                       kTextFieldDecoration.copyWith(hintText: 'Optional'),
//                 ),
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Location'),
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: location,
//                   textInputAction: TextInputAction.next,
//                   decoration: kTextFieldDecoration.copyWith(
//                     suffixIcon: GestureDetector(
//                       // onTap: _selectOnMap,
//                       onTap: _getCurrentUserLocation,
//                       child: const Icon(Icons.my_location),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 buildFeildHeader('Attach image'),
//                 TextFormField(
//                   decoration: kTextFieldDecoration.copyWith(
//                     hintText: 'Optional',
//                     prefixIcon: photo != null
//                         ? Padding(
//                             padding: const EdgeInsets.only(right: 6),
//                             child: CircleAvatar(
//                               foregroundImage: FileImage(File(photo!.path)),
//                             ),
//                           )
//                         : const Icon(Icons.insert_drive_file),
//                     suffixIcon: SizedBox(
//                       width: 100,
//                       child: DropdownButtonFormField(
//                         icon: const Padding(
//                           padding: EdgeInsets.only(right: 10),
//                           child: Icon(Icons.camera_alt),
//                         ),
//                         decoration: kTextFieldDecoration.copyWith(hintText: ''),
//                         // value: photo?.name,
//                         items: <String>['Camera', 'Gallery']
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         onChanged: (newValue) async {
//                           imageGropdownValue = newValue;
//                           if (newValue != null) {
//                             if (newValue == 'Camera') {
//                               photo = await picker.pickImage(
//                                 source: ImageSource.camera,
//                                 imageQuality: 60,
//                               );
//                             }
//                             if (newValue == 'Gallery') {
//                               photo = await picker.pickImage(
//                                 source: ImageSource.gallery,
//                                 imageQuality: 60,
//                               );
//                             }
//                           }
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//                   controller: TextEditingController(text: photo?.name),
//                   textInputAction: TextInputAction.next,
//                   readOnly: true,
//                   onTap: () async {
//                     DropdownButton<String>(
//                       value: imageGropdownValue,
//                       elevation: 16,
//                       onChanged: (newValue) async {
//                         imageGropdownValue = newValue;
//                         if (newValue != null) {
//                           if (newValue == 'Camera') {
//                             photo = await picker.pickImage(
//                               source: ImageSource.camera,
//                               imageQuality: 60,
//                             );
//                           }
//                           if (newValue == 'Gallery') {
//                             photo = await picker.pickImage(
//                               source: ImageSource.gallery,
//                               imageQuality: 60,
//                             );
//                           }
//                         }
//                         setState(() {});
//                       },
//                       items: <String>['Camera', 'Gallery']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 32),
//                 if (state.status == CurrentStatus.loading)
//                   const LoadingButton()
//                 else
//                   PrimaryButton(
//                     title: 'Save',
//                     onPressed: () async {
//                       if (formkey.currentState!.validate()) {
//                         final cubit = context.read<HomeCubit>();
//                         FocusManager.instance.primaryFocus!.unfocus();
//                         final user = context.read<AuthBloc>().state.user;
//                         var base64string = '';
//                         if (photo != null) {
//                           final imagefile = File(photo!.path);
//                           final imagebytes = await imagefile.readAsBytes();
//                           base64string = base64.encode(imagebytes);
//                         }

//                         await cubit.insertExpenses(
//                           {
//                             'date': dateCtlr.text,
//                             'amount': amount.text,
//                             'category': category,
//                             'image': base64string,
//                             'id': DateTime.now().microsecondsSinceEpoch.abs(),
//                             'description': description.text,
//                             'location': location.text,
//                             'user_uid': user.uid,
//                           },
//                         );
//                       }
//                     },
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
