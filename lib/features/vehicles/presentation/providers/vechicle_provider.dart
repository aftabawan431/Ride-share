import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/modals/no_params.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/models/add_vehicle_request_model.dart';
import '../../data/models/add_vehicle_response_model.dart';
import '../../data/models/delete_vehicle_request_model.dart';
import '../../data/models/get_city_request_model.dart';
import '../../data/models/get_city_response_model.dart';
import '../../data/models/get_models_request_model.dart';
import '../../data/models/get_models_response_model.dart';
import '../../data/models/get_user_vehicles_request_model.dart';
import '../../data/models/get_user_vehicles_response_model.dart';
import '../../data/models/get_vehicle_initials_response.dart';
import '../../domain/usecases/add_vehicle_usecase.dart';
import '../../domain/usecases/get_city_usecase.dart';
import '../../domain/usecases/get_model_usecase.dart';
import '../../domain/usecases/get_vehicle_initial_usecase.dart';
import '../../domain/usecases/get_vehicles_usecase.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../domain/usecases/delete_vehicle_usecase.dart';

class VehicleProvider extends ChangeNotifier {
  //use cases
  GetVehicleInitialsUsecase getVehicleInitialsUsecase;
  GetModelsUsecase getModelsUsecase;
  GetCityUsecase getCityUsecase;
  GetVehiclesUsecase getVehiclesUsecase;
  DeleteVehicleUsecase deleteVehicleUsecase;
  AddVehicleUsecase addVehicleUsecase;
  VehicleProvider(
      this.getCityUsecase,
      this.getModelsUsecase,
      this.getVehicleInitialsUsecase,
      this.addVehicleUsecase,
      this.getVehiclesUsecase,
      this.deleteVehicleUsecase);

  //properties
  String? selectedType;
  String? selectedMaker;
  String? selectedModel;
  String? selectedColor;
  String? selectedProvice;
  String? selectedCity;
  String? selectedCapacity;
  String otherPreferece = 'ac';
  String? selectedColorId;
  String? selectedYear;
  String? selectedGender;
  bool heaterAc = true;

  bool directToNewRideScreen = false;

  List<String> capacity = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  //value notifiers

  ValueNotifier<bool> getInitialLoading = ValueNotifier(false);
  ValueNotifier<bool> getModelsLoading = ValueNotifier(false);
  ValueNotifier<bool> getCitiesLoading = ValueNotifier(false);
  ValueNotifier<bool> addVehicleLoading = ValueNotifier(false);
  ValueNotifier<bool> getVehicleLoading = ValueNotifier(false);

  //properties
  GetVehicleInitialsResponseModel? getVehicleInitialsResponse;
  GetModelsResponseModel? getModelsResponseModel;
  GetCityResponseModel? getCityResponseModel;
  AddVehicleResponseModel? addVehicleResponseModel;
  GetUserVehiclesResponseModel? getUserVehiclesResponseModel;

  // text editing controllers
  TextEditingController registerNo = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController vehicleMakerController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleCityController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController minMilageController = TextEditingController();
  TextEditingController maxMilageController = TextEditingController();

  // focus nodes
  final FocusNode registerNoFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();
  final FocusNode minMilageFocusNode = FocusNode();
  final FocusNode maxMilageFocusNode = FocusNode();
  final FocusNode colorFocusNode = FocusNode();

