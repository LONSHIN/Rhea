//
//  CNSPageControl.h
//  Cronus
//
//  Created by Tiger on 13-11-27.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNSPageControl : UIControl

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) BOOL defersCurrentPageDisplay;

@property (nonatomic, strong) UIColor *coreNormalColor;
@property (nonatomic, strong) UIColor *coreSelectedColor;
@property (nonatomic, strong) UIColor *strokeNormalColor;
@property (nonatomic, strong) UIColor *strokeSelectedColor;
@property (nonatomic, assign) NSInteger strokeWidth;
@property (nonatomic, assign) NSInteger diameter;
@property (nonatomic, assign) NSInteger gapWidth;

- (void)updateCurrentPageDisplay;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end
