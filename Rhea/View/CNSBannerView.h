//
//  CNSBannerView.h
//  Cronus
//
//  Created by Tiger on 13-11-27.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNSBannerViewDataSource;
@protocol CNSBannerViewDelegate;

@interface CNSBannerView : UIView

- (id)initWithFrame:(CGRect)frame bannerViewDataSource:(id <CNSBannerViewDataSource>)dataSource bannerViewDelegate:(id <CNSBannerViewDelegate>)delegate;
- (void)reloadView;

@end



@protocol CNSBannerViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInBannerView:(CNSBannerView *)bannerView;
- (UIView *)bannerView:(CNSBannerView *)bannerView viewForPageAtIndex:(NSInteger)index;

@optional
- (CGFloat)displayPageControlHeightInBannerView:(CNSBannerView *)bannerView;
- (UIImageView *)displayPlaceHolderImageViewInBannerView:(CNSBannerView *)bannerView;

@end



@protocol CNSBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(CNSBannerView *)bannerView didSelectPageAtIndex:(NSInteger)index;

@end
