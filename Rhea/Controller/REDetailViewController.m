//
//  REDetailViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-9.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REDetailViewController.h"
#import "RERecallDetailViewController.h"
#import "REBreakRulesDetailViewController.h"

#define kTagOfButtonBasic     345


@interface REDetailViewController ()

@property (nonatomic, strong) RECar *car;
@property (nonatomic, strong) UIView *currentShowView;

@end



@implementation REDetailViewController

- (id)initWithCar:(RECar *)car
{
    if (self = [super init]) {
        self.car = car;
    }
    return self;
}


- (void)viewDidLoad
{    
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    [self configChildViewControllers];
    [self configSwitchButton];
}


- (void)configChildViewControllers
{
    REBreakRulesDetailViewController *breakRulesVC = [[REBreakRulesDetailViewController alloc] initWithCar:self.car];
    [self addChildViewController:breakRulesVC];
}


- (void)configSwitchButton
{
    NSArray *buttonTitleArray = @[@"违章", @"召回"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithText:buttonTitleArray[i]
                                                         font:[UIFont systemFontOfSize:14.0f]
                                                    textColor:[UIColor randomColor]
                                             highlightedColor:[UIColor randomColor]
                                                       target:self
                                                       action:@selector(handleButtonTapped:)];
        button.frame = CGRectMake(0.0f + 160 * i, self.view.height - 64.0f - 35.0f, 160.0f, 35.0f);
        button.tag = kTagOfButtonBasic + i;
        
        if (i == 0) {
            [self handleButtonTapped:button];
        }
        
        //[self.view addSubview:button];
    }
}


#pragma mark - Button Action

- (void)handleButtonTapped:(UIButton *)sender
{
    [self.currentShowView removeFromSuperview];
    
    NSInteger index = sender.tag - kTagOfButtonBasic;
    UIView *tempView = [[self.childViewControllers objectAtIndex:index] view];
    tempView.frame = CGRectMake(0.0f, 0.0f, self.view.width, self.view.height);
    self.currentShowView = tempView;
    [self.view addSubview:tempView];
    [self.view sendSubviewToBack:tempView];
}


@end
