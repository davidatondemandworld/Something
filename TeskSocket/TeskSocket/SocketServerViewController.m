//
//  SocketServerViewController.m
//  TeskSocket
//
//  Created by apple on 13-5-24.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "SocketServerViewController.h"
#import "SocketAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "SocketServerChatViewController.h"

@interface SocketServerViewController ()

@end

@implementation SocketServerViewController
#pragma mark - Private Methods
- (void)addChart
{
    CGRect frame = CGRectZero;
    int yMax;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        frame = CGRectMake(20, 250, 280, 170);
        yMax = 10;
    }
    else
    {
        yMax = 32;
        frame = CGRectZero;
        frame = CGRectMake(67, 460, 636, 480);
    }
    
    // create the graph
    CPTGraphHostingView *chartLayout=[[CPTGraphHostingView alloc] initWithFrame:frame];
    chartLayout.backgroundColor=[UIColor whiteColor];
    
    graph=[[CPTXYGraph alloc] initWithFrame:chartLayout.bounds];
    graph.plotAreaFrame.masksToBorder=NO;
    chartLayout.hostedGraph=graph;
    //configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    // graph在hostingView中的偏移
    graph.paddingBottom = 5.0f;
    graph.paddingLeft = 5.0f;
    graph.paddingRight = 5.0f;
    graph.paddingTop = 5.0f;
    graph.plotAreaFrame.borderLineStyle=nil;
    graph.plotAreaFrame.cornerRadius=0.0f;// hide frame
    // 绘图区4边留白
    graph.plotAreaFrame.paddingTop = 10.0f;
    graph.plotAreaFrame.paddingRight = 5.0f;
    graph.plotAreaFrame.paddingLeft = 50.0f;
    graph.plotAreaFrame.paddingBottom = 30.0f;
    //设置title
    
    // set up the plots
    CPTBarPlot *plot=[CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    // set up line style
    CPTMutableLineStyle *barLineStyle=[[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor=[CPTColor blackColor];
    barLineStyle.lineWidth=1.0;
    // set up text style
    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
    textLineStyle.color=[CPTColor blackColor];
    //set up plot space
    int xMax = 8;
    int xMin=0;
    int yMin=0;
    CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(xMin) length:CPTDecimalFromInt(xMax)];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(yMin) length:CPTDecimalFromInt(yMax)];
    
    // add plots to graph
    plot.dataSource=self;
    plot.delegate=self;  // 如果不需要柱状图的选择，这条语句是没必要的
    plot.baseValue=CPTDecimalFromInt(0); // 设定基值，大于该值的从此点向上画，小于该值的反向绘制，即向下画
    plot.barWidth=CPTDecimalFromDouble(1.0); // 设定柱图的宽度(0.0~1.0)
    plot.barOffset=CPTDecimalFromDouble(-0.0); // 柱图每个柱子开始绘制的偏移位置，我们让它绘制在刻度线中间，所以不偏移
    plot.lineStyle=barLineStyle;
    
    // set axis
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    // xAxis
    CPTXYAxis   *xAxis=axisSet.xAxis;
    CPTMutableLineStyle *xLineStyle=[[CPTMutableLineStyle alloc] init];
    xLineStyle.lineColor=[CPTColor blackColor];
    xLineStyle.lineWidth=1.0f;
    xAxis.axisLineStyle=xLineStyle;
    xAxis.labelingPolicy=CPTAxisLabelingPolicyNone;
    xAxis.axisConstraints=[CPTConstraints constraintWithLowerOffset:0.0];// 加上这两句才能显示label
    xAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    xAxis.majorTickLength=5;  // 刻度线的长度
    xAxis.majorIntervalLength=CPTDecimalFromInt(2); // 间隔单位,和xMin~xMax对应
    // 小刻度线minor...
    xAxis.minorTickLineStyle=nil;
    xAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
    // yAxis
    CPTXYAxis   *yAxis=axisSet.yAxis;
    yAxis.axisLineStyle=xLineStyle;
    yAxis.majorTickLineStyle=xLineStyle; //X轴大刻度线，线型设置
    yAxis.majorTickLength=5;  // 刻度线的长度
    yAxis.majorIntervalLength=CPTDecimalFromInt(4); // 间隔单位，和yMin～yMax对应
    // 小刻度线minor...
    yAxis.minorTickLineStyle=nil;  //  不显示小刻度线
    yAxis.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
//    [xLineStyle release];
    
    // 设置X轴label
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:4];
    NSArray        *conArray=[NSArray arrayWithObjects:@"中国",@"日本",@"英国",@"美国", nil];
    int labelLocation=1;
    for(NSString *label in conArray){
//        CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:<#(CPTTextStyle *)#>];

        CPTAxisLabel *newLabel=[[CPTAxisLabel alloc] initWithText:label textStyle:xAxis.labelTextStyle];
        newLabel.tickLocation=[[NSNumber numberWithInt:labelLocation] decimalValue];
        newLabel.offset=xAxis.labelOffset+xAxis.majorTickLength;
        [labelArray addObject:newLabel];
        labelLocation+= 2;
        [newLabel release];
    }
    xAxis.axisLabels=[NSSet setWithArray:labelArray];
    
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];  // 将plot添加到默认的空间中
    [self.view addSubview:chartLayout];
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
- (UILabel *)creatLabelWith:(BOOL)isOnline
{
    UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)] autorelease];
    if (isOnline)
        label.backgroundColor = [UIColor greenColor];
    else
        label.backgroundColor = [UIColor redColor];
    label.layer.cornerRadius = 10;
    return label;
}
- (void)update
{
    static int a = 0;
//    a ++;
    NSString *text = self.resultTextView.text;
    if (text == nil) text = @"0";
    NSMutableString *string = [NSMutableString stringWithString:text];
    [string appendString:[NSString stringWithFormat:@"%d",a]];
    [string appendString:server.result];
    self.resultTextView.text = string;
}

