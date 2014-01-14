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
#import "REInputCell.h"
#import "RELibraryAPI.h"
#import "RESelectCarTypeViewController.h"


@interface REAddCarViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RECar *currentEditCar;

@end



@implementation REAddCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加车辆";
    [self configTableView];
    self.currentEditCar = [[RECar alloc] init];
    [self configRightBarButton];
}


- (void)configTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


- (void)configRightBarButton
{
    UIButton *button = [UIButton buttonWithText:@"添加"
                                           font:[UIFont systemFontOfSize:12.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleAddCarButtonTapped:)];
    button.backgroundColor = [UIColor colorWithHexString:@"5480c6"];
    button.frame = CGRectMake(0.0f, 0.0f, button.width , 25.0f);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (NSArray *)textFieldPlacehoderArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"完整七位车牌号"];
    RECity *city = self.currentEditCar.city;
    
    if (city.needVinCode) {
        NSString *str = city.vinCodeNumber == 0 ? @"完整车架号" : [NSString stringWithFormat:@"车架号后%d位", city.vinCodeNumber];
        [array addObject:str];
    }else{
        [array addObject:@"可不填"];
    }
    
    if (city.needEngineCode) {
        NSString *str = city.engineCodeNumber == 0 ? @"完整发动机号" : [NSString stringWithFormat:@"发动机号后%d位", city.engineCodeNumber];
        [array addObject:str];
    }else{
        [array addObject:@"可不填"];
    }
    
    if (city.needRegistCode) {
        NSString *str = city.registCodeNumber == 0 ? @"完整登记证书号" : [NSString stringWithFormat:@"登记证书号后%d位", city.registCodeNumber];
        [array addObject:str];
    }else{
        [array addObject:@"可不填"];
    }
    
    return array;
}


#pragma mark - Button Action

- (void)handleAddCarButtonTapped:(id)sender
{
    RECity *city = self.currentEditCar.city;
    
    for (NSInteger i = 1; i < 5; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        REInputCell *cell = (REInputCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (i == 1) {
            self.currentEditCar.licensePlateNumber = cell.textField.text;
        }else if (i == 2) {
            self.currentEditCar.vinCode = cell.textField.text;
        }else if (i == 3) {
            self.currentEditCar.engineCode = cell.textField.text;
        }else if (i == 4) {
            self.currentEditCar.registCode = cell.textField.text;
        }
    }
    
    if (self.currentEditCar.licensePlateNumber.length != 7) {
        [SVProgressHUD showImage:nil status:@"请输入正确车牌号"];
        return;
    }
    
    if (city.needVinCode && self.currentEditCar.vinCode.length < city.vinCodeNumber) {
        [SVProgressHUD showImage:nil status:@"请输入正确车架号"];
        return;
    }
    
    if (city.needEngineCode && ([self.currentEditCar.engineCode isEqualToString:@""] || self.currentEditCar.engineCode == nil)) {
        [SVProgressHUD showImage:nil status:@"请输入正确发动机号"];
        return;
    }
    
    if (city.needRegistCode && ([self.currentEditCar.registCode isEqualToString:@""] || self.currentEditCar.registCode == nil)) {
        [SVProgressHUD showImage:nil status:@"请输入正确登记证书号"];
        return;
    }
    
    [RELibraryAPI saveCar:self.currentEditCar];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITabelViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    REInputCell *cell = (REInputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REInputCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        NSMutableAttributedString *attributiString = [[NSMutableAttributedString alloc] initWithString:@"查询地："];
        cell.textLabel.attributedText = attributiString;
        cell.detailTextLabel.text = self.currentEditCar.city.name;
    }else if (row == 5) {
        cell.textLabel.text = @"车辆种类：";
        cell.detailTextLabel.text = self.currentEditCar.carType.name;
    }else {
        NSArray *titleArray = @[@"车牌号：", @"车架号：", @"发动机号：", @"登记证书号："];
        NSArray *contentArray = @[self.currentEditCar.licensePlateNumber == nil ? @"" : self.currentEditCar.licensePlateNumber, self.currentEditCar.vinCode == nil ? @"" : self.currentEditCar.vinCode, self.currentEditCar.engineCode == nil ? @"" : self.currentEditCar.engineCode, self.currentEditCar.registCode == nil ? @"" : self.currentEditCar.registCode];
        NSArray *placehoderArray = [self textFieldPlacehoderArray];
        [cell updateTextFieldWithText:contentArray[row - 1] placeholder:placehoderArray[row - 1]];
        cell.textLabel.text = titleArray[row - 1];
        __weak REAddCarViewController *weakSelf = self;
        __weak REInputCell *weakCell = cell;
        cell.returnKeyTappedBlcok = ^{
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:row + 1 inSection:indexPath.section];
            [weakSelf.tableView selectRowAtIndexPath:nextIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:nextIndexPath];
        };
        cell.deselectedBlock = ^{
            if (row == 1) {
                weakSelf.currentEditCar.licensePlateNumber = weakCell.textField.text;
            }else if (row == 2) {
                weakSelf.currentEditCar.vinCode = weakCell.textField.text;
            }else if (row == 3) {
                weakSelf.currentEditCar.engineCode = weakCell.textField.text;
            }else if (row == 4) {
                weakSelf.currentEditCar.registCode = weakCell.textField.text;
            }
        };
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row == 0) {
        __weak REAddCarViewController *weakSelf = self;
        RECityListViewController *cityListVC = [[RECityListViewController alloc] initWithSelectCityBlcok:^(RECity *selectCity) {
            weakSelf.currentEditCar.city = selectCity;
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:cityListVC animated:YES];
    }else if (row == 5) {
        [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
        __weak REAddCarViewController *weakSelf = self;
        RESelectCarTypeViewController *selectCarTypeVC = [[RESelectCarTypeViewController alloc] initWithSelectBlock:^(RECarType *selectedCarType) {
            weakSelf.currentEditCar.carType = selectedCarType;
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:selectCarTypeVC animated:YES];
    }else {
        [self.tableView setContentOffset:CGPointMake(0.0f, (indexPath.row - 1) * 44.0f) animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
