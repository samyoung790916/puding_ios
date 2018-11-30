//
//  PDNewQuestionCell.h
//  Pudding
//
//  Created by baxiang on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDEditQuesFrameModel.h"

@protocol PDNewQuestionCellDelegate <NSObject>
@required
- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
//-(void)currentText:(NSString*) text isAnswerView:(BOOL) isAnswerView height:(CGFloat) height;
@end

@interface PDNewQuestionCell : UITableViewCell
@property (nonatomic,assign) BOOL isAnswerView;
@property (nonatomic,weak) id<PDNewQuestionCellDelegate> delegate;
/**
 *  对话内容
 */
@property (nonatomic,copy) NSString *contentText;
@end
