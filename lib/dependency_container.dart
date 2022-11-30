import 'package:dio/dio.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/change_number_availble_check_usecase.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/get_sim_provider_usecase.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/history/domain/usecases/get_driver_history_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/data_sources/wallet_remote_data_source.dart';
import 'package:flutter_rideshare/features/wallet/data/repositories/wallet_repo_imp.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/get_wallet_info_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/link_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/unlink_zindigi_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/validate_zindigi_accont_usecase.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'core/router/places_provider.dart';
import 'core/utils/location/dashboard_helper.dart';
import 'core/utils/services/device_info_service.dart';
import 'features/authentication/auth_wrapper/data/data_sources/auth_data_source.dart';
import 'features/authentication/auth_wrapper/data/repository/auth_repo_imp.dart';
import 'features/authentication/auth_wrapper/domain/repository/auth_repo.dart';
import 'features/authentication/auth_wrapper/domain/usecases/driver_document_upload_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/find_account_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/logout_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/register_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/reset_password_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/update_mobile_number_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/verify_email_otp_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/verify_phone_otp_usecase.dart';
import 'features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'features/dashboard/data/datasouces/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repository/dashboard_repository_imp.dart';
import 'features/dashboard/domain/repository/dashboard_repository.dart';
import 'features/dashboard/domain/usecase/add_driver_ride_usecase.dart';
import 'features/dashboard/domain/usecase/add_passenger_ride_usecase.dart';
import 'features/dashboard/domain/usecase/add_rating_usecase.dart';
import 'features/dashboard/domain/usecase/get_dashboard_history_rides_usecase.dart';
import 'features/dashboard/domain/usecase/get_vehicle_capacity_usecase.dart';
import 'features/dashboard/domain/usecase/switch_role_usecase.dart';
import 'features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import 'features/dashboard/presentation/providers/rating_provider.dart';
import 'features/drawer_wrapper/history/domain/usecases/get_history_usecase.dart';
import 'features/drawer_wrapper/history/presentation/providers/history_provider.dart';
import 'features/drawer_wrapper/notification/domain/usecases/getNotificationsUsecase.dart';
import 'features/drawer_wrapper/notification/presentation/providres/notification_provider.dart';
import 'features/drawer_wrapper/profile/domain/usecases/update_profile_image_usecase.dart';
import 'features/drawer_wrapper/profile/domain/usecases/update_profile_usecase.dart';
import 'features/drawer_wrapper/profile/domain/usecases/update_selected_vehicle_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/data/data_souce/drawer_wrapper_remote_datasouce.dart';
import 'features/drawer_wrapper/schedules_driver/data/repository/drawer_wrapper_repository_imp.dart';
import 'features/drawer_wrapper/schedules_driver/domain/repository/drawer_wrapper_repository.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/get_driver_schedules_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/get_requested_passenger_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/reshedule_driver_route_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/reshedule_passenger_schedule_usecase.dart';
import 'features/ride/presentation/providers/chat_provider.dart';
import 'features/ride/presentation/providers/driver_ride_provider.dart';
import 'features/splash_screen/data/data_sources/local_data_source.dart';
import 'features/splash_screen/data/repository/splash_repo_imp.dart';
import 'features/splash_screen/domain/repository/splash_repository.dart';
import 'features/splash_screen/domain/use_cases/get_user_usecase.dart';
import 'features/splash_screen/presentation/providers/splash_provider.dart';
import 'features/vehicles/data/data_sources/vehicle_data_source.dart';
import 'features/vehicles/data/repository/vehicle_repo_imp.dart';
import 'features/vehicles/domain/repository/vechile_repository.dart';
import 'features/vehicles/domain/usecases/add_vehicle_usecase.dart';
import 'features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'features/vehicles/domain/usecases/get_city_usecase.dart';
import 'features/vehicles/domain/usecases/get_model_usecase.dart';
import 'features/vehicles/domain/usecases/get_vehicle_initial_usecase.dart';
import 'features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'features/vehicles/presentation/providers/vechicle_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/router/app_state.dart';
import 'core/utils/globals/globals.dart';
import 'core/utils/network/network_info.dart';
import 'features/authentication/auth_wrapper/domain/usecases/delete_account_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/login_usecase.dart';
import 'features/authentication/auth_wrapper/domain/usecases/resend_otp_usecase.dart';
import 'features/dashboard/domain/usecase/get_dashboard_data_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/get_driver_list_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/domain/usecases/get_passenger_schdules_usecase.dart';
import 'features/drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import 'features/ride/presentation/providers/passenger_ride_provider.dart';
import 'features/wallet/domain/use_cases/create_zindigi_account_usecase.dart';
import 'features/wallet/domain/use_cases/zindigi_wallet_otp.dart';

