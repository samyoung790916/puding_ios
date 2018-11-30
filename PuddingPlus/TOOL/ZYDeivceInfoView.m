//
//  ZYDeivceInfoView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/2/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "ZYDeivceInfoView.h"
#import <mach/mach.h>

@implementation ZYDeivceInfoView{
    CADisplayLink          *_displayLink;
    NSUInteger              _historyDTLength;
    CFTimeInterval          _historyDT[320];
    CFTimeInterval          _displayLinkTickTimeLast;
    CFTimeInterval          _lastUIUpdateTime;
    
    CATextLayer            *_fpsTextLayer;
    CAShapeLayer           *_linesLayer;
    CAShapeLayer           *_chartLayer;
    
    BOOL                    _showsAverage;
    UITextView * textView;
    NSTimer * timer;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (id)init {
    if( (self = [super initWithFrame:[[UIApplication sharedApplication] statusBarFrame]]) ){
        _historyDTLength        = 0;
        _displayLinkTickTimeLast= CACurrentMediaTime();
        _showsAverage = YES;
        [self setWindowLevel: UIWindowLevelStatusBar +1.0f];
        
        
        // Track FPS using display link
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        [_displayLink setPaused:NO];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // Chart Layer
        _chartLayer = [CAShapeLayer layer];
        [_chartLayer setFrame: self.bounds];
        [_chartLayer setStrokeColor: [UIColor redColor].CGColor];
        [_chartLayer setFillColor:[[UIColor clearColor] CGColor]];
        [_chartLayer setContentsScale: [UIScreen mainScreen].scale];
        [self.layer addSublayer:_chartLayer];
        
        // Info Layer
        _fpsTextLayer = [CATextLayer layer];
        [_fpsTextLayer setFrame: CGRectMake(30.0f, self.bounds.size.height -16.0f, self.bounds.size.width - 30, 13.0f)];
        [_fpsTextLayer setFontSize: 11.0f];
        _fpsTextLayer.alignmentMode = @"left";
        [_fpsTextLayer setForegroundColor: [UIColor colorWithRed:0.960 green:0.019 blue:0.144 alpha:1.000].CGColor];
        [_fpsTextLayer setContentsScale: [UIScreen mainScreen].scale];
        [self.layer addSublayer:_fpsTextLayer];
        
        // Draw asynchronously on iOS6+
        if( [_chartLayer respondsToSelector:@selector(setDrawsAsynchronously:)] ){
            [_linesLayer setDrawsAsynchronously:YES];
            [_chartLayer setDrawsAsynchronously:YES];
            [_fpsTextLayer setDrawsAsynchronously:YES];
        }
        
        [self setDesiredChartUpdateInterval: 1.0f /2.0f];
        
        
        UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showBtn.frame = CGRectMake(self.bounds.size.width - 100 , self.bounds.size.height -16.0f, 50, 15);
        [showBtn setTitle:NSLocalizedString( @"display_statistics", nil) forState:UIControlStateNormal];
        [showBtn setTitle:NSLocalizedString( @"close_statistics", nil) forState:UIControlStateSelected];
        [showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        showBtn.titleLabel.font =[UIFont systemFontOfSize:11 ];
        
        showBtn.selected = YES;
        
        [self addSubview:showBtn];
        [showBtn addTarget:self action:@selector(showLogBtn:) forControlEvents:UIControlEventTouchUpInside] ;
        
        //[self showLogBtn:showBtn];
    }
    return self;
}


#pragma mark -
#pragma mark RRFPSBar


+ (ZYDeivceInfoView *)sharedInstance {
    static ZYDeivceInfoView *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ZYDeivceInfoView alloc] init];
    });
    return _sharedInstance;
}


- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}


- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}


- (void)showLogBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        UITextView * lable = [[UITextView alloc] initWithFrame:CGRectMake(20, STATE_HEIGHT, self.frame.size.width - 40, 100)];
        lable.tag = 1234;
        lable.backgroundColor = [UIColor clearColor];
        lable.userInteractionEnabled = NO;
        lable.font = [UIFont systemFontOfSize:11];
        lable.textColor = [UIColor redColor];
        
        [self addSubview:lable];
        
        textView = lable;
        
        __strong typeof(lable) weakLable = lable;
        
        [RBStat setLogCallBack:^(NSString * string) {
            NSString * showTxt = [weakLable.text length] > 100 ? [weakLable.text substringWithRange:NSMakeRange([weakLable.text length] - 100, 100)] : weakLable.text;
            dispatch_async_on_main_queue(^{
                weakLable.text  = [NSString stringWithFormat:@"%@%@\n",showTxt,string];
                
            });
            
            
        }];
        
    }else{
        [timer invalidate];
        timer = nil;
        [textView removeFromSuperview];
        textView = nil;
    }
    
    
    
}

