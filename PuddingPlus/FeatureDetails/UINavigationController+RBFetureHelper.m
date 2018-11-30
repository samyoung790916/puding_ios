//
//  PDNavtionController+RBFetureHelper.m
//  PuddingPlus
//
//  Created by kieran on 2017/2/20.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "UINavigationController+RBFetureHelper.h"
#import "PDFeatureDetailsController.h"
#import "PDFeatureListController.h"
#import "RBMyRobotController.h"
@implementation UINavigationController (RBFetureHelper)


- (void)pushFetureList:(PDFeatureModle *)playModle{
    NSArray * viewControllers = self.viewControllers;
    PDFeatureListController * shouldToController = nil;
    for(UIViewController * cont in viewControllers){
        if([cont isKindOfClass:[PDFeatureListController class]]){
            shouldToController = (PDFeatureListController *)cont;
            break;
        }
    }
    if(shouldToController){
        [shouldToController setModle:playModle];
        [self popToViewController:shouldToController animated:YES];
    }else{
        PDFeatureListController * contr = [[PDFeatureListController alloc] init];
        contr.modle = playModle;
        [self pushViewController:contr animated:YES];
    }
    
}


- (void)pushFetureDetail:(PDFeatureModle *)playModle SourceModle:(PDFeatureModle *)source{
    if (RBDataHandle.currentDevice.isStorybox) {
        NSArray * viewControllers = self.viewControllers;
        RBMyRobotController * shouldToController = nil;
        for(UIViewController * cont in viewControllers){
            if([cont isKindOfClass:[RBMyRobotController class]]){
                shouldToController = (RBMyRobotController *)cont;
                break;
            }
        }
        if(shouldToController){
            shouldToController.fromFooter = false;
            [shouldToController setPlayInfoModle:playModle];
//            if (source) {
                [shouldToController setClassSrcModle:source];
//            }
            [self popToViewController:shouldToController animated:YES];
        }else{
            RBMyRobotController * contr = [[RBMyRobotController alloc] initWithNibName:@"RBMyRobotController" bundle:nil];
            contr.fromFooter = false;
            [contr setPlayInfoModle:playModle];
//            if (source) {
                [contr setClassSrcModle:source];
//            }
            [self pushViewController:contr animated:YES];
        }
    }
    else{
        NSArray * viewControllers = self.viewControllers;
        PDFeatureDetailsController * shouldToController = nil;
        for(UIViewController * cont in viewControllers){
            if([cont isKindOfClass:[PDFeatureDetailsController class]]){
                shouldToController = (PDFeatureDetailsController *)cont;
                break;
            }
        }
        if(shouldToController){
            [shouldToController setPlayInfoModle:playModle];
//            if (source) {
                [shouldToController setClassifyModle:source];
//            }
            [self popToViewController:shouldToController animated:YES];
        }else{
            PDFeatureDetailsController * contr = [[PDFeatureDetailsController alloc] init];
            [contr setPlayInfoModle:playModle];
//            if (source) {
                [contr setClassifyModle:source];
//            }
            [self pushViewController:contr animated:YES];
        }
    }
}
@end
