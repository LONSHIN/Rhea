//
//  CNSShareManager.h
//  Cronus
//
//  Created by Tiger on 13-12-6.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNSShareManager : NSObject

+ (CNSShareManager *)manager;

- (BOOL)canShareToWeChat;

- (void)shareApplicationInfoToWeChatSession;
- (void)shareApplicationInfoToWeChatTimeLine;

@end
