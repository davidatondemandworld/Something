//
//  bleShared.m
//  heartrate
//
//  Created by David on 12-7-30.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import "bleShared.h"
#import "BLEDefines.h"
//======= Transparent transmission module ==============
///*
#define ReceiveDataInitState                1   // (setNotifyValue -> 0:OFF | 1:ON)
// Receive Service
NSString *kReceiveDataUUID                  = BLE_RECEIVE_DATA_SERVICE_UUID;
NSString *kReceiveData5BytesUUID            = BLE_RECEIVE_DATA_5BYTES_UUID;
// Transmit Service
NSString *kTransmitDataUUID                 = BLE_TRANSMIT_DATA_SERVICE_UUID;
NSString *kTransmitData5BytesUUID           = BLE_TRANSMIT_DATA_5BYTES_UUID;
//======================== END =========================

@interface bleShared() <CBPeripheralDelegate> {
@private

    //======= Transparent transmission module ==============
    ///*
    // Receive Service
    CBService           *receiveDataServices;
    CBCharacteristic    *receiveData5BytesCharacteristic;
    // Transmit Service
    CBService           *transmitDataServices;
    CBCharacteristic    *transmitData5BytesCharacteristic;
    //======================== END =========================
}
@end

@implementation bleShared

@synthesize centralManager;
@synthesize foundaPeripheral;
@synthesize connectedPeripheral;
@synthesize foundPeripherals;

@synthesize ReceiveData5Bytes;
// ===========================




#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
// 按UUID进行扫描
- (void) startScanningForUUIDString:(NSString *)uuidString
{
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

// 停止扫描
- (void) stopScanning
{
	[centralManager stopScan];
}


#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
// 连接外围设备
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    // 如果没有已连接则连接到该外围设备
	if (![peripheral isConnected]) {
        connectedPeripheral = peripheral;
        connectedPeripheral.delegate = self;
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

// 清除设备
- (void) clearDevices
{
    NSArray	*servicearray;
    // 从发现数组移除
    [self.foundPeripherals removeAllObjects];
    // 清除已连接的服务
    for (servicearray in self.foundPeripherals) {
        [self reset];
    }
    // 从连接数组移除
    [self.foundPeripherals removeAllObjects];
}

// 程序重置
- (void) reset{
	if (connectedPeripheral) {
		connectedPeripheral = nil;
	}
}

#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/
// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral service:(CBService *)service characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicPropertyWriteWithoutResponse];
}

// 写入5Bytes数据
-(void) write5BytesTransmitDatas:(NSData *)data p:(CBPeripheral *)peripheral{
    [self writeValue:peripheral service:transmitDataServices characteristic:transmitData5BytesCharacteristic data:data];
}
//======================== END =========================


#pragma mark -
#pragma mark CBCentralManager
/****************************************************************************/
/*							CBCentralManager								*/
/****************************************************************************/
// 中心设备状态更新
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
            // 掉电状态
		case CBCentralManagerStatePoweredOff:
		{
            // 清除设备信息
            [self clearDevices];
            // 刷新显示列表
            [[self delegate] discoveryDidRefresh];
			break;
		}
            
            // 未经授权的状态
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
            // 未知状态
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
            // 上电状态
		case CBCentralManagerStatePoweredOn:
		{
            // 刷新显示列表
			[[self delegate] discoveryDidRefresh];
			break;
		}
            
            // 重置状态
		case CBCentralManagerStateResetting:
		{
            // 清除设备
			[self clearDevices];
            // 刷新显示列表
            [[self delegate] discoveryDidRefresh];
            
            // 绑定初始标志有效
			pendingInit = YES;
			break;
		}
	}
    // 当前状态为中心设备状态
    previousState = [centralManager state];
}

// 中心设备扫描外围
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    // 如果不存在找到设备列表中则添加新设备
	if (![self->foundPeripherals containsObject:peripheral]) {
		[self->foundPeripherals addObject:peripheral];
        // 添加一个外围设备到外围设备列表
        foundaPeripheral =peripheral;
        foundaPeripheral.delegate = self;
        // 刷新显示列表
		[[self delegate] discoveryDidRefresh];
	}
}

