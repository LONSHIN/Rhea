//
//  REInputCell.m
//  Rhea
//
//  Created by Tiger on 13-12-31.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REInputCell.h"

@interface REInputCell ()
<UITextFieldDelegate>


@end


@implementation REInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (self.textField != nil) {
        if (selected) {
            self.textField.userInteractionEnabled = YES;
            [self.textField becomeFirstResponder];
        }else {
            self.textField.userInteractionEnabled = NO;
            [self.textField resignFirstResponder];
            if (self.deselectedBlock != nil) {
                self.deselectedBlock();
            }
        }
    }
}


- (void)updateTextFieldWithText:(NSString *)text placeholder:(NSString *)placeholder
{
    [self.contentView removeAllSubviews];
    
    if (self.textField == nil) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 0.0f, 180.0f, self.height)];
    }
    self.textField.text = text;
    self.textField.placeholder = placeholder;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.userInteractionEnabled = NO;
    self.textField.returnKeyType = UIReturnKeyNext;
    self.textField.delegate = self;
    [self.contentView addSubview:self.textField];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.returnKeyTappedBlcok != nil) {
        self.returnKeyTappedBlcok();
    }
    return YES;
}



@end
