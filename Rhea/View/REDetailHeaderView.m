//
//  REDetailHeaderView.m
//  Rhea
//
//  Created by Tiger on 14-1-23.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REDetailHeaderView.h"

@implementation REDetailHeaderView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title detail:(NSString *)detail recordCount:(NSString *)recordCount
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height)];
        maskView.backgroundColor =  [UIColor colorWithHexString:@"fafafa"];
        maskView.alpha = 0.95f;
        [self addSubview:maskView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.height - 0.5f, self.width, 0.5f)];
        line.backgroundColor = [UIColor colorWithHexString:@"afafaf"];
        [self addSubview:line];
        
        UILabel *titleLable = [UILabel labelWithText:title
                                     backgroundColor:[UIColor clearColor]
                                           textColor:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:12.0f]];
        titleLable.frame = CGRectMake(18.0f, 8.0f, titleLable.width, titleLable.height);
        [self addSubview:titleLable];
        
        UILabel *detailLabel = [UILabel labelWithText:detail
                                      backgroundColor:[UIColor clearColor]
                                            textColor:kStandardBlueColor
                                                 font:[UIFont systemFontOfSize:14.0f]];
        detailLabel.frame = CGRectMake(18.0f, 22.0f, detailLabel.width, detailLabel.height);
        [self addSubview:detailLabel];
        
        NSMutableAttributedString *recordString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共 %@ 条记录", recordCount]];
        [recordString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, recordString.length)];
        [recordString addAttribute:NSForegroundColorAttributeName value:kStandardBlueColor range:NSMakeRange(2, recordCount.length)];
        [recordString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(2, recordCount.length)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(208.0f, 18.0f, 105.0f, 18.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.attributedText = recordString;
        [self addSubview:label];
    }
    return self;
}



@end
