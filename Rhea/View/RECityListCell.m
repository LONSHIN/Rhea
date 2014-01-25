//
//  RECityListCell.m
//  Rhea
//
//  Created by Tiger on 13-12-27.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECityListCell.h"
#import "RECity.h"

#define kTagOfButtonBasic    789


@interface RECityListCell ()

@property (nonatomic, assign) NSInteger section;

@end



@implementation RECityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf9fe"];
        self.backgroundColor = [UIColor colorWithHexString:@"edf9fe"];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)layoutWithSection:(NSInteger)section citys:(NSArray *)citys
{
    [self.contentView removeAllSubviews];
    self.section = section;

    CGFloat x = 10.0f;
    CGFloat y = 0.0f;
    for (NSInteger i = 0; i < citys.count; i++) {
        RECity *city = [citys objectAtIndex:i];
        UIButton *cityItem = [UIButton buttonWithText:city.name
                                                 font:[UIFont systemFontOfSize:14.0f]
                                            textColor:kStandardBlueColor
                                     highlightedColor:[UIColor grayColor]
                                               target:self
                                               action:@selector(handleCityItemTapped:)];
        cityItem.tag = kTagOfButtonBasic + i;
        
        if (x + cityItem.width > 320.0f) {
            x = 10.0;
            y += 37.0f;
        }
        
        cityItem.frame = CGRectMake(x, y, cityItem.width, cityItem.height);
        [self.contentView addSubview:cityItem];
        
        x += cityItem.width + 30.0f;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10.0f, [RECityListCell heightForCitys:citys] - 0.5f, self.width, 0.5f)];
    line.backgroundColor = [UIColor colorWithHexString:@"afafaf"];
    [self.contentView addSubview:line];
}


- (void)handleCityItemTapped:(UIButton *)sender
{
    if (self.tappedItemBlock != nil) {
        self.tappedItemBlock(sender.tag - kTagOfButtonBasic);
    }
}


+ (CGFloat)heightForCitys:(NSArray *)citys
{
    CGFloat height = 45.0f;
    CGFloat singleLineWidth = 20.0f;
    for (NSInteger i = 0; i < citys.count; i++) {
        RECity *city = citys[i];
        CGSize size = [city.name sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        
        singleLineWidth += size.width + 30;
        if (singleLineWidth > 320.0f) {
            singleLineWidth = 20.0f;
            height += 37.0f;
            i--;
        }
    }
    
    return height;
}


@end
