                                Gigaset elements for Inteno CG300 (POC)

How to configure Gigaset elements package on CG300?
---------------------------------------------------
1. By default _Gigaset elements_ package is connecting directly with DECT driver (via ```/dev/dect```)
   so please disable following apps:
    * dectproxy,
    * dectmngr.

2. You have to configure _DEVICE_ID_ for each basestation (each basestation should use unique _DEVICE_ID_) 
   to do it please edit ```/usr/share/gigaset-elements/scripts/env.sh``` file and uncomment one of the 
   following line:
    ```
    # export DEVICE_ID="INTENO0003INTENO0003INTENO0003IN"   # Activation Code: INTENO0003
    # export DEVICE_ID="INTENO0004INTENO0004INTENO0004IN"   # Activation Code: INTENO0004
    # export DEVICE_ID="INTENO0005INTENO0005INTENO0005IN"   # Activation Code: INTENO0005
    # export DEVICE_ID="INTENO0006INTENO0006INTENO0006IN"   # Activation Code: INTENO0006
    # export DEVICE_ID="INTENO0007INTENO0007INTENO0007IN"   # Activation Code: INTENO0007
    # export DEVICE_ID="INTENO0008INTENO0008INTENO0008IN"   # Activation Code: INTENO0008
    # export DEVICE_ID="INTENO0009INTENO0009INTENO0009IN"   # Activation Code: INTENO0009
    ```

   All mentioned above _DEVICE_ID_ are valid - it means that you can claim CG300 with _Gigaset elements cloud_
   and use it with _Gigaset elements system_ as _Gigaset elements basestation_.

   To claim CG300 with _Gigaset elements cloud_ you can use:
    * web page: https://my.gigaset-elements.com 
    * android application: https://play.google.com/store/apps/details?id=com.gigaset.elements
    * iPhone application: https://itunes.apple.com/de/app/gigaset-elements/id644160841

   _Activation code_ for each _DEVICE_ID_ is presented in comment in each 
    ```export DEVICE_ID="..."``` line.


How to start Gigaset elements applications?
-------------------------------------------
You can start all applications required by _Gigaset elements package_ by the following command
 ```
 /etc/init.d/gigaset_elements start
 ```


How to claim CG300 with Gigaset elements cloud?
-----------------------------------------------
You can trigger claiming procedure by the following command:
 ```
 jbus.ui cloud.claiming start
 ```
In response you will get:
 * ongoing - basestation is sending _sign request_ to the cloud,
 * rejected - _sign request_ can't be processed (probably basestation is already claimed).


How to check claiming procedure state?
--------------------------------------
You can check claiming state by the following command:
 ```
 jbus.ui cloud.claiming get_status
 ```
In response you will get:
 * not_claimed - basestation is not claimed with the cloud,
 * ongoing - basestation is sending _sign request_ to the cloud,
 * claimed - basesttaion is claimed with the cloud.


How to activate/deactivate DECT registartion?
---------------------------------------------
You can activate DECT registartion by the following command:
 ```
 jbus.ui dect.registration start
 ```
In response you will get:
 * ongoing - basestation is in DECT registration mode.

To deactivate DECT registration you can use following command:
 ```
 jbus.ui dect.registration stop
 ```
In response you will get:
 * stopped - DECT registration mode is off.


Known limitations and workarounds:
----------------------------------
1. _uleapp_ is supporting _dectproxy_ nevertheless because of unknown reason such configuration is not working stable,
* it is recommended to disable following applications:
 * dectproxy,
 * dectmngr,
2. Only 4 ULE sensors can be registered to the CG300 (attempt to register 5th sensor will fail with MM_REJ_UNSUFFICIENT_MEMORY reason),
3. Type of registered PP is not verified and always _legacy mode_ is activated (via API_FP_ULE_SET_PVC_LEGACY_MODE_REQ),
4. PP desubcription is possible but apart of that DECT driver is still accepting communication from deleted PP,
5. PP SUOTA is not working correctly,
6. After reload of _uleapp_ PP _Location-Registartion_ is missing and _uleapp_ is not able to determine PP _devId_ correctly ("BadId--1" is reported in this case),
7. Access Code is automatically changed by _uleapp_ to _5555_ - it's required to register any _Gigaset elements sensor_.

