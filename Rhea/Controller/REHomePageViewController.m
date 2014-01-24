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
#import "REInputVinCodeViewController.h"
#import "REHomePageCell.h"


#define kTagOfHeaderTitle    675


@interface REHomePageViewController ()
<UITableViewDataSource, UITableViewDelegate,
CNSBannerViewDataSource, CNSBannerViewDelegate, REHomePageCellDelegate>

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
    
    [self configBackground];
    [self configTableView];
    [self configTableHeaderView];
    [self configLeftBarButton];
    [self configAddButton];
    [self getCarData];
    [self getBannerData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCarSavedNotification:) name:kNotificationCarListChanged object:nil];
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 140.0f)];
    self.tableView.tableFooterView = footerView;
}


- (void)configTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 162.0f)];
    self.bannerView = [[CNSBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 155.0f) bannerViewDataSource:self bannerViewDelegate:self];
    [headerView addSubview:self.bannerView];
    
    self.tableView.tableHeaderView = headerView;
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


- (void)configAddButton
{
    UIImageView *bg = [UIImageView imageViewWithImageName:@"homepage_add_car_bg"];
    bg.center = CGPointMake(160.0f, self.view.height - (kScreenIs4InchRetina?135.0f:125));
    [self.view addSubview:bg];
    bg.userInteractionEnabled = YES;
    
    UIButton *breakRulesButton = [UIButton buttonWithText:@"违章\n查询"
                                                     font:[UIFont systemFontOfSize:17.0f]
                                                textColor:[UIColor whiteColor]
                                         highlightedColor:[UIColor lightGrayColor]
                                                   target:self
                                                   action:@selector(handleBreakRulesButtonTapped:)];
    breakRulesButton.titleLabel.numberOfLines = 2;
    breakRulesButton.frame = CGRectMake(0.0f, 0.0f, 77.0f, bg.height); //CGPointMake(42.0f, 42.0f);
    [bg addSubview:breakRulesButton];
    
    UIButton *recallButton = [UIButton buttonWithText:@"召回\n查询"
                                                 font:[UIFont systemFontOfSize:17.0f]
                                            textColor:[UIColor whiteColor]
                                     highlightedColor:[UIColor lightGrayColor]
                                               target:self action:@selector(handleRecallButtonTapped:)];
    recallButton.titleLabel.numberOfLines = 2;
    recallButton.frame = CGRectMake(77.0f, 0.0f, 77.0f, bg.height);
    [bg addSubview:recallButton];
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
    [self presentInputVinCodeViewControllerWithCar:nil];
}


- (void)handleBreakRulesButtonTapped:(UIButton *)sender
{
    [self presentAddCarViewControllerWithCar:nil];
}


- (void)handleCarSavedNotification:(NSNotification *)sender
{
    [self getCarData];
}


#pragma mark - Inner Method

- (void)pushToDetailListViewControllerWithCar:(RECar *)car showType:(REDetailType)showType
{
    REDetailListViewController *detailListVC = [[REDetailListViewController alloc] initWithShowType:showType];
    detailListVC.currentShowCar = car;
    [self.navigationController pushViewController:detailListVC animated:YES];
}


- (void)presentAddCarViewControllerWithCar:(RECar *)car
{
    __weak REHomePageViewController *weakSelf = self;
    
    REAddCarViewController *addVC = [[REAddCarViewController alloc] initWithCar:nil succeededBlock:^(RECar *newCar) {
        [weakSelf pushToDetailListViewControllerWithCar:newCar showType:REDetailTypeBreakRules];
    }];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:navc animated:YES completion:nil];
}


- (void)presentInputVinCodeViewControllerWithCar:(RECar *)car
{
    __weak REHomePageViewController *weakSelf = self;
    
    REInputVinCodeViewController *inputVC = [[REInputVinCodeViewController alloc] initWithCar:car succeededBlock:^(RECar *newCar) {
        [weakSelf pushToDetailListViewControllerWithCar:newCar showType:REDetailTypeRecall];
    }];
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:inputVC];
    [self presentViewController:navc animated:YES completion:nil];
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
    if (self.carList.count > 0) {
        return self.carList.count + 1;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    REHomePageCell *cell = (REHomePageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.deleage = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = [indexPath row];
    
    [cell.contentView removeAllSubviews];
    if (row == 0) {
        UIImage *titleBg = [[UIImage imageNamed:@"section_title_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 4.0f, 0.0f, 4.0f)];
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 0.0f, 306, 35.0f)];
        titleView.image = titleBg;
        [cell.contentView addSubview:titleView];
        UILabel *titleLabel = [UILabel labelWithText:@"查询记录"
                                     backgroundColor:[UIColor clearColor]
                                           textColor:[UIColor whiteColor]
                                                font:[UIFont systemFontOfSize:14.0f]];
        titleLabel.center = CGPointMake(titleView.width / 2.0f, titleView.height / 2.0f);
        [titleView addSubview:titleLabel];
    }else {
        RECar *car = [self.carList objectAtIndex:row - 1];
        [cell updateWithCar:car needShowShadow:((row - 1) == self.carList.count - 1) ? YES : NO];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 30.0f;
    }else{
        return 74.0f;
    }
}


#pragma mark - REHomePageCellDelegate

- (void)selectedBreakRulesRowInHomePageCell:(REHomePageCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RECar *car = [self.carList objectAtIndex:(indexPath.row - 1)];
    if ([car.licensePlateNumber isEqualToString:@""]) {
        [self presentAddCarViewControllerWithCar:car];
    }else {
        [self pushToDetailListViewControllerWithCar:car showType:REDetailTypeBreakRules];
    }
}


- (void)selectedRecallRowInHomePageCell:(REHomePageCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RECar *car = [self.carList objectAtIndex:(indexPath.row - 1)];
    if ([car.intactVinCode isEqualToString:@""]) {
        [self presentInputVinCodeViewControllerWithCar:car];
    }else {
        [self pushToDetailListViewControllerWithCar:car showType:REDetailTypeRecall];
    }
}


@end
