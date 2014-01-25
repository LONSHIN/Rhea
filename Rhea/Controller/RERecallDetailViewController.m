//
//  RERecallDetailViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-3.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "RERecallDetailViewController.h"
#import "RELibraryAPI.h"
#import "RERecallInfo.h"
#import "REDetailCell.h"
#import "REDetailHeaderView.h"

#define kTagOfEmptyView          134


@interface RERecallDetailViewController ()
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *recallList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) RECar *car;

@end



@implementation RERecallDetailViewController

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
    self.title = @"召回查询";
    [self getRecallInfo];
}


- (void)updateWithCar:(RECar *)car
{
    self.car = car;
    [self getRecallInfo];
}


- (void)getRecallInfo
{
    [SVProgressHUD show];
    
    __weak RERecallDetailViewController *weakSelf = self;
    
    [RELibraryAPI  getRecallInfoWithVinCode:self.car.intactVinCode succeededBlock:^(NSArray *recallInfo, NSDictionary *carInfo) {
        [weakSelf.car updateWithCarInfo:carInfo];
        weakSelf.car.recallCount = recallInfo.count;
        [RELibraryAPI updateCar:weakSelf.car];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil];
        weakSelf.recallList = recallInfo;
        [weakSelf.tableView reloadData];
        [SVProgressHUD dismiss];
    } failedBlock:^(NSError *error) {
        weakSelf.recallList = nil;
        [weakSelf.car clearCarInfo];
        [RELibraryAPI updateCar:weakSelf.car];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil];
        [weakSelf.tableView reloadData];
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
     return self.recallList.count;
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
    RERecallInfo *recallInfo = [self.recallList objectAtIndex:row];
    [cell updateWithRecallInfo:recallInfo recordIndex:row + 1];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RERecallInfo *recallInfo = [self.recallList objectAtIndex:indexPath.row];
    return [REDetailCell heightWithRecallInfo:recallInfo];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    REDetailHeaderView *headerView = [[REDetailHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f) title:@"您输入的车辆VIN码" detail:self.car.intactVinCode recordCount:[NSString stringWithFormat:@"%d", self.car.recallCount]];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

@end
