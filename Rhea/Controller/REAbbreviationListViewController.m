//
//  REAbbreviationListViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-22.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REAbbreviationListViewController.h"
#import "RELibraryAPI.h"

@interface REAbbreviationListViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RESelectAbbreviationBlock selectBlock;
@property (nonatomic, strong) NSArray *abbreviationList;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation REAbbreviationListViewController


- (id)initWithSelectBlock:(RESelectAbbreviationBlock)block
{
    if (self = [super init]) {
        self.selectBlock = block;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车牌归属地";
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
    __weak REAbbreviationListViewController *weakSelf = self;
    [RELibraryAPI getAbbreviationList:^(NSArray *abbreviationList) {
        weakSelf.abbreviationList = abbreviationList;
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
    return self.abbreviationList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    cell.textLabel.text = [self.abbreviationList objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock != nil) {
        NSString *abbreviation = [self.abbreviationList objectAtIndex:indexPath.row];
        self.selectBlock(abbreviation);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
