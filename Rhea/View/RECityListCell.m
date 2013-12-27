//
//  RECityListCell.m
//  Rhea
//
//  Created by Tiger on 13-12-27.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECityListCell.h"
#import "RECity.h"


@implementation RECityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (CGFloat)heightForCitys:(NSArray *)citys
{
    return 60;
}




@end
