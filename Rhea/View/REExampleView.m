//
//  REExampleView.m
//  Rhea
//
//  Created by Tiger on 14-1-24.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REExampleView.h"

@interface REExampleView ()

@property (nonatomic, assign) REExampleType type;

@end


@implementation REExampleView

- (id)initWithFrame:(CGRect)frame type:(REExampleType)type;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self showView];
}

- (void)showView
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.65f;
    [self addSubview:maskView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [maskView addGestureRecognizer:tapGR];
    
    UIImageView *imageView = [UIImageView imageViewWithImageName:@"vin_engine_code_example"];
    imageView.center = CGPointMake(self.width / 2.0f, self.height / 2.5f);
    [self addSubview:imageView];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0f;
    }];
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
