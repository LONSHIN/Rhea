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
#import "REBanner.h"
#import "REWebViewController.h"
#import "REMoreViewController.h"
#import "REDetailListViewController.h"
#import "RERecallDetailViewController.h"


@interface REHomePageViewController ()
<UITableViewDataSource, UITableViewDelegate, CNSBannerViewDataSource, CNSBannerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CNSBannerView *bannerView;
@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray *carList;

@end



@implementation REHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *logoView = [UIImageView imageViewWithImageName:@"home_page_logo"];
    self.navigationItem.titleView = logoView;
    
    [self configTableView];
    [self configBannerView];
    [self configLeftBarButton];
    [self configRightBarButton];
    [self getCarData];
    [self getBannerData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCarSavedNotification) name:kNotificationCarListChanged object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - View Layout

- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}


- (void)configBannerView
{
    self.bannerView = [[CNSBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 155.0f) bannerViewDataSource:self bannerViewDelegate:self];
    [self.bannerView reloadView];
    self.tableView.tableHeaderView = self.bannerView;
}


- (void)configLeftBarButton
{
    UIButton *moreButton = [UIButton buttonWithImageName:@"item_more_normal"
                                    highlightedImageName:nil
                                                   title:@""
                                                  target:self
                                                  action:@selector(handleMoreButtonTapped:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
}


- (void)configRightBarButton
{
    UIButton *button = [UIButton buttonWithText:@"召回查询"
                                           font:[UIFont systemFontOfSize:12.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleRecallButtonTapped:)];
    button.frame = CGRectMake(0.0f, 0.0, 58.0f, 25.0f);
    button.backgroundColor = [UIColor colorWithHexString:@"5480c6"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


#pragma mark - Get Data

- (void)getBannerData
{
    __weak REHomePageViewController *weakSelf = self;
    
    [RELibraryAPI getBannerWithSucceededBlock:^(NSArray *bannerList) {
        weakSelf.bannerList = bannerList;
        [weakSelf.bannerView reloadView];
    } failedBlock:^(NSError *error) {
        
    }];
}


- (void)getCarData
{
    self.carList = [RELibraryAPI getAllSavedCar];
    [self.tableView reloadData];
}


#pragma mark - Action

- (void)handleMoreButtonTapped:(UIButton *)sender
{
    REMoreViewController *moreVC = [[REMoreViewController alloc] init];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:moreVC];
    [self presentViewController:navc animated:YES completion:nil];
}


- (void)handleRecallButtonTapped:(UIButton *)sender
{
    RERecallDetailViewController *recallDetailVC = [[RERecallDetailViewController alloc] init];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:recallDetailVC];
    [self presentViewController:navc animated:YES completion:nil];
}


- (void)handleCarSavedNotification
{
    [self getCarData];
}


#pragma mark - CNSBannerViewDataSource

- (NSInteger)numberOfPagesInBannerView:(CNSBannerView *)bannerView
{
    return self.bannerList.count;
}


- (UIView *)bannerView:(CNSBannerView *)bannerView viewForPageAtIndex:(NSInteger)index
{
    REBanner *banner = [self.bannerList objectAtIndex:index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bannerView.width, bannerView.height)];
    [imageView setImageWithURL:[NSURL URLWithString:banner.imageUrl] placeholderImage:[UIImage imageNamed:@"banner_image_place_holder"]];
    return imageView;
}


- (UIImageView *)displayPlaceHolderImageViewInBannerView:(CNSBannerView *)bannerView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bannerView.width, bannerView.height)];
    imageView.image = [UIImage imageNamed:@"banner_place_holder"];
    return imageView;
}


#pragma mark - CNSBannerViewDelegate

- (void)bannerView:(CNSBannerView *)bannerView didSelectPageAtIndex:(NSInteger)index
{
    REBanner *banner = [self.bannerList objectAtIndex:index];
    REWebViewController *webVC = [[REWebViewController alloc] initWithUrlString:banner.jumpLink];
    webVC.title = banner.title;
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carList.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = [indexPath row];
    
    if (row == self.carList.count) {
        UIImageView *addBg = [UIImageView imageViewWithImageName:@"home_page_add_car_button_bg"];
        addBg.frame = CGRectMake(20.0f, 10.0f, 280.0f, 88.0);
        [cell.contentView addSubview:addBg];
    }else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        RECar *car = [self.carList objectAtIndex:indexPath.row];
        
        UIImageView *bg = [UIImageView imageViewWithImageName:@"home_page_plate_bg"];
        [cell.contentView addSubview:bg];
        bg.frame = CGRectMake(20.0f, 10.0f, 280.0f, 88.0);
        [cell.contentView addSubview:bg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, bg.width, bg.height)];
        label.font = [UIFont boldSystemFontOfSize:30.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [bg addSubview:label];
        label.text = car.licensePlateNumber;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    if (row == self.carList.count) {
        REAddCarViewController *addCarVC = [[REAddCarViewController alloc] init];
        RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:addCarVC];
        [self presentViewController:navc animated:YES completion:nil];
    }else {
        RECar *car = [self.carList objectAtIndex:indexPath.row];
        
        REDetailListViewController *detailListVC = [[REDetailListViewController alloc] init];
        detailListVC.currentShowCar = car;
        [self.navigationController pushViewController:detailListVC animated:YES];
    }
}


@end
