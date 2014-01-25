//
//  REHomePageCell.m
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REHomePageCell.h"


@implementation REHomePageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateWithCar:(RECar *)car needShowShadow:(BOOL)needShowShadow
{
    [self.contentView removeAllSubviews];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.0f, 0.0f, 306.0f, 70.0f)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(7.0f, 35.5f, 292.0f, 0.5f)];
    lineView.backgroundColor = [UIColor grayColorWithDeep:188];
    [bgView addSubview:lineView];
    
    BOOL haveCarInfo = [car.licensePlateNumber isEqualToString:@""] ? NO : YES;
    UIView *breakRulesInfoView = [self infoViewWithFrame:CGRectMake(0.0f, 0.0, bgView.width, bgView.height / 2.0f)
                                                   title:haveCarInfo ? car.licensePlateNumber : @"未输入车辆信息"
                                          titleHighlight:haveCarInfo ? NO : YES
                                               minorInfo:haveCarInfo ? car.city.name : @""
                                              minorTitle:@"未处理违章次数:"
                                                  number:haveCarInfo ? [NSString stringWithFormat:@"%d", car.breakRulesCount] : @"?"
                                             bubbleColor:haveCarInfo ? kStandardBlueColor : kStandardRedColor];
    [bgView addSubview:breakRulesInfoView];

    UIButton *breakRulesButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bgView.width, bgView.height / 2.0f)];
    [breakRulesButton addTarget:self action:@selector(handleBreakRulesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:breakRulesButton];
    
    BOOL haveVinCodeInfo = [car.intactVinCode isEqualToString:@""] ? NO : YES;
    UIView *recallInfoView = [self infoViewWithFrame:CGRectMake(0.0f, breakRulesInfoView.height, bgView.width, bgView.height / 2.0f)
                                               title:haveVinCodeInfo ? car.intactVinCode : @"未输入完整车辆识别代码(VIN)"
                                      titleHighlight:haveVinCodeInfo ? NO : YES
                                           minorInfo:haveVinCodeInfo ? [NSString stringWithFormat:@"%@", car.series] : @""
                                          minorTitle:@"召回次数:"
                                              number:haveVinCodeInfo ? [NSString stringWithFormat:@"%d", car.recallCount] : @"?"
                                         bubbleColor:haveVinCodeInfo ? kStandardGreenColor: kStandardRedColor];
    [bgView addSubview:recallInfoView];
    
    UIButton *recallButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, breakRulesButton.height, breakRulesButton.width, breakRulesButton.height)];
    [recallButton addTarget:self action:@selector(handleRecallButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:recallButton];
    
    if (needShowShadow) {
        UIImage *shadow = [[UIImage imageNamed:@"last_cell_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.5f, 0.0f, 2.5f)];
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 65.0f, 306.0f, 5.5f)];
        shadowView.image = shadow;
        [bgView addSubview:shadowView];
    }
}


- (UIView *)infoViewWithFrame:(CGRect)frame title:(NSString *)title titleHighlight:(BOOL)needTitleHighlight minorInfo:(NSString *)minorInfo minorTitle:(NSString *)minorTitle number:(NSString *)number bubbleColor:(UIColor *)bubbleColor
{
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    
    UILabel *titleLabel = [UILabel labelWithText:title
                                 backgroundColor:[UIColor clearColor]
                                       textColor:needTitleHighlight ? kStandardRedColor : [UIColor blackColor]
                                            font:[UIFont systemFontOfSize:needTitleHighlight ? 12.0f : 14.0f]];
    titleLabel.frame = CGRectMake(6.0f, 0.0f, titleLabel.width, contentView.height);
    [contentView addSubview:titleLabel];
    
    UILabel *numberLabel = [UILabel labelWithText:number
                                  backgroundColor:bubbleColor
                                        textColor:[UIColor whiteColor]
                                             font:[UIFont systemFontOfSize:14.0]];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.frame = CGRectMake(contentView.width - 17.0f - numberLabel.width, 7.0f, MAX(20.0f, numberLabel.width + 10.0f), 20.0f);
    [contentView addSubview:numberLabel];
    numberLabel.layer.cornerRadius = 10.0f;
    numberLabel.layer.masksToBounds = YES;
    
    UILabel *minorTitleLable = [UILabel labelWithText:minorTitle
                                 backgroundColor:[UIColor clearColor]
                                       textColor:[UIColor lightGrayColor]
                                            font:[UIFont systemFontOfSize:12.0f]];
    minorTitleLable.frame = CGRectMake(contentView.width - numberLabel.width - minorTitleLable.width - 10.0f, 0.0f, minorTitleLable.width, contentView.height);
    [contentView addSubview:minorTitleLable];
    
    UILabel *minorInfoLabel = [UILabel labelWithText:minorInfo
                                     backgroundColor:[UIColor clearColor]
                                           textColor:[UIColor lightGrayColor]
                                                font:[UIFont systemFontOfSize:12.0f]];
    minorInfoLabel.textAlignment = NSTextAlignmentRight;
    minorInfoLabel.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.width + 10, 0.0f, contentView.width - minorTitleLable.width - titleLabel.width - numberLabel.width - 30.0f, contentView.height);
    [contentView addSubview:minorInfoLabel];
    
    return contentView;
}


#pragma mark - Button Action

- (void)handleBreakRulesButtonTapped:(UIButton *)sender
{
    if ([self.deleage respondsToSelector:@selector(selectedBreakRulesRowInHomePageCell:)]) {
        [self.deleage selectedBreakRulesRowInHomePageCell:self];
    }
}


- (void)handleRecallButtonTapped:(UIButton *)sender
{
    if ([self.deleage respondsToSelector:@selector(selectedRecallRowInHomePageCell:)]) {
        [self.deleage selectedRecallRowInHomePageCell:self];
    }
}

@end