// 中心设备连接外围设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    // 发现服务
    //======= Transparent transmission module ==============
    ///*
    CBUUID	*RecSerUUID     = [CBUUID UUIDWithString:kReceiveDataUUID];
    CBUUID  *TraSerUUID     = [CBUUID UUIDWithString:kTransmitDataUUID];
    NSArray	*serviceArray	= [NSArray arrayWithObjects:RecSerUUID, TraSerUUID, nil];
    //*/
    [peripheral discoverServices:serviceArray];
    //======================== END =========================
    connectedPeripheral = peripheral;
    connectedPeripheral.delegate = self;
    
    foundaPeripheral = nil;
    [foundaPeripheral setDelegate:nil];
    
	
    // 如果找到设备数组没有包含该设备则添加
	if (![self.foundPeripherals containsObject:peripheral])
		[self.foundPeripherals addObject:peripheral];

    // 刷新显示列表
	[[self delegate] discoveryDidRefresh];
}

// 中心设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSArray	*serviceArray = nil;
    // 扫描已连接的服务
	for (serviceArray in self.foundPeripherals) {
        [centralManager cancelPeripheralConnection:peripheral];
        break;
	}
    // 刷新显示列表
	[[self delegate] discoveryDidRefresh];
}

#pragma mark -
#pragma mark CBPeripheral
/****************************************************************************/
/*                              CBPeripheral								*/
/****************************************************************************/

// 扫描服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error){
        if (peripheral != connectedPeripheral){}
        else
        {
            // 新建服务数组
            NSArray *services = [peripheral services];
            if (!services || ![services count]){}
            else
            {
                for (CBService *services in peripheral.services)
                {
                    NSLog(@"发现服务UUID: %@\r\n", services.UUID);
                    //======= Transparent transmission module ==============FFE0
                    // 扫描透传模块服务特征值
                    if ([[services UUID] isEqual:[CBUUID UUIDWithString:kReceiveDataUUID]])
                    {
                        // 扫描服务特征值UUID
                        receiveDataServices = services;
                        [peripheral discoverCharacteristics:nil forService:receiveDataServices];
                    }
                    else if ([[services UUID] isEqual:[CBUUID UUIDWithString:kTransmitDataUUID]])
                    {
                        transmitDataServices = services;
                        [peripheral discoverCharacteristics:nil forService:transmitDataServices];
                    }
                    //======================== END =========================
                }
            }
        }
    }
}

// 从服务中扫描特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (!error) {
        if (peripheral != connectedPeripheral){}
        else
        {
            // 新建特征值数组
            NSArray *characteristics = [service characteristics];
            CBCharacteristic *characteristic;
            //======= Transparent transmission module ==============FFE0
            // 扫描透传模块服务特征值
            if ([[service UUID] isEqual:[CBUUID UUIDWithString:kReceiveDataUUID]])
            {
                for (characteristic in characteristics)
                {
                    // 通知接收5Bytes使能关
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceiveData5BytesUUID]])
                    {
                        receiveData5BytesCharacteristic = characteristic;
                        if (ReceiveDataInitState == 1) {
                            [peripheral setNotifyValue:YES forCharacteristic:receiveData5BytesCharacteristic];
                        }
                        else{
                            [peripheral setNotifyValue:NO forCharacteristic:receiveData5BytesCharacteristic];
                        }
                    }
                }
            }
            else if ([[service UUID] isEqual:[CBUUID UUIDWithString:kTransmitDataUUID]])
            {
                for (characteristic in characteristics)
                {
                    // 发送5Bytes服务
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kTransmitData5BytesUUID]])
                    {
                        transmitData5BytesCharacteristic = characteristic;
                    }
                    [[self delegate]bleReady];
                }
            }
            //======================== END =========================
        }
    }
}

// 更新特征值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if ([error code] == 0) {
        if (peripheral == connectedPeripheral) {
            //======= Transparent transmission module ==============FFE0
            // 接收5Bytes
            if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceiveData5BytesUUID]])
            {
                UInt8 databuffer[BLE_TRANSMIT_DATA_5BYTES_WR_LEN];
                [characteristic.value getBytes:&databuffer length:BLE_TRANSMIT_DATA_5BYTES_WR_LEN];
                NSString *rxdatatoASCII = [[NSString alloc]initWithBytes:databuffer length:BLE_TRANSMIT_DATA_5BYTES_WR_LEN encoding:NSASCIIStringEncoding];
                [[self delegate] transmitUpdated:rxdatatoASCII];
            }
            //======================== END =========================
        }
    }
}
/****************************************************************************/
/*                                  END                                     */
/****************************************************************************/
@end
