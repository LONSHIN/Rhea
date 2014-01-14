//
//  RECarDeleteCell.h
//  Rhea
//
//  Created by Tiger on 14-1-14.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RECarDeleteCell : UITableViewCell

@property (nonatomic, strong) REBasicBlock deleteButtonTappedBlock;

- (void)updateWithDeleteButton;

@end
