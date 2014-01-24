//
//  REManageCarViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-14.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REManageCarViewController.h"
#import "RELibraryAPI.h"
#import "REAddCarViewController.h"
#import "RECarDeleteCell.h"


@interface REManageCarViewController ()
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *carList;
@property (nonatomic, strong) RECar *needDeleteCar;

@end



@implementation REManageCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车辆管理";
    [self configTableView];
    [self getCarData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCarSavedNotification) name:kNotificationCarListChanged object:nil];
    
    [self.view addSubview:self.tableView];
}


- (void)getCarData
{
    self.carList = [RELibraryAPI getAllSavedCar];
    [self.tableView reloadData];
}


- (void)handleCarSavedNotification
{
    [self getCarData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    RECarDeleteCell *cell = (RECarDeleteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[RECarDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = [indexPath row];
    [cell.contentView removeAllSubviews];
    if (row == self.carList.count) {
        cell.textLabel.text = @"+添加车辆";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        RECar *car = [self.carList objectAtIndex:indexPath.row];
        cell.textLabel.text = car.licensePlateNumber;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"VIN:%@", car.intactVinCode];
        [cell updateWithDeleteButton];
        
        __weak REManageCarViewController *weakSelf = self;
        cell.deleteButtonTappedBlock = ^(){
            weakSelf.needDeleteCar = car;
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确定删除该车？"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alterView show];
            alterView.delegate = self;
        };
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    if (row == self.carList.count) {
        REAddCarViewController *addCarVC = [[REAddCarViewController alloc] init];
        RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:addCarVC];
        [self presentViewController:navc animated:YES completion:nil];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [RELibraryAPI deleteCar:self.needDeleteCar];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil userInfo:@{kKeyNotificationNeedShowDetail: @(NO)}];
        [self.tableView reloadData];
    }
}

@end