Future<void> init() async {
  /// UseCases , Repo with Datasource
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => VerifyPhoneUsecase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUsecase(sl()));
  sl.registerLazySingleton(() => GetUserUsecase(sl()));
  sl.registerLazySingleton(() => GetVehicleInitialsUsecase(sl()));
  sl.registerLazySingleton(() => GetCityUsecase(sl()));
  sl.registerLazySingleton(() => GetModelsUsecase(sl()));
  sl.registerLazySingleton(() => ValidateZindigiAccountUsecase(sl()));
  sl.registerLazySingleton(() => AddVehicleUsecase(sl()));
  sl.registerLazySingleton(() => GetVehiclesUsecase(sl()));
  sl.registerLazySingleton(() => AddDriverRideUsecase(sl()));
  sl.registerLazySingleton(() => AddPassengerRideUsecase(sl()));
  sl.registerLazySingleton(() => GetDriverSchedulesUsecase(sl()));
  sl.registerLazySingleton(() => GetPassengerSchedulesUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileImageUsecase(sl()));
  sl.registerLazySingleton(() => GetDriversListUsecase(sl()));
  sl.registerLazySingleton(() => GetRequestedPassengersUsecase(sl()));
  sl.registerLazySingleton(() => UpdateSelectedVehicleUsecase(sl()));
  sl.registerLazySingleton(() => ResendOtpUsecase(sl()));
  sl.registerLazySingleton(() => GetHistoryUsecase(sl()));
  sl.registerLazySingleton(() => AddRatingUsecase(sl()));
  sl.registerLazySingleton(() => FindAccountUsecase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl()));
  sl.registerLazySingleton(() => SwitchRoleUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetDashboardDataUsecase(sl()));
  sl.registerLazySingleton(() => DeleteVehicleUsecase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUsecase(sl()));
  sl.registerLazySingleton(() => GetVehicleCapacityUsecase(sl()));
  sl.registerLazySingleton(() => RescheduleDriverRouteUsecase(sl()));
  sl.registerLazySingleton(() => ReschedulePassengerScheduleUsecase(sl()));
  sl.registerLazySingleton(() => GetDashboardHistoryRidesUsecase(sl()));
  sl.registerLazySingleton(() => DriverDocumentUploadUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));
  sl.registerLazySingleton(() => NewNumberAvailbleCheckUsecase(sl()));
  sl.registerLazySingleton(() => UpdateMobileNumberUsecase(sl()));
  sl.registerLazySingleton(() => LinkZindigiAccountUsecase(sl()));
  sl.registerLazySingleton(() => GetWalletInfoUsecase(sl()));
  sl.registerLazySingleton(() => GetSimProviderUsecase(sl()));
  sl.registerLazySingleton(() => CreateZindigiAccountUsecase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUsecase(sl()));
  sl.registerLazySingleton(() => GetDriverHistoryUsecase(sl()));
  sl.registerLazySingleton(() => UnlinkZindigiAccountUsecase(sl()));

  sl.registerLazySingleton(() => ZindgiWalletOtpUsecase(sl()));
  // sl.registerLazySingleton(() => ScheduleDrierSocketService());

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImp(dio: sl()));

  sl.registerLazySingleton<SplashLocalDatasource>(
      () => SplashLocalDataSourceImp(sl()));
  sl.registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImp(dio: sl()));
  sl.registerLazySingleton<DrawerWrapperRemoteDatasource>(
      () => DrawerWrapperRemoteDatasourceImp(dio: sl()));

  sl.registerLazySingleton<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImp(dio: sl()));

  sl.registerLazySingleton<DrawerWrapperRepository>(
      () => DrawerWrapperRepoImp(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImp(dio: sl()));

  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepoImp(remoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepoImp(networkInfo: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton<VehicleRepository>(
      () => VehicleRepoImp(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<WalletRepository>(
      () => WalletRepoImp(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<SplashRepository>(() => SplashRepoImp(sl(), sl()));

  /// Configs

  /// Providers
  sl.registerLazySingleton(() => AuthProvider(
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
      () => OtpProvider(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => SplashProvider(sl()));
  sl.registerLazySingleton(() => DriverRideProvider(sl()));
  sl.registerLazySingleton(() => HistoryProvider(sl(), sl(),sl()));
  sl.registerLazySingleton(() => PassengerRideProvider());
  sl.registerLazySingleton(() => RatingProvider(sl()));
  sl.registerLazySingleton(() => ChatProvider());
  sl.registerLazySingleton(
      () => WalletProvider(sl(), sl(), sl(), sl(), sl(), sl(),sl()));
  sl.registerLazySingleton(
      () => ScheduleProvider(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => PlacesProvider(sl()));
  sl.registerLazySingleton(() => SystemNotificationsProvider(sl()));
  sl.registerLazySingleton(
      () => DashboardProvider(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
      () => VehicleProvider(sl(), sl(), sl(), sl(), sl(), sl()));

  /// Repository

  /// External
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => DeviceInfoService());

  /// Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DashBoardHelper>(() => DashBoardHelper(sl()));

  /// View Models

  /// Navigator
  sl.registerLazySingleton(() => AppState());
}
