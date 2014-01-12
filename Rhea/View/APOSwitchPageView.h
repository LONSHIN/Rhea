//
//  APOSwitchPageView.h
//  Apollo
//
//  Created by tiger on 13-12-19.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APOSwitchPageViewDelegate;
@protocol APOSwitchPageViewDataSource;



@interface APOSwitchPageView : UIView

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, readonly) NSInteger currentPageIndex;
@property (nonatomic, weak) id <APOSwitchPageViewDelegate>delegate;
@property (nonatomic, weak) id <APOSwitchPageViewDataSource>dataSource;

- (void)setPageViewFrame:(CGRect)frame;

- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadPageView;
- (void)reloadPageAtPageIndex:(NSInteger)index;

- (UIView *)viewAtIndex:(NSInteger)index;

@end



@protocol APOSwitchPageViewDataSource <NSObject>

- (UIView *)pageView:(APOSwitchPageView *)switchPageView contentViewForPageIndex:(NSInteger)index;

@end



@protocol APOSwitchPageViewDelegate <NSObject>

- (void)pageView:(APOSwitchPageView *)switchPageView didScrollToPageIndex:(NSInteger)index;

@end




