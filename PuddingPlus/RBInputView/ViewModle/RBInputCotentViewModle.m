//
//  RBInputHistoryViewModle.m
//  RBInputView
//
//  Created by kieran on 2017/2/7.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputCotentViewModle.h"
#import "PDTTSHistoryModle.h"
#import "RBNetworkHandle.h"
#import "RBNetworkHandle+Account.h"
#import "SandboxFile.h"
#import "RBNetworkHandle+ctrl_device.h"


@implementation RBInputHistoryViewModle

- (void)remove:(PDTTSHistoryModle *)modle Block:(void(^)(BOOL)) block{
    [modle deleteToDB];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:_dataArrays];
    if([arr containsObject:modle]){
        [arr removeObject:modle];
        _dataArrays = arr;
        if(block){
            block(YES);
        }
    }else{
        if(block){
            block(NO);
        }
    }
}


- (void)update:(void(^)(BOOL)) block{
    NSMutableArray * markArr = [[NSMutableArray alloc]initWithArray:[PDTTSHistoryModle searchWithWhere:nil orderBy:@"rowid DESC" offset:0 count:10]];
    while (markArr.count > 500) {
        PDTTSHistoryModle * modle = [markArr lastObject];
        [modle deleteToDB];
        [markArr removeLastObject];
    }
    _dataArrays = markArr;
    if(block){
        block(YES);
    }
}


@end


@interface RBInputHabitsViewModle (){
    BOOL dataShouldUpdate;
}

@property (nonatomic,strong) NSArray * netDataArray;
@property (nonatomic,strong) NSArray * markDataArray;
@end

@implementation RBInputHabitsViewModle


- (NSMutableArray *)dataSource{
    if(dataShouldUpdate){
        dataShouldUpdate = NO;
        NSMutableArray * data = [[NSMutableArray alloc] init];
        [data addObjectsFromArray:self.markDataArray];
        for(int i= 0 ; i < [self.netDataArray count] ; i++){
            PDHabitCultureModle * modle = [self.netDataArray objectAtIndex:i];
            BOOL isMark = NO;
            for(int j= 0 ; j < [self.markDataArray count] ; j++){
                PDHabitCultureModle * mmodle = [self.markDataArray objectAtIndex:j];
                if([modle.hid intValue] ==[ mmodle.hid intValue]){
                    isMark = YES;
                    break;
                }
            }
            if(!isMark){
                [data addObject:modle];
            }
        }
        _dataSource = data;
    }
    return _dataSource;
}


- (void)loadhabits:(void(^)()) block{
    _dataSource = nil;
    
    @weakify(self)
    [self loadNetHabits:^{
        @strongify(self)
        [self loadSaveHiabits:^{
            dataShouldUpdate = YES;
            block();
        }];
    }];

}

- (void)updatehabits:(void(^)()) block{
    _dataSource = nil;
    [self loadSaveHiabits:^{
        dataShouldUpdate = YES;
        block();
    }];
}


- (void)saveHabitsModle:(PDHabitCultureModle *)modle Block:(void(^)()) block{
    if(!modle.isMark){
        modle.isMark = YES;
        [modle saveToDB];
    }
    [self updatehabits:^{
        dataShouldUpdate = YES;
        block();
    }];
}

- (void)removeHabitsModle:(PDHabitCultureModle *)modle Block:(void(^)()) block{
    if(modle.isMark){
        [modle deleteToDB];
    }
    [self updatehabits:^{
        dataShouldUpdate = YES;
        block();
    }];
}


- (void)loadNetHabits:(void(^)()) block{
    [RBNetworkHandle getUserCustomDataWith:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSArray * array = [[res objectForKey:@"data"] objectForKey:@"list"];
            if(array.count > 0){
                NSMutableArray * netData = [NSMutableArray new];
                for(NSDictionary * dic in array){
                    NSMutableDictionary * rs = [[NSMutableDictionary alloc] initWithDictionary:dic];
                    [rs setObject:[rs objectForKey:@"id"] forKey:@"hid"];
                    [rs removeObjectForKey:@"id"];
                    PDHabitCultureModle * modle = [PDHabitCultureModle modelWithDictionary:rs];
                    modle.isMark = NO;
                    [netData addObject:modle];
                }
                self.netDataArray = [netData copy];
            }
        }
        if(block){
            block();
        }
    }];
}

- (void)loadSaveHiabits:(void(^)()) block{
    NSMutableArray * markArr = [[NSMutableArray alloc]initWithArray:[PDHabitCultureModle searchWithWhere:nil]];
    self.markDataArray = markArr;
    if(block){
        block();
    }
}



@end


#pragma mark - 搞笑逗趣
#import "PDFunnyResouseModle.h"

@implementation RBInputFunnyKeysViewModle


- (void)changeFunnyKeys:(void(^)()) block{
    @weakify(self)
    [self loadLocalData:^(NSArray * funnykeys) {
        @strongify(self)
        self.funnyKeys = funnykeys;
        block();
    }];
    [self loadNetData];
}


- (void)loadNetData{
    [RBNetworkHandle changeCtrlRespose:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0 ){
            __block NSArray * array = [res objectForKey:@"data"];
            [array writeToFile:[[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"] atomically:YES];
        }
    }];
}

- (void)loadLocalData:(void(^)(NSArray * )) block{
    NSError * error = nil;
    NSString * path = [[SandboxFile GetDocumentPath] stringByAppendingString:@"/funnyResouse.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"funnyResouse" ofType:@"plist"] toPath:path error:&error];
    }
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"funnyResouse not exists ");
    
    if(!block ){
        NSLog(@"no call back method");
        return;
    }
    NSMutableArray * funnkeys = [NSMutableArray new];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    NSAssert([array isKindOfClass:[NSArray class]], @"funnyResouse data format error ");

    for(NSDictionary * dic in array){
        PDFunnyResouseModle * modle = [PDFunnyResouseModle modelWithDictionary:dic];
        [funnkeys addObject:modle];
    }
    
    block(funnkeys);
}


@end
