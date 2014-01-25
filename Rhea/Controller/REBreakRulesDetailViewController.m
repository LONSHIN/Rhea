//
//  REBreakRulesDetailViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-3.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REBreakRulesDetailViewController.h"
#import "REBreakRulesInfo.h"
#import "RELibraryAPI.h"
#import "RERecallDetailViewController.h"
#import "REAddCarViewController.h"
#import "REDetailCell.h"
#import "REDetailHeaderView.h"


#define kTagOfEmptyView          119


@interface REBreakRulesDetailViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *breakRulesList;
@property (nonatomic, strong) RECar *car;

@end


@implementation REBreakRulesDetailViewController

- (id)initWithCar:(RECar *)car
{
    if (self = [super init]) {
        self.car = car;
    }
    return self;
}


- (RECar *)car
{
    if (_car == nil) {
        _car = [[RECar alloc] init];
    }
    return _car;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configTableView];
    [self getBreakRulesData];
}


- (void)updateWithCar:(RECar *)car
{
    self.car = car;
    [self getBreakRulesData];
}


- (void)getBreakRulesData
{
    __weak REBreakRulesDetailViewController *weakSelf = self;
    [SVProgressHUD show];
    
    [RELibraryAPI getBreakRulesInfoWithCar:self.car succeededBlock:^(NSArray *breakRulesList) {
        [SVProgressHUD dismiss];
        weakSelf.breakRulesList = breakRulesList;
        weakSelf.car.breakRulesCount = breakRulesList.count;
        [RELibraryAPI updateCar:weakSelf.car];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil];
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, kScreenIs4InchRetina?454.0f:366.0f)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.breakRulesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    REDetailCell *cell = (REDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = [indexPath row];
    REBreakRulesInfo *breakRulesInfo = [self.breakRulesList objectAtIndex:row];
    [cell updateWithBreakRulesInfo:breakRulesInfo recordIndex:row + 1];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    REBreakRulesInfo *breakRulesInfo = [self.breakRulesList objectAtIndex:indexPath.row];
    return [REDetailCell heightWithBreakRulesInfo:breakRulesInfo];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    REDetailHeaderView *headerView = [[REDetailHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f) title:@"您输入的车牌号" detail:self.car.licensePlateNumber recordCount:[NSString stringWithFormat:@"%d", self.car.breakRulesCount]];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}


@end
