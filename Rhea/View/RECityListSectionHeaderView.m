//
//  RECityListSectionHeaderView.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECityListSectionHeaderView.h"

@interface RECityListSectionHeaderView ()

@property (nonatomic, assign) BOOL isOpen;

@end


@implementation RECityListSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configTextLabel];
        [self configTap];
        self.isOpen = NO;
    }
    return self;
}


- (void)configTextLabel
{
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, self.height)];
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.textLabel];
}


- (void)configTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (self.tappedBlock != nil) {
        self.tappedBlock();
    }
}



@end
