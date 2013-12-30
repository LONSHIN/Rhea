//
//  RECityListCell.h
//  Rhea
//
//  Created by Tiger on 13-12-27.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RECityListCellDelegate;

typedef void(^RECityListCellTappedItemBlcok)(NSInteger index);



@interface RECityListCell : UITableViewCell

@property (nonatomic, strong) RECityListCellTappedItemBlcok tappedItemBlock;

+ (CGFloat)heightForCitys:(NSArray *)citys;

- (void)layoutWithSection:(NSInteger)section citys:(NSArray *)citys;

@end

