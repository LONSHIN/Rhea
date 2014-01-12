//
//  REInputCell.h
//  Rhea
//
//  Created by Tiger on 13-12-31.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REInputCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) REBasicBlock returnKeyTappedBlcok;
@property (nonatomic, strong) REBasicBlock deselectedBlock;

- (void)updateTextFieldWithText:(NSString *)text placeholder:(NSString *)placeholder;

@end
