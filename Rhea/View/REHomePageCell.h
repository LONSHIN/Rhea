//
//  REHomePageCell.h
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RECar.h"

@protocol REHomePageCellDelegate;

@interface REHomePageCell : UITableViewCell

@property (nonatomic, weak) id<REHomePageCellDelegate> deleage;

- (void)updateWithCar:(RECar *)car needShowShadow:(BOOL)needShowShadow;

@end



@protocol REHomePageCellDelegate <NSObject>

@optional
- (void)selectedBreakRulesRowInHomePageCell:(REHomePageCell *)cell;
- (void)selectedRecallRowInHomePageCell:(REHomePageCell *)cell;

@end