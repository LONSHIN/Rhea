//
//  REDetailShellViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REDetailListViewController.h"
#import "APOSwitchPageView.h"
#import "RELibraryAPI.h"
#import "REAddCarViewController.h"
#import "REInputVinCodeViewController.h"


@interface REDetailListViewController ()
<APOSwitchPageViewDataSource, APOSwitchPageViewDelegate,
REDetailViewControllerDelegate>

@property (nonatomic, strong) APOSwitchPageView *switchPageView;
@property (nonatomic, strong) NSArray *carList;

@property (nonatomic, assign) REDetailType type;

@end


@implementation REDetailListViewController

- (id)initWithShowType:(REDetailType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configBackground];
    
    self.carList = [RELibraryAPI getAllSavedCar];
    [self configChildViewController];
    [self configSwitchPageView];
    [self confitRightBarButton];
}


- (void)confitRightBarButton
{
    UIButton *editButton = [UIButton buttonWithText:@"编辑"
                                           font:[UIFont systemFontOfSize:13.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleEditButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
}


- (void)configSwitchPageView
{
    APOSwitchPageView *switchPageView = [[APOSwitchPageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0, self.view.height)];
    switchPageView.delegate = self;
    switchPageView.dataSource = self;
    switchPageView.pageCount = [RELibraryAPI carCount];
    self.switchPageView = switchPageView;
    [self.view addSubview:switchPageView];
    [self scrollToCurrentCarView];
}


- (void)configChildViewController
{
    for (RECar *car in self.carList) {
        REDetailViewController *detailVC = [[REDetailViewController alloc] initWithCar:car showType:self.type];
        detailVC.delegate = self;
        [self addChildViewController:detailVC];
    }
}


- (void)scrollToCurrentCarView
{
    if (self.currentShowCar ==nil) {
        return;
    }
    
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.carList.count; i++) {
        RECar *inListCar = [self.carList objectAtIndex:i];
        if (self.type == REDetailTypeBreakRules) {
            if ([inListCar.licensePlateNumber isEqualToString:_currentShowCar.licensePlateNumber]) {
                index = i;
            }
        }else if (self.type == REDetailTypeRecall) {
            if ([inListCar.intactVinCode isEqualToString:_currentShowCar.intactVinCode]) {
                index = i;
            }
        }
    }
    
    [self.switchPageView scrollToPageIndex:index animated:NO];
}


#pragma mark - Button Action

- (void)handleEditButtonTapped:(UIButton *)sender
{
    NSInteger index = self.switchPageView.currentPageIndex;
    REDetailViewController *detailVC = [self.childViewControllers objectAtIndex:index];
    REDetailType type = [detailVC currentShowType];
    [self improveDataIfNeedWithShowType:type index:index editMode:YES];
}


#pragma mark - APOSwitchPageViewDataSource

- (UIView *)pageView:(APOSwitchPageView *)switchPageView contentViewForPageIndex:(NSInteger)index
{
    UIView *tempView = [[self.childViewControllers objectAtIndex:index] view];
    return tempView;
}


#pragma mark - APOSwitchPageViewDelegate

- (void)pageView:(APOSwitchPageView *)switchPageView didScrollToPageIndex:(NSInteger)index
{
    self.title = [[self.carList objectAtIndex:index] licensePlateNumber];
}


#pragma mark - REDetailViewControllerDelegate

- (void)detailViewController:(REDetailViewController *)detailViewController needChangeToShowType:(REDetailType)type
{
    NSInteger index = NSNotFound;
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i ++) {
        REDetailViewController *vcInList = [self.childViewControllers objectAtIndex:i];
        if (vcInList == detailViewController) {
            index = i; break;
        }
    }
    [self improveDataIfNeedWithShowType:type index:index editMode:NO];
}


- (void)improveDataIfNeedWithShowType:(REDetailType)type index:(NSInteger)index editMode:(BOOL)editMode
{
    if (index != NSNotFound) {
        if (type == REDetailTypeBreakRules) {
            [self handleToShowBreakRulesWithIndex:index editMode:editMode];
        }else if (type == REDetailTypeRecall) {
            [self handleToShowRecallDetailWithIndex:index editMode:editMode];
        }
    }
}


- (void)handleToShowRecallDetailWithIndex:(NSInteger)index editMode:(BOOL)editMode
{
    RECar *car = self.carList[index];
    REDetailViewController *detailVC = [self.childViewControllers objectAtIndex:index];
    
    if (editMode) {
        [self presentInputVinCodeViewControllerWithIndex:index];
    }else {
        if ([car.intactVinCode isEqualToString:@""]) {
            [self presentInputVinCodeViewControllerWithIndex:index];
        }else{
            [detailVC switchToViewWithShowType:REDetailTypeRecall];
        }
    }
}


- (void)handleToShowBreakRulesWithIndex:(NSInteger)index editMode:(BOOL)editMode
{
    RECar *car = self.carList[index];
    REDetailViewController *detailVC = [self.childViewControllers objectAtIndex:index];

    if (editMode) {
        [self presentAddCarViewControllerWithIndex:index];
    }else {
        if ([car.licensePlateNumber isEqualToString:@""]) {
            [self presentAddCarViewControllerWithIndex:index];
        }else {
            [detailVC switchToViewWithShowType:REDetailTypeBreakRules];
        }
    }
}


- (void)presentAddCarViewControllerWithIndex:(NSInteger)index
{
    RECar *car = self.carList[index];
    REDetailViewController *detailVC = [self.childViewControllers objectAtIndex:index];
    
    REAddCarViewController *addVC = [[REAddCarViewController alloc] initWithCar:car succeededBlock:^(id newCar) {
        [car updateWithCar:newCar];
        [detailVC switchToViewWithShowType:REDetailTypeBreakRules];
        [detailVC reloadBreakRulesDataWithCar:newCar];
    }];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:navc animated:YES completion:nil];
}


- (void)presentInputVinCodeViewControllerWithIndex:(NSInteger)index
{
    RECar *car = self.carList[index];
    REDetailViewController *detailVC = [self.childViewControllers objectAtIndex:index];
    
    REInputVinCodeViewController *vinVC = [[REInputVinCodeViewController alloc] initWithCar:car succeededBlock:^(id newCar) {
        [car updateWithCar:newCar];
        [detailVC switchToViewWithShowType:REDetailTypeRecall];
        [detailVC reloadRecallDataWithCar:newCar];
    }];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:vinVC];
    [self presentViewController:navc animated:YES completion:nil];
}


@end
