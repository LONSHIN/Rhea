//
//  REBreakRulesCell.m
//  Rhea
//
//  Created by Tiger on 14-1-22.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REDetailCell.h"

@implementation REDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWithBreakRulesInfo:(REBreakRulesInfo *)breakRulesInfo recordIndex:(NSInteger)index
{
    [self.contentView removeAllSubviews];
    
    NSArray *titleArray = @[@"违章时间", @"违章地点", @"违章行为", @"扣分", @"罚款金额"];
    NSArray *detailArray = @[breakRulesInfo.time, breakRulesInfo.place, breakRulesInfo.problem, breakRulesInfo.demeritPoints, breakRulesInfo.money];
    
    [self layoutWithTitleArray:titleArray detailArray:detailArray recordIndex:index];
}


- (void)updateWithRecallInfo:(RERecallInfo *)recallInfo recordIndex:(NSInteger)index
{
    [self.contentView removeAllSubviews];
    
    NSArray *titleArray = @[@"召回时间", @"涉及数量", @"缺陷情况", @"可能后果", @"维修措施", @"改进措施", @"投诉情况", @"车主通知", @"其他信息"];
    NSArray *detailArray = @[recallInfo.availableTime, recallInfo.involvingNumber, recallInfo.problem, recallInfo.consequence, recallInfo.fixMeasures, recallInfo.improveMeasures, recallInfo.complaints, recallInfo.ownersNotice, recallInfo.otherInfo];
    
    [self layoutWithTitleArray:titleArray detailArray:detailArray recordIndex:index];
}


- (void)layoutWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray recordIndex:(NSInteger)index
{
    CGFloat y = 7.0f;
    
    UIImage *indexBg = [[UIImage imageNamed:@"section_title_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 4.0f, 0.0f, 4.0f)];
    UIImageView *indexBgView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, y, 306.0f, 25.0f)];
    indexBgView.image = indexBg;
    [self.contentView addSubview:indexBgView];
    
    UILabel *indexLabel = [UILabel labelWithText:[NSString stringWithFormat:@"第%d条记录", index]
                                 backgroundColor:[UIColor clearColor]
                                       textColor:[UIColor whiteColor]
                                            font:[UIFont systemFontOfSize:14.0]];
    indexLabel.frame = CGRectMake(7.0f, y, 306.0f, 25.0f);
    
    indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:indexLabel];
    y += indexLabel.height;
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIView *view = [self viewWithTitle:titleArray[i] detail:detailArray[i] needShowLine:(i == titleArray.count - 1 ? NO : YES)];
        view.frame = CGRectMake(7.0f, y, view.width, view.height);
        [self.contentView addSubview:view];
        y += view.height;
    }
    
    UIImage *shadow = [[UIImage imageNamed:@"last_cell_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.5f, 0.0f, 2.5f)];
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, y, 306.0f, 5.5f)];
    shadowView.image = shadow;
    [self.contentView addSubview:shadowView];
}


- (UIView *)viewWithTitle:(NSString *)title detail:(NSString *)detail needShowLine:(BOOL)needShowLine
{
    CGSize detailSize = [detail sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(217.0f, MAXFLOAT)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.0f, 0.0f, 306.0f, detailSize.height + 16.0f)];
    bgView.backgroundColor = [UIColor whiteColor];

    if (needShowLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7.0f, bgView.height - 0.5f, 292.0f, 0.5f)];
        line.backgroundColor = [UIColor grayColorWithDeep:189];
        [bgView addSubview:line];
    }
    
    UILabel *titleLabel = [UILabel labelWithText:title
                                 backgroundColor:[UIColor clearColor]
                                       textColor:kStandardBlueColor
                                            font:[UIFont systemFontOfSize:12.0f]];
    titleLabel.frame = CGRectMake(7.0f, 0.0f, 55.0f, bgView.height);
    titleLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:titleLabel];
    
    UILabel *detailLabel = [UILabel labelWithText:detail
                                  backgroundColor:[UIColor clearColor]
                                        textColor:[UIColor blackColor]
                                             font:[UIFont systemFontOfSize:12.0f]];
    detailLabel.frame = CGRectMake(80.0f, 0.0f, 217.0f, bgView.height);
    detailLabel.numberOfLines = 0;
    [bgView addSubview:detailLabel];
    
    return bgView;
}


+ (CGFloat)heightWithTextArray:(NSArray *)textArray
{
    CGFloat height = 37.0f;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(217.0f, MAXFLOAT)];
        height += textSize.height + 16.0f;
    }
    return height;
}


+ (CGFloat)heightWithBreakRulesInfo:(REBreakRulesInfo *)breakRulesInfo
{
    NSArray *textArray = @[breakRulesInfo.time, breakRulesInfo.place, breakRulesInfo.problem, breakRulesInfo.demeritPoints, breakRulesInfo.money];
    
    return [REDetailCell heightWithTextArray:textArray];
}


+ (CGFloat)heightWithRecallInfo:(RERecallInfo *)recallInfo
{
    NSArray *textArray = @[recallInfo.availableTime, recallInfo.involvingNumber, recallInfo.problem, recallInfo.consequence, recallInfo.fixMeasures, recallInfo.improveMeasures, recallInfo.complaints, recallInfo.ownersNotice, recallInfo.otherInfo];
    return [REDetailCell heightWithTextArray:textArray];
}

@end
