//
//  bleTransmitMoudelSecondViewController.m
//  bleTransmitMoudel
//
//  Created by David on 12-8-6.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import "bleTransmitMoudelSecondViewController.h"
#import "bleTransmitMoudelFirstViewController.h"

// 当前连接设备指定UUID
NSString *kLinkServicesUUID                 = @"1803";//@"FFE0";

@interface bleTransmitMoudelSecondViewController ()

@end

@implementation bleTransmitMoudelSecondViewController

@synthesize sensorsTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    shared = [[bleShared alloc]init];
    shared.delegate = self;
    [shared startScanningForUUIDString:kLinkServicesUUID];
    // 设置背景色
    //[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    [self setSensorsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        //case UIInterfaceOrientationPortraitUpsideDown:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (void) bleReady{}
- (void) transmitUpdated:(NSString *)string{}
// 刷新表格
- (void) discoveryDidRefresh{
    [sensorsTable reloadData];
}

- (IBAction)linkWebButton:(id)sender {
    // 按键打开网站
    NSString* urlText = [NSString stringWithFormat:@"http://www.szrfstar.com/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

#pragma mark -
#pragma mark TableView Delegates
/****************************************************************************/
/*							TableView Delegates								*/
/****************************************************************************/
// 表格处理
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell	*cell;
	CBPeripheral	*aPeripheral;
	NSInteger		row	= [indexPath row];
    static NSString *cellID = @"设备列表";
    
	cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    
    // 添加一行
    aPeripheral = (CBPeripheral*)[shared.foundPeripherals objectAtIndex:row];
    
    // 显示信息
    if ([[aPeripheral name] length] !=0) {
        [[cell textLabel] setText:[aPeripheral name]];
    }
    else{
        [[cell textLabel] setText:@"BLE设备"];
    }
    
    [[cell detailTextLabel] setText: [aPeripheral isConnected] ? @"已连接" : @"未连接"];
	return cell;
}

// 最示行数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

// 显示格式
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return (NSInteger)[shared.foundPeripherals count];
}

// 点击连接操作
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	CBPeripheral	*aPeripheral;
	NSInteger		row	= [indexPath row];
	
    aPeripheral = (CBPeripheral *)[shared.foundPeripherals objectAtIndex:row];

	if (![aPeripheral isConnected]) {
        [shared connectPeripheral:aPeripheral];
        NSLog(@"连接到外围设备: %@\n",[aPeripheral name]);
    }
}

@end
