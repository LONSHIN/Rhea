//
//  APOSwitchPageView.m
//  Apollo
//
//  Created by tiger on 13-12-19.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "APOSwitchPageView.h"

#define kTagContentView                     100
#define kAnimationDurationScrollToPage      0.25


@interface APOSwitchPageView ()
<UIScrollViewDelegate>

@property (nonatomic, readwrite) NSInteger currentPageIndex;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)tilePages;

@end


@implementation APOSwitchPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        self.currentPageIndex = NSIntegerMax;
        self.frame = frame;
        self.scrollView.frame = self.bounds;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self tilePages];
}


- (void)setPageCount:(NSInteger)pageCount
{
    _pageCount = pageCount;
    self.scrollView.contentSize = CGSizeMake(pageCount * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


#pragma mark - Inner Method

- (void)tilePages
{
    CGRect visibleBounds = self.scrollView.bounds;
    NSInteger currentPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    if (currentPageIndex < 0) {
        currentPageIndex = 0;
    }
    UIView *contentView = [self viewWithTag:kTagContentView + currentPageIndex];
    if (currentPageIndex == self.currentPageIndex && contentView != nil) {
        return;
    }
    self.currentPageIndex = currentPageIndex;
    NSInteger pageIndexBeforeCurrent = currentPageIndex - 1;
    NSInteger pageIndexBehindCurrent = currentPageIndex + 1;
    pageIndexBeforeCurrent = MAX(pageIndexBeforeCurrent, 0);
    pageIndexBehindCurrent = MIN(pageIndexBehindCurrent, self.pageCount - 1);
    for (NSInteger i = pageIndexBeforeCurrent; i <= pageIndexBehindCurrent; i ++) {
        UIView *contentView = [self viewWithTag:kTagContentView + i];
        if (contentView != nil)     continue;
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(pageView:contentViewForPageIndex:)]) {
            contentView = [self.dataSource pageView:self contentViewForPageIndex:i];
        }
        if (contentView != nil) {
            CGFloat width = self.scrollView.frame.size.width;
            CGFloat height = self.scrollView.frame.size.height;
            contentView.tag = kTagContentView + i;
            contentView.frame = CGRectMake(width * i, 0.0f, width, height);
            [self.scrollView addSubview:contentView];
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didScrollToPageIndex:)]) {
        [self.delegate pageView:self didScrollToPageIndex:self.currentPageIndex];
    }
}


#pragma mark -Public Method

- (void)setPageViewFrame:(CGRect)frame
{
    self.frame = frame;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.pageCount * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


- (void)scrollToPageIndex:(NSInteger)index
{
    
}


- (void)scrollToPageIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index == self.currentPageIndex) {
        return;
    }
    CGPoint contentOffset = CGPointMake(index * self.scrollView.frame.size.width, 0.0f);
    if (animated) {
        [UIView animateWithDuration:kAnimationDurationScrollToPage animations:^{
            [self.scrollView setContentOffset:contentOffset];
        } completion:^(BOOL finished) {
            [self tilePages];
        }];
    }
    else{
        [self.scrollView setContentOffset:contentOffset];
        [self tilePages];
    }
}


- (void)reloadPageView
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self tilePages];
}


- (void)reloadPageAtPageIndex:(NSInteger)index
{
    UIView *viewAtIndex = [self viewAtIndex:index];
    if (viewAtIndex != nil) {
        [viewAtIndex removeFromSuperview];
    }
    [self tilePages];
}


- (UIView *)viewAtIndex:(NSInteger)index
{
    UIView *viewAtIndex = (UIView *)[self.scrollView viewWithTag:kTagContentView + index];
    return viewAtIndex;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self tilePages];
}


@end
