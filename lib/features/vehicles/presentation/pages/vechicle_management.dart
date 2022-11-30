import 'package:flutter/material.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/widgets/custom_column_appbar.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../providers/vechicle_provider.dart';
import '../widgets/vehicle_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/enums/page_state_enum.dart';

class VehicleManagementScreen extends StatelessWidget {
  VehicleManagementScreen({Key? key}) : super(key: key);
  final VehicleProvider vehicleProvider = sl();
  final AuthProvider authProvider = sl();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: vehicleProvider),
      ChangeNotifierProvider.value(value: authProvider),
    ], child: const VehicleManagementScreenContent());
  }
}

class VehicleManagementScreenContent extends StatefulWidget {
  const VehicleManagementScreenContent({Key? key}) : super(key: key);

  @override
  State<VehicleManagementScreenContent> createState() =>
      _VehicleManagementScreenContentState();
}

class _VehicleManagementScreenContentState
    extends State<VehicleManagementScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleProvider>().getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
            valueListenable: context.read<VehicleProvider>().getVehicleLoading,
            builder: (_, loading, __) {
              if (loading) {
                return const Center(
                      child:  CircularProgressIndicator.adaptive(),
                    );
              } else {
                return Column(
                      children: [
                        CustomColumnAppBar(
                          title: 'Vehicles',
                          actionIcon: Icons.add,
                          actionOnTap: () {
                            VehicleProvider vehicleProvider=sl();
                            vehicleProvider.directToNewRideScreen=false;
                            AppState appState =
                            GetIt.I.get<AppState>();
                            appState.currentAction = PageAction(
                                state: PageState.addPage,
                                page: PageConfigs
                                    .vehicleDetailsPageConfig);
                          },
                          showActionButton: true,
                        ),

                        Consumer<VehicleProvider>(builder: (_, provider, __) {
                          return provider.getUserVehiclesResponseModel!.data
                                  .userVehicle.isEmpty
                              ? const Expanded(
                                  child: Center(
                                  child: Text("No vehicles are added yet!"),
                                ))
                              : Expanded(
                                  child: ListView.builder(
                                  itemCount: provider
                                      .getUserVehiclesResponseModel!
                                      .data
                                      .userVehicle
                                      .length,
                                  itemBuilder: (context, index) {
                                    return VehicleWidget(
                                        userVehicle: provider
                                            .getUserVehiclesResponseModel!
                                            .data
                                            .userVehicle[index]);
                                  },
                                ));
                        })
                      ],
                    );
              }
            }),
      ),
    );
  }
}