  //usecases calls
  //use cases calls
  Future<void> getInitials() async {
    if (getVehicleInitialsResponse != null) {
      return;
    }
    getInitialLoading.value = true;

    var loginEither = await getVehicleInitialsUsecase(NoParams());

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getInitialLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getInitialLoading.value = false;
        getVehicleInitialsResponse = response;
        notifyListeners();
      });
    }
  }

  Future<void> getModels() async {
    if (selectedType == null || selectedMaker == null) {
      return;
    }
    getModelsLoading.value = true;
    String typeId = getVehicleInitialsResponse!.vehicleTypes
        .firstWhere((element) => element.type == selectedType!)
        .id;
    String makerId = getVehicleInitialsResponse!.vehicleMakes
        .firstWhere((element) => element.make == selectedMaker!)
        .id;
    var params =
        GetModelsRequestModel(vehicleType: typeId, vehicleMake: makerId);
    Logger().i(params.toJson());

    var loginEither = await getModelsUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getModelsLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getModelsLoading.value = false;
        selectedModel = null;

        getModelsResponseModel = response;
        notifyListeners();
      });
    }
  }

  Future<void> addVehicle() async {
    // String typeId = getVehicleInitialsResponse!.vehicleTypes
    //     .firstWhere((element) => element.type == selectedType!)
    //     .id;
    // String makerId = getVehicleInitialsResponse!.vehicleMakes
    //     .firstWhere((element) => element.make == selectedMaker!)
    //     .id;
    final proviceId = getVehicleInitialsResponse!.provinces
        .firstWhere((element) => element.name == selectedProvice)
        .id;
    final modelId = getModelsResponseModel!.data
        .firstWhere((element) => element.model == selectedModel)
        .id;
    final cityId = getCityResponseModel!.data
        .firstWhere((element) => element.city == selectedCity)
        .id;
    addVehicleLoading.value = true;
    AuthProvider authProvider = sl();

    var params = AddVehicleRequestModel(
        userId: authProvider.currentUser!.id,
        model: modelId,
        year: yearController.text,
        registrationNumber: registerNo.text,
        registrationCity: cityId,
        registrationProvince: proviceId,
        minMileage: minMilageController.text,
        maxMileage: '0',
        AC: heaterAc,
        heater: heaterAc,
        color: selectedColorId!,
        seatingCapacity: selectedCapacity!,
        token: authProvider.currentUser!.token);
    Logger().v(params.toJson());

    var loginEither = await addVehicleUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      addVehicleLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        addVehicleLoading.value = false;
        ShowSnackBar.show('Vehicle added successfully');

        addVehicleResponseModel = response;
        AppState appState = sl();

        await getVehicles(recall: true, setSelected: true);

        clearFields();
        VehicleProvider vehicleProvider = sl();
        DashboardProvider provider = sl();

        if (vehicleProvider.directToNewRideScreen) {
          if (provider.dashboardDropofLocation != null) {
            provider
                .setDropOfLocation(provider.dashboardDropofLocation!.placeId);
          } else {
            provider.setDropOfLocation(null);
          }
          AppState appState = sl();

          appState.goToNext(PageConfigs.newRidePageConfig,
              pageState: PageState.replace);
        } else {
          appState.moveToBackScreen();
        }
        notifyListeners();
      });
    }
  }

  Future<void> getCities() async {
    getCitiesLoading.value = true;
    final proviceId = getVehicleInitialsResponse!.provinces
        .firstWhere((element) => element.name == selectedProvice)
        .id;

    var params = GetCityRequestModel(province: proviceId);

    var loginEither = await getCityUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getCitiesLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getCitiesLoading.value = false;
        getCityResponseModel = response;
        notifyListeners();
      });
    }
  }

  Future<void> getVehicles(
      {bool recall = false, bool setSelected = false}) async {
    if (getUserVehiclesResponseModel != null) {
      if (recall == false) {
        return;
      }
    }
    getVehicleLoading.value = true;

    AuthProvider authProvider = sl();
    var params = GetUserVehicleRequestModel(
        userId: authProvider.currentUser!.id,
        token: authProvider.currentUser!.token);

    var loginEither = await getVehiclesUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getVehicleLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        if (response.data.userVehicle.isNotEmpty) {
          authProvider.currentUser!.selectedVehicle =
              response.data.userVehicle.first.id;
          authProvider.updateUserOnDisk();
          DashboardProvider dashboardProvider = sl();
          dashboardProvider.setDriverVehicleCapacity();
        }
        getVehicleLoading.value = false;
        getUserVehiclesResponseModel = response;
        notifyListeners();
      });
    }
  }

  Future<void> deleteVehicle({bool recall = false, required String id}) async {
    Loading.show(message: 'Deleting');

    AuthProvider authProvider = sl();
    var params = DeleteVehicleRequestModel(
        userId: authProvider.currentUser!.id, vehicleId: id);

    var loginEither = await deleteVehicleUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      Loading.dismiss();
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        /// [GetUserVehiclesResponseModel] response is returning updated vehicle, to check if
        /// user vehicle is not empty, then it will set selectedVehicleId to the first id,
        if (response.data.userVehicle.isNotEmpty) {
          authProvider.currentUser!.selectedVehicle =
              response.data.userVehicle.first.id;
          await authProvider.updateUserOnDisk();
        } else {
          /// else will set selectedVehicle to null, then if owner will try to add new ride, will prompt him to add the new vehicle first
          authProvider.currentUser!.selectedVehicle = null;
          await authProvider.updateUserOnDisk();
        }

        Loading.dismiss();

        getUserVehiclesResponseModel = response;
        notifyListeners();
      });
    }
  }

  //setters

  setSelectedCity(String? value) {
    selectedCity = value;
    notifyListeners();
  }

  void setPreference(String? value) {
    otherPreferece = value!;
    notifyListeners();
  }

  setSelectedModel(String? value) {
    selectedModel = value;
    notifyListeners();
  }

  setHeaterAcValue(bool value) {
    heaterAc = value;
    notifyListeners();
  }

  //validators
  validateDropDowns() {
    if (selectedType == null) {
      return ShowSnackBar.show('Please select vehicle type');
    } else if (selectedMaker == null) {
      return ShowSnackBar.show('Please select maker');
    }

    if (selectedModel == null) {
      return ShowSnackBar.show('Please select model');
    }
    if (selectedColorId == null) {
      return ShowSnackBar.show('Please select color');
    }
    if (selectedCapacity == null) {
      return ShowSnackBar.show('Please select capacity');
    }
    if (selectedProvice == null) {
      return ShowSnackBar.show('Please select provice');
    }
    if (selectedCity == null) {
      return ShowSnackBar.show('Please select city');
    }

    return false;
  }

  clearFields() {
    selectedColorId = null;
    selectedCapacity = null;
    selectedType = null;
    maxMilageController.clear();
    minMilageController.clear();
    registerNo.clear();
    yearController.clear();
    selectedCity = null;
    selectedProvice = null;
    selectedModel = null;

    heaterAc = true;
    vehicleTypeController.clear();
    vehicleMakerController.clear();
    vehicleModelController.clear();
    provinceController.clear();
    vehicleCityController.clear();
    getCityResponseModel = null;

    getModelsResponseModel = null;
  }

  //error handling

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }
}
