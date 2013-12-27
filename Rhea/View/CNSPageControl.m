//
//  CNSPageControl.m
//  Cronus
//
//  Created by Tiger on 13-11-27.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "CNSPageControl.h"

#define kCurrentPageDefaultValue                     0
#define kNumberOfPagesDefaultValue                   0
#define kHidesForSinglePageDefaultValue              NO
#define kDefersCurrentPageDisplayDefaultValue        NO

#define kCoreNormalColorDefaultColor                 [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]
#define kCoreSelectedColorDefaultColor               [UIColor colorWithRed:252.0f/255.0f  green:79.0f/255.0f blue:7.0f/255.0f alpha:1.0f]
#define kStrokeNormalColorDefaultColor               [UIColor colorWithRed:252.0f/255.0f green:79.0f/255.0f blue:7.0f/255.0f alpha:0.4f]
#define kStrokeSelectedColorDefaultColor             [UIColor colorWithRed:252.0f/255.0f green:79.0f/255.0f blue:7.0f/255.0f alpha:1.0f]

#define kStrokeWidthDefaultValue                     1
#define kGapWidthDefaultValue                        5
#define kDiameterDefaultValue                        5

#define kControlHeight                               10


@implementation CNSPageControl

@synthesize currentPage = _currentPage;
@synthesize numberOfPages = _numberOfPages;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize defersCurrentPageDisplay = _defersCurrentPageDisplay;

@synthesize coreNormalColor = _coreNormalColor;
@synthesize coreSelectedColor = _coreSelectedColor;
@synthesize strokeNormalColor = _strokeNormalColor;
@synthesize strokeSelectedColor = _strokeSelectedColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize diameter = _diameter;
@synthesize gapWidth = _gapWidth;


- (NSInteger)currentPage
{
    return _currentPage;
}


- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages - 1);
    if (!_defersCurrentPageDisplay) {
        [self setNeedsDisplay];
    }
}


- (NSInteger)numberOfPages
{
    return _numberOfPages;
}


- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    self.currentPage = MIN(MAX(0, _currentPage), _numberOfPages - 1);
    if (!_defersCurrentPageDisplay) {
        [self setNeedsDisplay];
    }
    
    if (_hidesForSinglePage && (_numberOfPages < 2))
		[self setHidden: YES] ;
	else
		[self setHidden: NO] ;
}


- (BOOL)hidesForSinglePage
{
    return _hidesForSinglePage;
}


- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    
    if (_hidesForSinglePage && _numberOfPages < 2) {
        [self setHidden:YES];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.currentPage = kCurrentPageDefaultValue;
        self.numberOfPages = kNumberOfPagesDefaultValue;
        self.hidesForSinglePage = kHidesForSinglePageDefaultValue;
        self.defersCurrentPageDisplay = kDefersCurrentPageDisplayDefaultValue;
        
        self.coreNormalColor = kCoreNormalColorDefaultColor;
        self.coreSelectedColor = kCoreSelectedColorDefaultColor;
        self.strokeNormalColor = kStrokeNormalColorDefaultColor;
        self.strokeSelectedColor = kStrokeSelectedColorDefaultColor;
        self.strokeWidth = kStrokeWidthDefaultValue;
        self.diameter = kDiameterDefaultValue;
        self.gapWidth = kGapWidthDefaultValue;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*self.diameter + MAX(0, self.numberOfPages - 1) * self.gapWidth;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds)-self.diameter / 2;
    for (int i = 0; i< self.numberOfPages; i++) {
        CGRect circleRect = CGRectMake(x, y, self.diameter, self.diameter);
        if (i == self.currentPage){
            CGContextSetAlpha(context, 1.0f);
            CGContextSetFillColorWithColor(context, [self.coreSelectedColor CGColor]);
            CGContextFillEllipseInRect(context, circleRect);
        }else {
            CGContextSetAlpha(context, 0.5f);
            CGContextSetFillColorWithColor(context, [self.coreNormalColor CGColor]);
            CGContextFillEllipseInRect(context, circleRect);
        }
        x += self.diameter + self.gapWidth;
    }
}


#pragma mark - UITapGestureRecognizer


- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2){
        // move left
        if (self.currentPage > 0){
            self.currentPage -= 1;
        }
    }else {
        // move right
        if (self.currentPage < self.numberOfPages-1){
            self.currentPage += 1;
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - public methods


- (void)updateCurrentPageDisplay
{
    if (self.defersCurrentPageDisplay){
        [self setNeedsDisplay];
    }
}


- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat dotsWidth = self.numberOfPages*self.diameter + MAX(0, self.numberOfPages - 1) * self.gapWidth;
    return CGSizeMake(dotsWidth, fmax(self.diameter, kControlHeight));
}

@end
