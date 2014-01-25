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
#import "REInputCell.h"
#import "RELibraryAPI.h"
#import "RESelectCarTypeViewController.h"
#import "DAKeyboardControl.h"
#import "REAbbreviationListViewController.h"
#import "REExampleView.h"


@interface REAddCarViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RECar *currentEditCar;
@property (nonatomic, strong) REAddCarSucceededBlcok succeededBlock;

@property (nonatomic, assign) REUpdateCarListType updateCarListType;

@end



@implementation REAddCarViewController


- (id)initWithCar:(RECar *)car succeededBlock:(REAddCarSucceededBlcok)succeededBlock
{
    if (self = [super init]) {
        self.currentEditCar = car;
        self.updateCarListType = REUpdateCarListTypeUpdateExistCar;
        if (self.currentEditCar == nil) {
            self.updateCarListType = REUpdateCarListTypeSaveNewCar;
            self.currentEditCar = [[RECar alloc] init];
        }
        
        NSString *intactVin = self.currentEditCar.intactVinCode;
        if (![intactVin isEqualToString:@""] && [self.currentEditCar.licensePlateNumber isEqualToString:@""]) {
            NSInteger codeLength = self.currentEditCar.city.vinCodeNumber;
            self.currentEditCar.vinCode = [intactVin substringFromIndex:intactVin.length - codeLength];
        }
        if ([self.currentEditCar.licensePlateNumber isEqualToString:@""]) {
            self.currentEditCar.licensePlateNumber = self.currentEditCar.city.abbreviation;
        }

        self.succeededBlock = succeededBlock;
    }
    return self;
}


- (void)dealloc
{
    [self.view removeKeyboardControl];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.updateCarListType == REUpdateCarListTypeSaveNewCar ? @"添加车辆" : @"修改车辆";
    [self configBackground];
    [self configTableView];
    [self configRightBarButton];
}


- (void)configTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self configTableHeaderFooterView];
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = keyboardFrameInView.origin.y;
        tableView.frame = tableViewFrame;
    }];
}


- (void)configTableHeaderFooterView
{
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, 320.0f, 8.0f)];
    self.tableView.tableHeaderView = blankView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 68.0f)];
    
    UIImageView *captionBgView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 7.0f, 306.0f, 48.0f)];
    captionBgView.image = [[UIImage imageNamed:@"add_car_caption_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 3.0f, 10.0f)];
    [footerView addSubview:captionBgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 13.0f, 292.0f, 30.0f)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = @"以上车辆信息仅用于您的车辆违章查询，您的车辆信息将严格保密，请放心使用。";
    [captionBgView addSubview:label];
    
    UIButton *button = [UIButton buttonWithText:@"违章查询"
                                           font:[UIFont systemFontOfSize:17.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleAddCarButtonTapped:)];
    [button setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 3.0f, 2.0f, 3.0f)] forState:UIControlStateNormal];
    button.frame = CGRectMake(84.0f, self.tableView.height - (kScreenIs4InchRetina ? 165.0f : 130.0f), 150.0f, 40.0f);
    [self.view addSubview:button];
    
    self.tableView.tableFooterView = footerView;
}


