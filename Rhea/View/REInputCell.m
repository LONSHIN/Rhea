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
        self.backgroundColor = [UIColor clearColor];
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


- (void)updateWithTitle:(NSString *)title detail:(NSString *)detail upRounded:(BOOL)needShowUpRounded downRounded:(BOOL)needShowDownRounded
{
    [self.contentView removeAllSubviews];
    
    [self layoutViewWithTitle:title
                       detail:detail
                 abbreviation:nil
                textFieldText:nil
                  placeholder:nil
                    upRounded:needShowUpRounded
                  downRounded:needShowDownRounded
                 questionMark:NO];
}


- (void)updateWithTitle:(NSString *)title textFieldText:(NSString *)text placeholder:(NSString *)placeholder
{
    [self.contentView removeAllSubviews];
        
    [self layoutViewWithTitle:title
                       detail:nil
                 abbreviation:nil
                textFieldText:text
                  placeholder:placeholder
                    upRounded:NO
                  downRounded:NO
                 questionMark:YES];
}


- (void)updateWithTitle:(NSString *)title abbreviation:(NSString *)abbreviation textFieldText:(NSString *)text placeholder:(NSString *)placeholder
{
    [self.contentView removeAllSubviews];
    
    [self layoutViewWithTitle:title
                       detail:nil
                 abbreviation:abbreviation
                textFieldText:text
                  placeholder:placeholder
                    upRounded:NO
                  downRounded:NO
                 questionMark:NO];
}


- (void)layoutViewWithTitle:(NSString *)title detail:(NSString *)detail abbreviation:(NSString *)abbreviation textFieldText:(NSString *)text placeholder:(NSString *)placeholder upRounded:(BOOL)needShowUpRounded downRounded:(BOOL)needShowDownRounded questionMark:(BOOL)questionMark
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(7.0f, 0.0f, 306.0f, 45.0f)];
    
    if (needShowUpRounded) {
        UIImageView *upRoundedView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 306.0f, 4.0f)];
        upRoundedView.image = [[UIImage imageNamed:@"add_car_up_rounded"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 2.04, 0.0f, 4.0f)];
        [contentView addSubview:upRoundedView];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, needShowUpRounded?4.0f:0.0f, 306.0f, needShowUpRounded?contentView.height - 4.0f:contentView.height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bgView];
    
    if (!needShowDownRounded) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7.0f, contentView.height - 0.5f, 292.0f, 0.5f)];
        line.backgroundColor = [UIColor grayColorWithDeep:230];
        [contentView addSubview:line];
    }
    
    UILabel *titleLabel = [UILabel labelWithText:title
                                 backgroundColor:[UIColor clearColor]
                                       textColor:kStandardBlueColor
                                            font:[UIFont systemFontOfSize:14.0f]];
    titleLabel.frame = CGRectMake(7.0f, 0.0f, 78.0f, contentView.height);
    titleLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    
    if (abbreviation != nil) {
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:CGRectMake(97.0f, 7.0f, 30.0f, 30.0f)];
        borderView.image = [[UIImage imageNamed:@"add_car_text_border_right_angle"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.5, 2.5, 14.5, 18.0f)];
        [contentView addSubview:borderView];
        
        UIButton *button = [UIButton buttonWithText:abbreviation
                                               font:[UIFont systemFontOfSize:12.0f]
                                          textColor:[UIColor blackColor]
                                   highlightedColor:[UIColor grayColor]
                                             target:self
                                             action:@selector(handleAbbreviationButtonTapped:)];
        button.frame = CGRectMake(90.0f, 0.0f, 45.0f, contentView.height);
        [contentView addSubview:button];
    }
    
    if (placeholder != nil) {
        if (self.textField == nil) {
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(105.0f, 0.0f, 160.0f, contentView.height)];
        }
        if (abbreviation != nil) {
            self.textField.frame = CGRectMake(130.0f, 0.0f, 140.0f, contentView.height);
            UIImageView *textFieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake(127.0f, 7.0f, 145.0f, 30.0f)];
            textFieldBgView.image = [[UIImage imageNamed:@"input_bar_bg_right_angle"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 0.0f, 4.0f, 3.0f)];
            [contentView addSubview:textFieldBgView];
        }else{
            UIImageView *textFieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake(97.0f, 7.0f, 175.0f, 30.0f)];
            textFieldBgView.image = [[UIImage imageNamed:@"input_bar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 3.0f, 4.0f, 3.0f)];
            [contentView addSubview:textFieldBgView];
        }
        
        self.textField.text = text;
        self.textField.font = [UIFont systemFontOfSize:14.0f];
        self.textField.placeholder = placeholder;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.userInteractionEnabled = NO;
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.returnKeyType = UIReturnKeyNext;
        self.textField.delegate = self;
        [contentView addSubview:self.textField];
    }
    
    if (detail != nil) {
        if (abbreviation == nil) {
            UIImageView *detailBorderView = [[UIImageView alloc] initWithFrame:CGRectMake(97.0f, 7.0f, 175.0f, 30.0f)];
            detailBorderView.image = [[UIImage imageNamed:@"add_car_text_border_rounded"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.5, 2.5, 14.5, 18.0f)];
            [contentView addSubview:detailBorderView];
        }
        
        UILabel *detailLabel = [UILabel labelWithText:detail
                                      backgroundColor:[UIColor clearColor]
                                            textColor:[UIColor blackColor]
                                                 font:[UIFont systemFontOfSize:12.0f]];
        detailLabel.frame = CGRectMake(107.0f, 0.0f, detailLabel.width, contentView.height);
        [contentView addSubview:detailLabel];
    }
    
    if (questionMark) {
        UIButton *questionMarkButton = [UIButton buttonWithText:@"?"
                                                           font:[UIFont systemFontOfSize:14.0f]
                                                      textColor:[UIColor whiteColor]
                                               highlightedColor:[UIColor lightGrayColor]
                                                         target:self
                                                         action:@selector(handleQuestionMarkButtonTapped:)];
        questionMarkButton.frame = CGRectMake(278.0f, 10.0f, 20.0f, 20.0f);
        questionMarkButton.backgroundColor = kStandardRedColor;
        questionMarkButton.layer.cornerRadius = 10.0f;
        questionMarkButton.layer.masksToBounds = YES;
        [contentView addSubview:questionMarkButton];
    }
    
    [self.contentView addSubview:contentView];
}


#pragma mark - Button Action

- (void)handleAbbreviationButtonTapped:(UIButton *)sender
{
    if (self.abbreviationViewTappedBlcok != nil) {
        self.abbreviationViewTappedBlcok();
    }
}


- (void)handleQuestionMarkButtonTapped:(UIButton *)sender
{
    if (self.questionMarkTappedBlock != nil) {
        self.questionMarkTappedBlock();
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.returnKeyTappedBlcok != nil) {
        self.returnKeyTappedBlcok();
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSRange lowercaseCharRange;
    lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}


@end
