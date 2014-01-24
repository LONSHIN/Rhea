//
//  REBreakRulesCell.h
//  Rhea
//
//  Created by Tiger on 14-1-22.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REBreakRulesInfo.h"
#import "RERecallInfo.h"

@interface REDetailCell : UITableViewCell

- (void)updateWithBreakRulesInfo:(REBreakRulesInfo *)breakRulesInfo recordIndex:(NSInteger)index;
+ (CGFloat)heightWithBreakRulesInfo:(REBreakRulesInfo *)breakRulesInfo;

- (void)updateWithRecallInfo:(RERecallInfo *)recallInfo recordIndex:(NSInteger)index;
+ (CGFloat)heightWithRecallInfo:(RERecallInfo *)recallInfo;

@end
