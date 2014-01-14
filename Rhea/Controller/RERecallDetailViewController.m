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

#define kTagOfEmptyView          134


@interface RERecallDetailViewController ()
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSString *vinCode;
@property (nonatomic, strong) NSArray *recallList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@end



@implementation RERecallDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
    [self configTextField];
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithIntegerRed:115 green:158 blue:236];
    self.title = @"召回查询";
}


- (void)getRecallInfo
{
    [SVProgressHUD show];
    
    __weak RERecallDetailViewController *weakSelf = self;
    
    [RELibraryAPI  getRecallInfoWithVinCode:self.vinCode succeededBlock:^(NSArray *recallInfo) {
        if (!recallInfo.count) {
            [weakSelf showEmptyView];
        }else {
            [weakSelf removeEmptyView];
            weakSelf.recallList = recallInfo;
            [weakSelf.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failedBlock:^(NSError *error) {
        weakSelf.recallList = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)configTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 40.0f)];
    //self.textField.backgroundColor = [UIColor redColor];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.placeholder = @"在此输入完整车辆识别码";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.textField];
}


- (void)configTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, kScreenIs4InchRetina ? (568.0f - (kSystemVersionPriorToIOS7 ? 44.0f : 64.0f) - 35.0f) : (480.0f - (kSystemVersionPriorToIOS7 ? 44.0f : 64.0f) - 35.0f)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (void)showEmptyView
{
    UILabel *emptyView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.width, self.view.height)];
    emptyView.backgroundColor = [UIColor colorWithIntegerRed:226 green:233 blue:245];
    emptyView.textColor = [UIColor colorWithIntegerRed:162 green:174 blue:191];
    emptyView.font = [UIFont systemFontOfSize:20.0f];
    emptyView.textAlignment = NSTextAlignmentCenter;
    emptyView.text = @"恭喜，无召回记录\n\n\n";
    emptyView.numberOfLines = 0;
    emptyView.tag = kTagOfEmptyView;
    [self.view addSubview:emptyView];
}


- (void)removeEmptyView
{
    UIView *emptyView = [self.view viewWithTag:kTagOfEmptyView];
    [emptyView removeFromSuperview];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.vinCode = textField.text;
    [self.textField resignFirstResponder];
    [self getRecallInfo];
    return YES;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recallList.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    RERecallInfo *recallInfo = [self.recallList objectAtIndex:[indexPath section]];
    
    NSArray *titleArray = @[@"召回时间", @"涉及数量", @"缺陷情况", @"可能后果", @"维修措施", @"改进措施", @"投诉情况", @"车主通知", @"其他信息"];
    NSArray *contentArray = @[recallInfo.availableTime, recallInfo.involvingNumber, recallInfo.problem, recallInfo.consequence, recallInfo.fixMeasures, recallInfo.improveMeasures, recallInfo.complaints, recallInfo.ownersNotice, recallInfo.otherInfo];
    
    cell.textLabel.text = titleArray[row];
    cell.detailTextLabel.text = contentArray[row];
    cell.detailTextLabel.numberOfLines = 0;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    RERecallInfo *recallInfo = [self.recallList objectAtIndex:[indexPath section]];
    
    NSArray *contentArray = @[recallInfo.availableTime, recallInfo.involvingNumber, recallInfo.problem, recallInfo.consequence, recallInfo.fixMeasures, recallInfo.improveMeasures, recallInfo.complaints, recallInfo.ownersNotice, recallInfo.otherInfo];
    
    CGSize size = [contentArray[row] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(300.0f, MAXFLOAT)];
    
    return size.height + 40.0f;
}

@end
