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
@property (nonatomic, strong) REBasicBlock abbreviationViewTappedBlcok;
@property (nonatomic, strong) REBasicBlock questionMarkTappedBlock;

- (void)updateWithTitle:(NSString *)title textFieldText:(NSString *)text placeholder:(NSString *)placeholder;

- (void)updateWithTitle:(NSString *)title detail:(NSString *)detail upRounded:(BOOL)needShowUpRounded downRounded:(BOOL)needShowDownRounded;

- (void)updateWithTitle:(NSString *)title abbreviation:(NSString *)abbreviation textFieldText:(NSString *)text placeholder:(NSString *)placeholder;

@end