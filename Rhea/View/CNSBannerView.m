//
//  CNSBannerView.m
//  Cronus
//
//  Created by Tiger on 13-11-27.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "CNSBannerView.h"

#import "CNSBannerView.h"
#import "CNSPageControl.h"

#define kPageControlHeightDefaultValue          20.0f
#define kScrollTimeDefaultValue                 5.0f

@interface CNSBannerView ()
<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <CNSBannerViewDataSource> dataSource;
@property (nonatomic, weak) id <CNSBannerViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, strong) CNSPageControl  *pageControl;
@property (nonatomic, assign) CGFloat         pageControlHeight;
@property (nonatomic, assign) NSInteger       numberOfPages;
@property (nonatomic, assign) NSInteger       currentPage;
@property (nonatomic, strong) NSTimer         *showTimer;
@property (nonatomic, strong) UIImageView     *placeHolderImageView;

@end


@implementation CNSBannerView

- (id)initWithFrame:(CGRect)frame bannerViewDataSource:(id<CNSBannerViewDataSource>)dataSource bannerViewDelegate:(id<CNSBannerViewDelegate>)delegate
{
    if (frame.size.height <= kPageControlHeightDefaultValue) {
        return nil;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        self.delegate = delegate;
        
        self.pageControlHeight = kPageControlHeightDefaultValue;
        
        if ([self.dataSource respondsToSelector:@selector(displayPageControlHeightInBannerView:)]) {
            self.pageControlHeight = [self.dataSource displayPageControlHeightInBannerView:self];
        }
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.numberOfPages = [self.dataSource numberOfPagesInBannerView:self];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.numberOfPages + 2), self.scrollView.frame.size.height);
        
        for (NSInteger i = 0; i < self.numberOfPages + 2; i ++) {
            NSInteger index;
            if (i == 0) {
                index = self.numberOfPages - 1;
            }else if (i == self.numberOfPages + 1) {
                index = 0;
            }else {
                index = i - 1;
            }
    
            UIView *contentView = [self.dataSource bannerView:self viewForPageAtIndex:index];
            CGRect rect = CGRectMake(self.scrollView.frame.size.width * i, 0.0f, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            contentView.frame = rect;
            [self.scrollView addSubview:contentView];
        }
        [self addSubview:self.scrollView];
        
        self.pageControl = [[CNSPageControl alloc] initWithFrame:CGRectMake(0.0f, self.scrollView.frame.size.height - self.pageControlHeight, self.scrollView.frame.size.width, self.pageControlHeight)];
        [self.pageControl setNumberOfPages: self.numberOfPages];
        [self addSubview: self.pageControl];
        
        self.currentPage = 1;
        
        if ([self.dataSource respondsToSelector:@selector(displayPlaceHolderImageViewInBannerView:)]) {
            self.placeHolderImageView = [self.dataSource displayPlaceHolderImageViewInBannerView:self];
            [self addSubview:self.placeHolderImageView];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)reloadView
{
    [self stopScroll];
    self.scrollView.userInteractionEnabled = NO;
    [self.placeHolderImageView removeFromSuperview];
    self.placeHolderImageView = nil;
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    self.pageControlHeight = kPageControlHeightDefaultValue;
    if ([self.dataSource respondsToSelector:@selector(displayPageControlHeightInBannerView:)]) {
        self.pageControlHeight = [self.dataSource displayPageControlHeightInBannerView:self];
    }
    
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    self.numberOfPages = [self.dataSource numberOfPagesInBannerView:self];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.numberOfPages + 2), self.scrollView.frame.size.height);
    
    for (NSInteger i = 0; i < self.numberOfPages + 2; i ++) {
        NSInteger index;
        if (i == 0) {
            index = self.numberOfPages - 1;
        }else if (i == self.numberOfPages + 1) {
            index = 0;
        }else {
            index = i - 1;
        }
        UIView *contentView = [self.dataSource bannerView:self viewForPageAtIndex:index];
        CGRect rect = CGRectMake(self.scrollView.frame.size.width * i, 0.0f, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        contentView.frame = rect;
        [self.scrollView addSubview:contentView];
    }
    [self addSubview:self.scrollView];
    
    if (self.numberOfPages > 1) {
        self.pageControl.frame = CGRectMake(0.0f, self.scrollView.frame.size.height - self.pageControlHeight, self.scrollView.frame.size.width, self.pageControlHeight);
        [self.pageControl setNumberOfPages: self.numberOfPages];
        [self addSubview: self.pageControl];
    }
    
    self.currentPage = 1;
    [self beginScroll];
    self.scrollView.userInteractionEnabled = YES;
}


#pragma mark - internal methods


- (void)beginScroll
{
    if (self.showTimer) {
        [self.showTimer invalidate];
    }
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:kScrollTimeDefaultValue target:self selector:@selector(changedBanner:) userInfo:nil repeats:YES];
}


- (void)stopScroll
{
    if (self.showTimer) {
        [self.showTimer invalidate];
    }
}


- (NSInteger)getPage
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2)
                           / pageWidth) + 1;
    return page;
}


- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    NSInteger index;
    if (currentPage == 0) {
        index = self.numberOfPages - 1;
    }else if (currentPage == self.numberOfPages + 1) {
        index = 0;
    }else {
        index = currentPage - 1;
    }
    [self.pageControl setCurrentPage:index];
    
    
    if ([self.showTimer isValid]) {
        __weak CNSBannerView *weakSelf = self;
        [UIView animateWithDuration:0.2f animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake((weakSelf.scrollView.width * weakSelf.currentPage), 0.0f);
        } completion:^(BOOL finished) {
            if (currentPage == weakSelf.numberOfPages + 1) {
                weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.width, 0.0f);
                _currentPage = 0;
            }
            if (currentPage == 0) {
                weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.width * weakSelf.numberOfPages, 0.0f);
                _currentPage = weakSelf.numberOfPages - 1;
            }
        }];
    }else{
        self.scrollView.contentOffset = CGPointMake((self.scrollView.width * currentPage), 0.0f);
        if (currentPage == self.numberOfPages + 1) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0.0f);
            _currentPage = 0;
        }
        if (currentPage == 0) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.width * self.numberOfPages, 0.0f);
            _currentPage = self.numberOfPages - 1;
        }
    }
}


- (void)changedBanner:(NSTimer *)timer
{
    self.currentPage ++;
//    [self.scrollView setContentOffset:CGPointMake((self.scrollView.frame.size.width * self.currentPage), 0.0f) animated:animated];
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    NSInteger page = [self getPage];
    NSInteger index;
    if (page == 0) {
        index = self.numberOfPages - 1;
    }else if (page == self.numberOfPages + 1) {
        index = 0;
    }else {
        index = page - 1;
    }
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectPageAtIndex:)]) {
        [self.delegate bannerView:self didSelectPageAtIndex:index];
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopScroll];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self stopScroll];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.currentPage != [self getPage]) {
        self.currentPage = [self getPage];
    }
    [self beginScroll];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        if (self.currentPage != [self getPage]) {
            self.currentPage = [self getPage];
        }
        [self beginScroll];
    }
}


#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
