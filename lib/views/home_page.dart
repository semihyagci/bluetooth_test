import 'package:bt_project/controller/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height:180,
                  width: double.infinity,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                        "Bluetooth App",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
               const SizedBox(height: 20,),
                Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(350,55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        shadowColor: Colors.black,
                      ),
                        onPressed: () {
                         checkPermission(Permission.bluetoothScan, context);
                         controller.scanDevices();
                        },
                        child: Text("Scan",style: TextStyle(fontSize: 18),)
                    )
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<ScanResult>>(
                    stream: controller.scanResults,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context,index){
                              final data = snapshot.data![index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(data.device.name + "" + data.device.platformName),
                                  subtitle: Text(data.device.id.id + "" + data.device.id.str),
                                  trailing: Text(data.rssi.toString()),
                                ),
                              );
                            }
                        );
                      }else{
                        return const Center(child: Text("No devices found."),);
                      }
                    }
                )
              ],
            ),
          );
        }
      ),
    );
  }
  Future<void> checkPermission(Permission permission,BuildContext context) async {
    final status = await permission.request();
    if(status.isGranted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission is granted.")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission is denied.")));
    }

  }
}
