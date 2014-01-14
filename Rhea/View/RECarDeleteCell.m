//
//  RECarDeleteCell.m
//  Rhea
//
//  Created by Tiger on 14-1-14.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "RECarDeleteCell.h"

@implementation RECarDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)updateWithDeleteButton
{    
    UIButton *deleteButton = [UIButton buttonWithText:@"删除"
                                                 font:[UIFont systemFontOfSize:12.0f]
                                            textColor:[UIColor whiteColor]
                                     highlightedColor:[UIColor lightGrayColor]
                                               target:self
                                               action:@selector(handleDeleteButtonTapped:)];
    deleteButton.backgroundColor = [UIColor colorWithHexString:@"5480c6"];
    deleteButton.frame = CGRectMake(260.0f, 8.0, deleteButton.width, 25.0f);
    [self.contentView addSubview:deleteButton];
    [self.contentView bringSubviewToFront:deleteButton];
}


- (void)handleDeleteButtonTapped:(UIButton *)sender
{
    if (self.deleteButtonTappedBlock != nil) {
        self.deleteButtonTappedBlock();
    }
}

@end
