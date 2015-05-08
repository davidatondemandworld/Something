//
//  TIBLECBKeyfobDefines.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#ifndef BLEDefines_h
#define BLEDefines_h

//================================================================
//==============  Transparent transmission module   ==============
//================================================================

// Transparent services UUID and characteristics UUID
//**********************************************************
// Transparent receive Service UUIDs
#define BLE_RECEIVE_DATA_SERVICE_UUID                      @"FFE0"
// Transparent receive characteristics UUIDs
#define BLE_RECEIVE_DATA_5BYTES_UUID                       @"FFE1"
#define BLE_RECEIVE_DATA_10BYTES_UUID                      @"FFE2"
#define BLE_RECEIVE_DATA_15BYTES_UUID                      @"FFE3"
#define BLE_RECEIVE_DATA_20BYTES_UUID                      @"FFE4"

// Transparent transmit Service UUIDs
#define BLE_TRANSMIT_DATA_SERVICE_UUID                     @"FFE5"
// Transparent transmit characteristics UUIDs
#define BLE_TRANSMIT_DATA_5BYTES_UUID                      @"FFE6"
#define BLE_TRANSMIT_DATA_10BYTES_UUID                     @"FFE7"
#define BLE_TRANSMIT_DATA_15BYTES_UUID                     @"FFE8"
#define BLE_TRANSMIT_DATA_20BYTES_UUID                     @"FFE9"
// Read Transparent characteristics UUID length
#define BLE_TRANSMIT_DATA_5BYTES_WR_LEN                    5
#define BLE_TRANSMIT_DATA_10BYTES_WR_LEN                   10
#define BLE_TRANSMIT_DATA_15BYTES_WR_LEN                   15
#define BLE_TRANSMIT_DATA_20BYTES_WR_LEN                   20
//================================================================
//==========================   end   =============================
//================================================================
#endif
