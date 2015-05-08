//
//  bleShared.h
//  heartrate
//
//  Created by David on 12-7-30.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/

/****************************************************************************/
/*                       bleShared Interactions                             */
/****************************************************************************/
// bleShared发送数据到 显示层
@protocol bleTransmitMoudelAppDelegate
//@optional
@required
- (void) bleReady;
- (void) transmitUpdated:(NSString *)string;
- (void) discoveryDidRefresh;


@end

@interface bleShared : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>{
    CBCentralManager    *cebtralManager;
    BOOL                pendingInit;
}

@property (weak, nonatomic)   NSString *ReceiveData5Bytes;
/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (nonatomic, assign) id<bleTransmitMoudelAppDelegate> delegate;
@property (retain, nonatomic) CBCentralManager  *centralManager;
@property (retain, nonatomic) CBPeripheral      *foundaPeripheral;
@property (retain, nonatomic) CBPeripheral      *connectedPeripheral;
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
/****************************************************************************/
/*                           UI Interactions                                */
/****************************************************************************/
// 显示层 对bleShared层操作
- (void) startScanningForUUIDString:(NSString *)uuidString;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
//======= Transparent transmission module ==============FFE0
-(void) write5BytesTransmitDatas:(NSData *)data p:(CBPeripheral *)peripheral;
//-(void) write10BytesTransmitDatas:(NSData *)data p:(CBPeripheral *)peripheral;
//-(void) write15BytesTransmitDatas:(NSData *)data p:(CBPeripheral *)peripheral;
//-(void) write20BytesTransmitDatas:(NSData *)data p:(CBPeripheral *)peripheral;

//===================== END ============================
@end