- (void)displayLinkTick {
    
    // Shift up the buffer
    for ( NSUInteger i = _historyDTLength; i >= 1; i-- ) {
        _historyDT[i] = _historyDT[i -1];
    }
    
    // Store new state
    _historyDT[0] = _displayLink.timestamp -_displayLinkTickTimeLast;
    
    // Update length if there is more place
    if ( _historyDTLength < 319 ) _historyDTLength++;
    
    // Store last timestamp
    _displayLinkTickTimeLast = _displayLink.timestamp;
    
    // Update UI
    CFTimeInterval timeSinceLastUIUpdate = _displayLinkTickTimeLast -_lastUIUpdateTime;
    if( _historyDT[0] < 0.1f && timeSinceLastUIUpdate >= _desiredChartUpdateInterval ){
        [self updateChartAndText];
    }
}


- (void)updateChartAndText {
    
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    //    [path moveToPoint:CGPointZero];
    //
    CFTimeInterval maxDT = CGFLOAT_MIN;
    CFTimeInterval avgDT = 0.0f;
    
    for( NSUInteger i=0; i<=_historyDTLength; i++ ){
        maxDT = MAX(maxDT, _historyDT[i]);
        avgDT += _historyDT[i];
        
        //        CGFloat fraction =  roundf(1.0f /(float)_historyDT[i]) /60.0f;
        //        CGFloat y = _chartLayer.frame.size.height -_chartLayer.frame.size.height *fraction;
        //        y = MAX(0.0f, MIN(_chartLayer.frame.size.height, y));
        //
        //        [path addLineToPoint:CGPointMake(i +1.0f, y)];
    }
    
    avgDT /= _historyDTLength;
    //    _chartLayer.path = path.CGPath;
    
    CFTimeInterval minFPS = roundf(1.0f /(float)maxDT);
    CFTimeInterval avgFPS = roundf(1.0f /(float)avgDT);
    
    NSString *text;
    if( _showsAverage ){
        text = [NSString stringWithFormat:@"FPS L:%.f-M:%.f CPU:%.2f %% %@", minFPS, avgFPS,[self cpu_usage] * 100,logMemUsage()];
    } else {
        text = [NSString stringWithFormat:@"low %.f", minFPS];
    }
    
    [_fpsTextLayer setString: text];
    
    
    _lastUIUpdateTime = _displayLinkTickTimeLast;
}

vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

NSString * logMemUsage() {
    // compute memory usage and log if different by >= 100k
    static long prevMemUsage = 0;
    long curMemUsage = usedMemory();
    long memUsageDiff = curMemUsage - prevMemUsage;
    
    if (memUsageDiff > 100000 || memUsageDiff < -100000) {
        prevMemUsage = curMemUsage;
        //        return [NSString stringWithFormat: @"Memory used %7.1f (%+5.0f), free %.1f MB", curMemUsage/1024.0f/1024.0f, memUsageDiff/1024.0f/1024.0f, freeMemory()/1024.0f/1024.0f];
    }
    //    return [NSString stringWithFormat: @"Memory used %7.1f (%+5.0f), free %.1f MB", curMemUsage/1024.0f/1024.0f, memUsageDiff/1024.0f/1024.0f, freeMemory()/1024.0f/1024.0f];
    return [NSString stringWithFormat: @"Memory %7.1fMB", curMemUsage/1024.0f/1024.0f];
}

//
//// 获取当前设备可用内存(单位：MB）
//- (double)availableMemory
//{
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(),
//                                               HOST_VM_INFO,
//                                               (host_info_t)&vmStats,
//                                               &infoCount);
//
//    if (kernReturn != KERN_SUCCESS) {
//        return NSNotFound;
//    }
//
//    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
//}
//
//// 获取当前任务所占用的内存（单位：MB）
//- (double)usedMemory
//{
//    task_basic_info_data_t taskInfo;
//    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
//    kern_return_t kernReturn = task_info(mach_task_self(),
//                                         TASK_BASIC_INFO,
//                                         (task_info_t)&taskInfo,
//                                         &infoCount);
//
//    if (kernReturn != KERN_SUCCESS
//        ) {
//        return NSNotFound;
//    }
//
//    return taskInfo.resident_size / 1024.0 / 1024.0;
//}



- (float)cpu_usage
{
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    return tot_cpu;
}

@end
