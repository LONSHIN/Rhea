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
        self.backgroundColor = [UIColor colorWithHexString:@"e7eef7"];
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
    CGFloat y = 10.0f;
    for (NSInteger i = 0; i < citys.count; i++) {
        RECity *city = [citys objectAtIndex:i];
        UIButton *cityItem = [UIButton buttonWithText:city.name
                                                 font:[UIFont systemFontOfSize:13.0f]
                                            textColor:[UIColor colorWithHexString:@"4186f4"]
                                     highlightedColor:[UIColor randomColor]
                                               target:self
                                               action:@selector(handleCityItemTapped:)];
        cityItem.tag = kTagOfButtonBasic + i;
        
        if (x + cityItem.width > 320.0f) {
            x = 10.0;
            y += 40.0f;
        }
        
        cityItem.frame = CGRectMake(x, y, cityItem.width, cityItem.height);
        [self.contentView addSubview:cityItem];
        
        x += cityItem.width + 10.0f;
    }
}


- (void)handleCityItemTapped:(UIButton *)sender
{
    if (self.tappedItemBlock != nil) {
        self.tappedItemBlock(sender.tag - kTagOfButtonBasic);
    }
}


+ (CGFloat)heightForCitys:(NSArray *)citys
{
    CGFloat height = 60.0f;
    CGFloat singleLineWidth = 20.0f;
    for (NSInteger i = 0; i < citys.count; i++) {
        RECity *city = citys[i];
        CGSize size = [city.name sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        
        singleLineWidth += size.width + 10;
        if (singleLineWidth > 320.0f) {
            singleLineWidth = 20.0f;
            height += 40.0f;
            i--;
        }
    }
    
    return height;
}


@end
