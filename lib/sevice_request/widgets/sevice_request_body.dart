import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/main/cubit/main_cubit.dart';
import 'package:field_master/main/view/main_page.dart';
import 'package:field_master/models/place.dart';
import 'package:field_master/sevice_request/cubit/cubit.dart';
import 'package:field_master/sevice_request/widgets/maps_screen.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/size_config.dart';
import 'package:field_master/utils/utils.dart';
import 'package:field_master/widgets/app_container.dart';
import 'package:field_master/widgets/widgets.dart';
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
    // _getCurrentLocation();
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

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapsScreen(
          initialLocation: PlaceLocation(
            latitude: locData?.latitude ?? pickedlocation!.latitude,
            longitude: locData?.longitude ?? pickedlocation!.longitude,
          ),
        ),
      ),
    );
    log(selectedLocation.toString());

    if (selectedLocation == null) {
      return;
    }
    await _selectLocation(
      LatLng(selectedLocation.latitude, selectedLocation.longitude),
    );
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
    log(seviceRequest.toString());
    return BlocConsumer<FirebaseCubit, FirebaseState>(
      listener: (context, state) {
        if (state.status == CurrentStatus.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
                    TextFormField(
                      initialValue: serviceDescription,
                      decoration: const InputDecoration(
                        labelText: 'Service Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
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
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildFeildHeader(formatDate(selectedDate)),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Pick Date'),
                          ),
                        ],
                      ),
                    ),
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildFeildHeader(formatTime(selectedTime)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context),
                            child: const Text('Pick Time'),
                          ),
                        ],
                      ),
                    ),
                    AppContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildFeildHeader('Location'),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                            ),
                            title: const Text('Location'),
                            subtitle: Text(location),
                            trailing: IconButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await _getCurrentUserLocation();
                              },
                              icon: const Icon(Icons.refresh),
                            ),
                          ),
                        ],
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
                          const SizedBox(width: 16),
                          SizedBox(
                            width: getProportionateScreenHeight(200),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Capture Image'),
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppContainer(
                      child: DropdownButtonFormField<String>(
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
                    ),
                    AppContainer(
                      child: DropdownButtonFormField<String>(
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
