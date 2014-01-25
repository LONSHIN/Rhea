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
#import "RELibraryAPI.h"


#define kTagOfButtonBasic     345

@interface REDetailViewController ()

@property (nonatomic, assign) REDetailType type;
@property (nonatomic, strong) UIView *currentShowView;

@end



@implementation REDetailViewController

- (id)initWithCar:(RECar *)car showType:(REDetailType)type
{
    if (self = [super init]) {
        self.car = car;
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    [self configChildViewControllers];
    [self configSwitchButton];
    [self switchToViewWithShowType:self.type];
}


- (void)reloadBreakRulesDataWithCar:(RECar *)car
{
    self.car = car;
    
    REBreakRulesDetailViewController *breakRulesVC = [self.childViewControllers objectAtIndex:REDetailTypeBreakRules];
    [breakRulesVC updateWithCar:car];
}


- (void)reloadRecallDataWithCar:(RECar *)car
{
    self.car = car;
    
    RERecallDetailViewController *recallVC = [self.childViewControllers objectAtIndex:REDetailTypeRecall];
    [recallVC updateWithCar:car];
}


- (void)setCurrentShowType:(REDetailType)currentShowType
{
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:kTagOfButtonBasic +  _currentShowType];
    NSArray *normalImageNames = @[@"detail_break_rules_normal", @"detail_recall_normal"];
    [oldButton setBackgroundImage:[UIImage imageNamed:normalImageNames[_currentShowType]] forState:UIControlStateNormal];
    [oldButton setBackgroundImage:[UIImage imageNamed:normalImageNames[_currentShowType]] forState:UIControlStateHighlighted];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:kTagOfButtonBasic + currentShowType];
    NSArray *highlightedImageNames = @[@"detail_break_rules_highlighted", @"detail_recall_highlighted"];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImageNames[currentShowType]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImageNames[currentShowType]] forState:UIControlStateHighlighted];
    
    _currentShowType = currentShowType;
}


- (void)configChildViewControllers
{
    REBreakRulesDetailViewController *breakRulesVC = [[REBreakRulesDetailViewController alloc] initWithCar:self.car];
    [self addChildViewController:breakRulesVC];
    
    RERecallDetailViewController *recallVC = [[RERecallDetailViewController alloc] initWithCar:self.car];
    [self addChildViewController:recallVC];
}


- (void)configSwitchButton
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kScreenIs4InchRetina?454.0f:366.0f, 320.0f, 50.0f)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bgView.width, 0.5f)];
    line.backgroundColor = [UIColor colorWithHexString:@"afafaf"];
    [bgView addSubview:line];
    
    NSArray *imageNames = @[@"detail_break_rules_normal", @"detail_recall_normal"];
    for (NSInteger i = 0; i < 2; i ++) {

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f + 160 * i, 0.0f, 160.0f, 50.0f)];
        [button addTarget:self action:@selector(handleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateHighlighted];
        button.tag = kTagOfButtonBasic + i;
        
        [bgView addSubview:button];
    }
    
    [self.view addSubview:bgView];
}


- (void)switchToViewWithShowType:(REDetailType)type
{
    NSInteger index = (NSInteger)type;
    
    if (index > self.childViewControllers.count) {
        return;
    }

    [self.currentShowView removeFromSuperview];

    UIView *tempView = [[self.childViewControllers objectAtIndex:index] view];
    tempView.frame = CGRectMake(0.0f, 0.0f, self.view.width, self.view.height);
    self.currentShowView = tempView;
    [self.view addSubview:tempView];
    [self.view sendSubviewToBack:tempView];
    
    self.currentShowType = type;
}


#pragma mark - Button Action

- (void)handleButtonTapped:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagOfButtonBasic;
    
    if ([self.delegate respondsToSelector:@selector(detailViewController:needChangeToShowType:)]) {
        [self.delegate detailViewController:self needChangeToShowType:index];
    }
}


@end
