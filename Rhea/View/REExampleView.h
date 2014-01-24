//
//  REExampleView.h
//  Rhea
//
//  Created by Tiger on 14-1-24.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, REExampleType) {
    REExampleTypeVINCode,
    REExampleTypeEngineCode,
    REExampleTypeRegistCode,
};

@interface REExampleView : UIView

- (id)initWithFrame:(CGRect)frame type:(REExampleType)type;


@end
