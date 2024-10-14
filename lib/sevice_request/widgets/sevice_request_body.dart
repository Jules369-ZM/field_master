import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_repo/auth_repo.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/main/cubit/main_cubit.dart';
import 'package:field_master/main/view/main_page.dart';
import 'package:field_master/sevice_request/cubit/cubit.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/size_config.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/app_container.dart';
import 'package:field_master/widgets/app_snack_bar.dart';
import 'package:field_master/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:net_source/net_source.dart';
import 'package:uuid/uuid.dart';

/// {@template sevice_request_body}
/// Body of the SeviceRequestPage.
///
/// Add what it does
/// {@endtemplate}
class SeviceRequestBody extends StatefulWidget {
  /// {@macro sevice_request_body}
  const SeviceRequestBody({super.key});

  @override
  State<SeviceRequestBody> createState() => _SeviceRequestBodyState();
}

class _SeviceRequestBodyState extends State<SeviceRequestBody> {
  final _formKey = GlobalKey<FormState>();
  String clientName = '';
  String clientPhone = '';
  String serviceDescription = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String location = 'Fetching location...';
  String? downloadUrl = '';
  XFile? serviceImage;
  Position? locData;
  LatLng? pickedlocation;

  List<String> statuses = ['Pending', 'In Progress', 'Complete'];
  String status = '';
  List<String> categories = ['Electrical', 'Plumbing', 'IT Support'];
  String selectedCat = '';
  bool firstRun = true;
  bool showPickedImage = true;
  @override
  void initState() {
    super.initState();
    selectedCat = categories.first;
    status = statuses.first;
    firstRun = true;
    showPickedImage = true;
    _getCurrentUserLocation();
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      await context.read<MainCubit>().setupLocation();
      locData = await Geolocator.getCurrentPosition();
      await _selectLocation(LatLng(locData!.latitude, locData!.longitude));
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      log(error.toString());
      return;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      if (mounted) {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    showPickedImage = true;
    setState(() {
      serviceImage = image;
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('MMM d, yyyy').format(date);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  Future<void> _selectLocation(LatLng selectedLocation) async {
    log('lat ${selectedLocation.latitude}');
    log('lng ${selectedLocation.longitude}');
    location = await getAddressFromLatLng(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    // _addressController.text = address;
    if (mounted) {
      setState(() {
        pickedlocation = selectedLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MainCubit>();
    final user = context.watch<AuthBloc>().state.user;
    final seviceRequest =
        ModalRoute.of(context)?.settings.arguments as JsonMap?;
    final isEdit = seviceRequest != null && seviceRequest.isNotEmpty;
    if (isEdit && firstRun) {
      status = seviceRequest['status'] as String;
      clientName = seviceRequest['clientName'] as String;
      clientPhone = seviceRequest['phone'] as String? ?? '';
      serviceDescription = seviceRequest['description'] as String;
      downloadUrl = seviceRequest['image'] as String?;
      selectedDate = DateTime.tryParse(seviceRequest['date'] as String);
      if (downloadUrl == null || downloadUrl!.isEmpty) {
        showPickedImage = true;
      } else {
        showPickedImage = false;
      }
      firstRun = false;

      //
    }
    return BlocConsumer<FirebaseCubit, FirebaseState>(
      listener: (context, state) {
        if (state.status == CurrentStatus.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showSuccessSnackBar(context, message: 'Submitted  Successfully');
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MainPage.route(),
                (Route<dynamic> route) => false,
              );
            }
          });
        }
        if (state.status == CurrentStatus.error) {
          EasyLoadingService.error(text: state.message);
        }
      },
      builder: (context, state) {
        return BlocBuilder<SeviceRequestCubit, SeviceRequestState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: clientName,
                      decoration: const InputDecoration(
                        labelText: 'Client Name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        clientName = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the client name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: clientPhone,
                      decoration: const InputDecoration(
                        labelText: 'Client Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        clientPhone = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the client name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCat,
                      items: categories.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCat = newValue!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select category' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: serviceDescription,
                      decoration: const InputDecoration(
                        labelText: 'Service Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onSaved: (value) {
                        serviceDescription = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a service description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: TextEditingController(
                        text: formatDate(
                          selectedDate,
                        ),
                      ), // Display formatted date
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: 'Pick Date',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => _selectDate(
                            context,
                          ), // Trigger the date picker
                          icon: const Icon(
                            Icons.calendar_today,
                          ), // Icon for date selection
                        ),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date'; // Validate that a
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) =>
                          value == null ? 'Please select time' : null,
                      controller: TextEditingController(
                        text: formatTime(
                          selectedTime,
                        ),
                      ), // Display formatted time
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: 'Pick Time',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => _selectTime(
                            context,
                          ), // Trigger the time picker
                          icon: const Icon(
                            Icons.access_time,
                          ), // Icon for time selection
                        ),
                      ),
                      onTap: () => _selectTime(
                        context,
                      ), // Allow tapping on the text field to select time
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) =>
                          value == null ? 'Please select location' : null,
                      controller: TextEditingController(
                        text: location,
                      ), // Initial location
                      readOnly: true, // Prevent user input
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // Close keyboard if open
                            await _getCurrentUserLocation();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        labelText: 'Location',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    AppContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (downloadUrl != null &&
                              downloadUrl!.isNotEmpty &&
                              !showPickedImage)
                            Image.network(
                              downloadUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          else if (serviceImage != null)
                            Image.file(
                              File(serviceImage!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          else
                            const SizedBox.shrink(),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: getProportionateScreenHeight(180),
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Capture Image'),
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Status',
                        border: OutlineInputBorder(),
                      ),
                      value: status,
                      items: statuses.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          status = newValue!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select status' : null,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<FirebaseCubit, FirebaseState>(
                      builder: (context, state) {
                        if (state.status == CurrentStatus.loading) {
                          return const LoadingButton();
                        } else {
                          return PrimaryButton(
                            title: 'Submit',
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (selectedDate == null) {
                                showInfoSnackBar(
                                  context,
                                  message: 'Select Date',
                                );
                                return;
                              }
                              if (selectedTime == null) {
                                showInfoSnackBar(
                                  context,
                                  message: 'Select Time',
                                );
                                return;
                              }
                              if (location
                                  .toLowerCase()
                                  .contains('not found')) {
                                showInfoSnackBar(
                                  context,
                                  message: 'refresh location',
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final image = serviceImage;

                                final uuid = const Uuid().v4();
                                final date = DateTime.now().toIso8601String();

                                if (isEdit == false) {
                                  await addImage(image, context, uuid, user);
                                  if (!context.mounted) return;
                                  final data = {
                                    'uuid': uuid,
                                    'id': uuid.hashCode,
                                    'clientName': clientName,
                                    'phone': clientPhone,
                                    'category': selectedCat,
                                    'categoryId': selectedCat.hashCode,
                                    'image': downloadUrl,
                                    'description': serviceDescription,
                                    'createdBy': user.email,
                                    'updatedBy': '',
                                    'updatedAt': '',
                                    'createdAt': date,
                                    'status': 'Pending',
                                    'address': location,
                                    'latitude': pickedlocation?.latitude,
                                    'longitude': pickedlocation?.longitude,
                                    'date': DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!),
                                    'time': selectedTime!.format(context),
                                    'location': jsonEncode({
                                      'latitude': pickedlocation?.latitude,
                                      'longitude': pickedlocation?.longitude,
                                      'address': location,
                                    }),
                                    'metadata': jsonEncode({
                                      'clientName': clientName,
                                      'description': serviceDescription,
                                      'date': DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!),
                                      'time': selectedTime!.format(context),
                                      'location': {
                                        'latitude': pickedlocation?.latitude,
                                        'longitude': pickedlocation?.longitude,
                                        'address': location,
                                      },
                                      'address': location,
                                      'locData': locData,
                                      'pickedlocation': pickedlocation,
                                    }),
                                  };
                                  context.read<FirebaseCubit>().addDocument(
                                        data,
                                        serviceRequestDoc,
                                        uuid,
                                      );
                                } else {
                                  await addImage(
                                    image,
                                    context,
                                    seviceRequest?['uuid'] as String,
                                    user,
                                  );
                                  if (!context.mounted) return;
                                  final data = {
                                    'uuid': seviceRequest?['uuid'],
                                    'id': seviceRequest?['id'],
                                    'phone': clientPhone,
                                    'clientName': clientName,
                                    'image': downloadUrl,
                                    'description': serviceDescription,
                                    'category': selectedCat,
                                    'categoryId': selectedCat.hashCode,
                                    'createdBy': seviceRequest?['createdBy'],
                                    'updatedBy': seviceRequest?['updatedBy'],
                                    'updatedAt': date,
                                    'createdAt': seviceRequest?['createdAt'],
                                    'status': status,
                                    'address': location,
                                    'latitude': pickedlocation?.latitude,
                                    'longitude': pickedlocation?.longitude,
                                    'date': DateFormat('yyyy-MM-dd')
                                        .format(selectedDate!),
                                    'time': selectedTime?.format(context) ??
                                        seviceRequest?['time'],
                                    'location': jsonEncode({
                                      'latitude': pickedlocation?.latitude,
                                      'longitude': pickedlocation?.longitude,
                                      'address': location,
                                    }),
                                    'metadata': jsonEncode({
                                      'clientName': clientName,
                                      'description': serviceDescription,
                                      'date': DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!),
                                      'time': selectedTime?.format(context) ??
                                          seviceRequest?['time'],
                                      'location': {
                                        'latitude': pickedlocation?.latitude,
                                        'longitude': pickedlocation?.longitude,
                                        'address': location,
                                      },
                                      'address': location,
                                      'locData': locData,
                                      'pickedlocation': pickedlocation,
                                    }),
                                  };
                                  await context
                                      .read<FirebaseCubit>()
                                      .updateDocument(
                                        collectionPath: serviceRequestDoc,
                                        id: seviceRequest?['uuid'] as String,
                                        data: data,
                                      );
                                }
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addImage(
    XFile? image,
    BuildContext context,
    String uuid,
    User user,
  ) async {
    if (image != null) {
      final imageFile = File(image.path);
      downloadUrl = await context.read<FirebaseCubit>().uploadImage(imageFile, {
        'uuid': uuid,
        'id': uuid.hashCode,
        'email': user.email,
      });
    }
    if (downloadUrl == null || downloadUrl!.isEmpty) {
      showPickedImage = true;
    } else {
      showPickedImage = false;
    }
    if (mounted) setState(() {});
  }
}
