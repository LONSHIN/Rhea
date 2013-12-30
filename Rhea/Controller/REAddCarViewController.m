//
//  REAddCarViewController.m
//  Rhea
//
//  Created by Tiger on 13-12-26.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REAddCarViewController.h"
#import "RECity.h"
#import "RECityListViewController.h"
#import "RECar.h"


@interface REAddCarViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RECar *currentEditCar;

@end



@implementation REAddCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configTableView];
    self.currentEditCar = [[RECar alloc] init];
}


- (void)configTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark - UITabelViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else {
        return 10;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        NSMutableAttributedString *attributiString = [[NSMutableAttributedString alloc] initWithString:@"查询地[必填]："];
        cell.textLabel.attributedText = attributiString;
        cell.detailTextLabel.text = self.currentEditCar.city.name;
    }else if (row == 1) {
        
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    if (row == 0) {
        __weak REAddCarViewController *weakSelf = self;
        RECityListViewController *cityListVC = [[RECityListViewController alloc] initWithSelectCityBlcok:^(RECity *selectCity) {
            weakSelf.currentEditCar.city = selectCity;
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:cityListVC animated:YES];
    }
}




@end
