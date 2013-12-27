//
//  REHomePageViewController.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REHomePageViewController.h"
#import "CNSBannerView.h"
#import "REAddCarViewController.h"
#import "RELibraryAPI.h"


@interface REHomePageViewController ()
<UITableViewDataSource, UITableViewDelegate, CNSBannerViewDataSource, CNSBannerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CNSBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSArray *carArray;

@end



@implementation REHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
    
    [self configTableView];
    [self configBannerView];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}


- (void)configBannerView
{
    self.bannerView = [[CNSBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 155.0f) bannerViewDataSource:self bannerViewDelegate:self];
    [self.bannerView reloadView];
    self.tableView.tableHeaderView = self.bannerView;
}


#pragma mark - CNSBannerViewDataSource

- (NSInteger)numberOfPagesInBannerView:(CNSBannerView *)bannerView
{
    return 2;
    //return self.bannerArray.count;
}


- (UIView *)bannerView:(CNSBannerView *)bannerView viewForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bannerView.width, bannerView.height)];
    imageView.backgroundColor = [UIColor randomColor];
    return imageView;
}


- (UIImageView *)displayPlaceHolderImageViewInBannerView:(CNSBannerView *)bannerView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bannerView.width, bannerView.height)];
    return imageView;
}


#pragma mark - CNSBannerViewDelegate

- (void)bannerView:(CNSBannerView *)bannerView didSelectPageAtIndex:(NSInteger)index
{
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    if (row == self.carArray.count) {
        cell.textLabel.text = @"加车";
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if (row == self.carArray.count) {
        REAddCarViewController *addCarVC = [[REAddCarViewController alloc] init];
        RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:addCarVC];
        [self presentViewController:navc animated:YES completion:nil];
    }
}


@end
