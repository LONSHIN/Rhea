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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
    [self getBreakRulesData];
}


- (void)getBreakRulesData
{
    __weak REBreakRulesDetailViewController *weakSelf = self;
    [SVProgressHUD show];
    
    [RELibraryAPI getBreakRulesInfoWithCar:self.car succeededBlock:^(NSArray *breakRulesList) {
        [SVProgressHUD dismiss];
        weakSelf.breakRulesList = breakRulesList;
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, kScreenIs4InchRetina ? (568.0f - (kSystemVersionPriorToIOS7 ? 44.0f : 64.0f) - 35.0f) : (480.0f - (kSystemVersionPriorToIOS7 ? 44.0f : 64.0f) - 35.0f)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.breakRulesList.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = [indexPath row];
    REBreakRulesInfo *breakRulesInfo = [self.breakRulesList objectAtIndex:indexPath.section];
    
    NSArray *titleArray = @[@"违章时间", @"违章地点", @"违章⾏行为", @"违章代码(仅供参考)", @"违章扣分(仅供参考)", @"违章罚款(仅供参考)"];
    NSArray *contentArray = @[breakRulesInfo.time, breakRulesInfo.place, breakRulesInfo.problem, breakRulesInfo.code, breakRulesInfo.demeritPoints, breakRulesInfo.money];
    cell.textLabel.text = titleArray[row];
    cell.detailTextLabel.text = contentArray[row];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    REBreakRulesInfo *breakRulesInfo = [self.breakRulesList objectAtIndex:indexPath.section];
    
    NSArray *contentArray = @[breakRulesInfo.time, breakRulesInfo.place, breakRulesInfo.problem, breakRulesInfo.code, breakRulesInfo.demeritPoints, breakRulesInfo.money];

    CGSize size = [contentArray[row] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, MAXFLOAT)];
    
    return size.height + 50.0f;
}

@end