- (void)updateResult
{
    self.resultTextView.text = server.result;
    mArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",server.selectA],[NSString stringWithFormat:@"%d",server.selectB],[NSString stringWithFormat:@"%d",server.selectC],[NSString stringWithFormat:@"%d",server.selectD],nil];
    [graph reloadData];
}

- (void)startShareScreen
{
    UIImage *image = [UIImage imageNamed:@"pinganqinren"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    int count = [data length];
    for (int i = 0; i < count / 1000 + 1; i++)
    {
        NSRange range = NSMakeRange(i * 1000, 1000);
        [server writeScreen:[data subdataWithRange:range]];
    }
    [server stopWriteScreen];
//    [self performSelector:@selector(stopWriteScreen) withObject:server afterDelay:5.0f];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        server = [[ServerSocket alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateResult) name:UPDATE_RESULT_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startShareScreen) name:START_SHARE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultTextView.text = @"0";
    self.portLabel.text = [NSString stringWithFormat:@"%d",LISTEN_PORT];
    self.ipLabel.text =[NSString stringWithFormat:@"本机IP:%@",[self getIPAddress]];
    
    self.ipTableView.dataSource = self;
    self.ipTableView.delegate = self;

    cellData = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < 10 ; i ++)
    {
        int j = i%2;
        NSArray *a = [NSArray arrayWithObjects:[NSString stringWithFormat:@"196.168.0.%d",i], [NSString stringWithFormat:@"%d",j],nil];
        [cellData addObject:a];
    }

    NSLog(@"%@",cellData.description);
    // Do any additional setup after loading the view from its nib.
    
    [self addChart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [server startListen];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [server stopListen];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_RESULT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:START_SHARE_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backWasPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc {
    [_portLabel release];
    [_resultTextView release];
    [_ipTableView release];
    [_ipLabel release];
    [mArray release];
    [_shareScreenButton release];
    [super dealloc];
}
#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SocketServerChatViewController * chatViewController = nil;
    if ([SocketAppDelegate sharedAppDelegate].isServer)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            chatViewController = [[SocketServerChatViewController alloc] initWithNibName:@"SocketServerChatViewController_iPhone" bundle:nil];
        }
        else
        {
            chatViewController = [[SocketServerChatViewController alloc] initWithNibName:@"SocketServerChatViewController_iPad" bundle:nil];
        }
    }
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    chatViewController.title = cell.textLabel.text;
    [self.navigationController pushViewController:chatViewController animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    } 
    NSArray *subArray = [cellData objectAtIndex:indexPath.row];
    NSString *s = [subArray objectAtIndex:1];
    BOOL b = s.boolValue;
    
    cell.indentationLevel = 6;
    cell.textLabel.text = [subArray objectAtIndex:0];
    
    [cell.contentView addSubview:[self creatLabelWith:b]];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
- (IBAction)shareScreen:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (!isSharing)
    {
        [btn setTitle:@"结束共享" forState:UIControlStateNormal];
        [server shareScreen];
        isSharing = YES;
        
    }
    else
    {
        [btn setTitle:@"共享屏幕" forState:UIControlStateNormal];
        [server stopShareScreen];
        isSharing = NO;
    }
}

- (IBAction)lock:(id)sender
{
    [server lock];
}
- (IBAction)sendMessage:(id)sender
{
    [server sendMessage];
}

- (IBAction)unlock:(id)sender
{
    [server unlock];
}

#pragma mark - CPTBarPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return 4;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    NSNumber *num=nil;
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:
                num=[NSNumber numberWithInt:2 * index + 1];    // X轴上的数值表示
                break;
            case CPTBarPlotFieldBarTip:
                num=[NSDecimalNumber numberWithInt:[[mArray objectAtIndex:index] intValue]];
                break;
            default:
                break;
        }
    }
    return num;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index{
    CPTFill *fill = nil;
    switch (index) {
        case 0:
            fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor redColor].CGColor]];
            break;
        case 1:
            fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor yellowColor].CGColor]];
            break;
        case 2:
            fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor blueColor].CGColor]];
            break;
        case 3:
            fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[UIColor greenColor].CGColor]];
            break;
        default:
            break;
    };
    
    return fill;
}
// 在柱子上面显示对应的值

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
    textLineStyle.fontSize=14;
    textLineStyle.color=[CPTColor blackColor];
    CPTTextLayer *label = nil;
    if([mArray objectAtIndex:index] != 0)
    {
        label=[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@人",[mArray objectAtIndex:index]] style:textLineStyle];
    }
    return label;
}

- (void)viewDidUnload {
    [self setShareScreenButton:nil];
    [super viewDidUnload];
}
@end
