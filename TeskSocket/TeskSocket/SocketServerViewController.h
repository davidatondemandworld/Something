//
//  SocketServerViewController.h
//  TeskSocket
//
//  Created by apple on 13-5-24.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerSocket.h"
#import "CorePlot-CocoaTouch.h"

@interface SocketServerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CPTPlotDataSource>
{
    ServerSocket *server;
    NSMutableArray *cellData;
    
    NSMutableArray *mArray;
    
    CPTXYGraph *graph;
    
    BOOL isSharing;
}
- (IBAction)sendMessage:(id)sender;
- (IBAction)unlock:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *shareScreenButton;
@property (retain, nonatomic) IBOutlet UILabel *portLabel;
@property (retain, nonatomic) IBOutlet UITextView *resultTextView;
@property (retain, nonatomic) IBOutlet UILabel *ipLabel;
@property (retain, nonatomic) IBOutlet UITableView *ipTableView;
- (IBAction)shareScreen:(id)sender;
- (IBAction)lock:(id)sender;
@end