- (void)configRightBarButton
{
    UIButton *button = [UIButton buttonWithText:@"查询"
                                           font:[UIFont systemFontOfSize:14.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleAddCarButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (NSArray *)textFieldPlacehoderArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"请输入车牌号"];
    RECity *city = self.currentEditCar.city;
    
    if (city.needVinCode) {
        NSString *str = city.vinCodeNumber == 0 ? @"请输入车架号(VIN)" : [NSString stringWithFormat:@"请输入车架号(VIN)后%d位", city.vinCodeNumber];
        [array addObject:str];
    }else{
        [array addObject:@"可不填"];
    }
    
    if (city.needEngineCode) {
        NSString *str = city.engineCodeNumber == 0 ? @"请输入发动机号" : [NSString stringWithFormat:@"请输入发动机号后%d位", city.engineCodeNumber];
        [array addObject:str];
    }else{
        [array addObject:@"可不填"];
    }
    
    if (city.needRegistCode) {
        NSString *str = city.registCodeNumber == 0 ? @"请输入登记证书号" : [NSString stringWithFormat:@"请输入登记证书号后%d位", city.registCodeNumber];
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
            self.currentEditCar.licensePlateNumber = [NSString stringWithFormat:@"%@%@",[self.currentEditCar.licensePlateNumber substringToIndex:1], cell.textField.text];
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
    
    if (self.updateCarListType == REUpdateCarListTypeSaveNewCar) {
        [RELibraryAPI saveCar:self.currentEditCar];
    }else if (self.updateCarListType == REUpdateCarListTypeUpdateExistCar) {
        [RELibraryAPI updateCar:self.currentEditCar];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil userInfo:@{kKeyNotificationNeedShowDetail: @(YES)}];
    if (self.succeededBlock != nil) {
        self.succeededBlock(self.currentEditCar);
    }
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
        cell = [[REInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    RECity *city = self.currentEditCar.city;
    
    if (row == 0) {
        [cell updateWithTitle:@"查询地" detail:self.currentEditCar.city.name upRounded:YES downRounded:NO];
    }else if (row == 5) {
        [cell updateWithTitle:@"车辆种类" detail:self.currentEditCar.carType.name upRounded:NO downRounded:YES];
    }else {
        if ((!city.needVinCode && row == 2) || (!city.needEngineCode && row == 3) || (!city.needRegistCode && row == 4)) {
            return cell;
        }
        
        NSArray *titleArray = @[@"车牌号",
                                city.vinCodeNumber == 0 ? @"车架号" : [NSString stringWithFormat:@"车架号后%d位",city.vinCodeNumber],
                                city.engineCodeNumber == 0 ? @"发动机号" : [NSString stringWithFormat:@"发动机号后%d位", city.engineCodeNumber],
                                city.registCodeNumber == 0 ? @"登记证书号" : [NSString stringWithFormat:@"登记证书号后%d位", city.registCodeNumber]];

        NSArray *contentArray = @[[self.currentEditCar.licensePlateNumber substringFromIndex:1],
                                  self.currentEditCar.vinCode,
                                  self.currentEditCar.engineCode,
                                  self.currentEditCar.registCode];
        NSArray *placehoderArray = [self textFieldPlacehoderArray];
        if (row == 1) {
            [cell updateWithTitle:titleArray[row - 1]
                     abbreviation:[self.currentEditCar.licensePlateNumber substringToIndex:1]
                    textFieldText:contentArray[row - 1]
                      placeholder:placehoderArray[row - 1]];
            
            __weak REAddCarViewController *weakSelf = self;
            cell.abbreviationViewTappedBlcok = ^(){
                [weakSelf selectAbbreviation];
            };
        }else {
            [cell updateWithTitle:titleArray[row - 1]
                    textFieldText:contentArray[row - 1]
                      placeholder:placehoderArray[row - 1]];
            
            __weak REAddCarViewController *weakSelf = self;
            cell.questionMarkTappedBlock = ^(){
                [weakSelf showExampleWithRow:row];
            };
        }
        
        __weak REAddCarViewController *weakSelf = self;
        __weak REInputCell *weakCell = cell;
        cell.returnKeyTappedBlcok = ^{
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:row + 1 inSection:indexPath.section];
            [weakSelf.tableView selectRowAtIndexPath:nextIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:nextIndexPath];
        };
        
        cell.deselectedBlock = ^{
            if (row == 1) {
                weakSelf.currentEditCar.licensePlateNumber = [NSString stringWithFormat:@"%@%@",[weakSelf.currentEditCar.licensePlateNumber substringToIndex:1], weakCell.textField.text];
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


- (void)selectAbbreviation
{
    __weak REAddCarViewController *weakSelf = self;
    REAbbreviationListViewController *vc = [[REAbbreviationListViewController alloc] initWithSelectBlock:^(NSString *abbreviation) {
        NSString *licenseNumber = weakSelf.currentEditCar.licensePlateNumber;
        weakSelf.currentEditCar.licensePlateNumber = [NSString stringWithFormat:@"%@%@", abbreviation, [licenseNumber substringFromIndex:1]];
        [weakSelf.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showExampleWithRow:(NSInteger)row
{
    [self.view hideKeyboard];
    
    REExampleView *view = [[REExampleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height) type:REExampleTypeVINCode];
    [self.view addSubview:view];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RECity *city = self.currentEditCar.city;
    if (indexPath.section == 0) {
        NSInteger row = [indexPath row];
        if (row == 2) {
            return city.needVinCode ? 45.0f : 0.0f;
        }else if (row == 3) {
            return city.needEngineCode ? 45.0f : 0.0f;
        }else if (row == 4) {
            return city.needRegistCode ? 45.0f : 0.0f;
        }
    }
    return 45.0f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == 0) {
        __weak REAddCarViewController *weakSelf = self;
        RECityListViewController *cityListVC = [[RECityListViewController alloc] initWithSelectCityBlcok:^(RECity *selectCity) {
            weakSelf.currentEditCar.city = selectCity;
            weakSelf.currentEditCar.licensePlateNumber = [NSString stringWithFormat:@"%@%@",[weakSelf.currentEditCar.licensePlateNumber substringFromIndex:1],selectCity.abbreviation];
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


@end
