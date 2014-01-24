//
//  REDetailViewController.h
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REViewController.h"
#import "RECar.h"

typedef NS_ENUM(NSInteger, REDetailType) {
    REDetailTypeBreakRules,
    REDetailTypeRecall,
};

@protocol REDetailViewControllerDelegate;



@interface REDetailViewController : REViewController

@property (nonatomic, strong) RECar *car;
@property (nonatomic, weak) id <REDetailViewControllerDelegate> delegate;
@property (nonatomic, assign) REDetailType currentShowType;

- (id)initWithCar:(RECar *)car showType:(REDetailType)type;
- (void)switchToViewWithShowType:(REDetailType)type;

- (void)reloadBreakRulesDataWithCar:(RECar *)car;
- (void)reloadRecallDataWithCar:(RECar *)car;

@end


@protocol REDetailViewControllerDelegate <NSObject>

- (void)detailViewController:(REDetailViewController *)detailViewController needChangeToShowType:(REDetailType)type;

@end