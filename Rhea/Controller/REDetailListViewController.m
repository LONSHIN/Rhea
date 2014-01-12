//
//  REDetailShellViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REDetailListViewController.h"
#import "REDetailViewController.h"
#import "APOSwitchPageView.h"
#import "RELibraryAPI.h"


@interface REDetailListViewController ()
<APOSwitchPageViewDataSource, APOSwitchPageViewDelegate>

@property (nonatomic, strong) APOSwitchPageView *switchPageView;
@property (nonatomic, strong) NSArray *carList;

@end


@implementation REDetailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.carList = [RELibraryAPI getAllSavedCar];
    [self configChildViewController];
    [self configSwitchPageView];
}


- (void)configSwitchPageView
{
    APOSwitchPageView *switchPageView = [[APOSwitchPageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0, self.view.height - 64.0f)];
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
        REDetailViewController *detailVC = [[REDetailViewController alloc] initWithCar:car];
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
        if ([inListCar.licensePlateNumber isEqualToString:_currentShowCar.licensePlateNumber]) {
            index = i;
        }
    }
    
    [self.switchPageView scrollToPageIndex:index animated:NO];
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

@end
