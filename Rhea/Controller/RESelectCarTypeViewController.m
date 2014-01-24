//
//  RESelectCarTypeViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-2.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "RESelectCarTypeViewController.h"
#import "RELibraryAPI.h"

typedef void(^RESelectBlock)(id block);

@interface RESelectCarTypeViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *carTypeList;
@property (nonatomic, strong) RESelectBlock selectBlock;

@end


@implementation RESelectCarTypeViewController

- (id)initWithSelectBlock:(void (^)(RECarType *))block
{
    if (self = [super init]) {
        self.selectBlock = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车辆种类选择";
	[self configTableView];
    [self getCarTypeListData];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.height - (kSystemVersionPriorToIOS7?44.0f:64.0f))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - Get Data

- (void)getCarTypeListData
{
    __weak RESelectCarTypeViewController *weakSelf = self;
    [RELibraryAPI getCarTypeList:^(NSArray *carTypeList) {
        weakSelf.carTypeList = carTypeList;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carTypeList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    RECarType *carType = [self.carTypeList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = carType.name;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock != nil) {
        RECarType *selectedCarType = [self.carTypeList objectAtIndex:indexPath.row];
        self.selectBlock(selectedCarType);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
