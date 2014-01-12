//
//  RECityListViewController.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "RECityListViewController.h"
#import "RELibraryAPI.h"
#import "RECityListCell.h"
#import "RECityListSectionHeaderView.h"


@interface RECityListViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *citys;
@property (nonatomic, assign) NSInteger currentOpenedSectionIndex;
@property (nonatomic, strong) RECityListSelectCityBlock selectCityBlock;

@end



@implementation RECityListViewController

- (id)initWithSelectCityBlcok:(RECityListSelectCityBlock)selectCityBlcok
{
    if (self = [super init]) {
        self.selectCityBlock = selectCityBlcok;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentOpenedSectionIndex = NSNotFound;
    self.title = @"城市选择";
    [self configTableView];
    [self loadAllCitys];
}


- (void)loadAllCitys
{
    __weak RECityListViewController *weakSelf = self;
    [SVProgressHUD show];
    [RELibraryAPI getCitysWithSuccesseedBlock:^(NSArray *citys) {
        weakSelf.citys = citys;
        [weakSelf.tableView reloadData];
        [SVProgressHUD dismiss];
    } failedBlock:^(NSError *error) {
        
    }];
}


- (void)dealloc
{
    
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.citys.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.currentOpenedSectionIndex) {
        return 1;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RECityListSectionHeaderView *headerView = [[RECityListSectionHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
    
    headerView.textLabel.text = [[self.citys objectAtIndex:section] objectForKey:kKeyCitysProvince];
    __weak RECityListViewController *weakSelf = self;
    headerView.tappedBlock = ^{
        if (weakSelf.currentOpenedSectionIndex == section) {
            [weakSelf closeSection:section];
        }else {
            [weakSelf openSection:section];
        }
    };
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    RECityListCell *cell = (RECityListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[RECityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *provinceCitys = [[self.citys objectAtIndex:indexPath.section] objectForKey:kKeyCitysProvinceCity];
    [cell layoutWithSection:indexPath.section citys:provinceCitys];
    
    __weak RECityListViewController *weakSelf = self;
    cell.tappedItemBlock = ^(NSInteger index){
        if (weakSelf.selectCityBlock != nil) {
            RECity *city = [provinceCitys objectAtIndex:index];
            weakSelf.selectCityBlock(city);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *provinceCitys = [[self.citys objectAtIndex:indexPath.section] objectForKey:kKeyCitysProvinceCity];
    return [RECityListCell heightForCitys:provinceCitys];
}


#pragma mark - 

- (void)openSection:(NSInteger)openSection
{
    NSInteger lastOpenedIndex = self.currentOpenedSectionIndex;
    self.currentOpenedSectionIndex = openSection;
    NSArray *insertIndexPath = @[[NSIndexPath indexPathForRow:0 inSection:openSection]];
    NSArray *deleteIndexPath;
    if (lastOpenedIndex != NSNotFound) {
        deleteIndexPath = @[[NSIndexPath indexPathForRow:0 inSection:lastOpenedIndex]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    if (lastOpenedIndex != NSNotFound) {
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
}


- (void)closeSection:(NSInteger)closeSection
{
    self.currentOpenedSectionIndex = NSNotFound;
    
    NSArray *deleteIndexPath = @[[NSIndexPath indexPathForRow:0 inSection:closeSection]];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
