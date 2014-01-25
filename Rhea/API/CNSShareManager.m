//
//  CNSShareManager.m
//  Cronus
//
//  Created by Tiger on 13-12-6.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "CNSShareManager.h"
#import "WXApi.h"

NSString *const kApplicationDownloadUrl = @"https://itunes.apple.com/cn/app/id796907297?ls=1&mt=8";

@implementation CNSShareManager

- (id)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeChatResponse:) name:kNotificationWeChatResponse object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWeChatRequest:) name:kNotificationWeChatRequest object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (CNSShareManager *)manager
{
    static CNSShareManager *_manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CNSShareManager alloc] init];
    });
    return _manager;
}


- (BOOL)canShareToWeChat
{
    return ([WXApi isWXAppInstalled] &&  [WXApi isWXAppSupportApi]);
}


- (void)shareApplicationInfoToWeChatSession
{
   // [MobClick event:@"shareApplicationToWeChat"];
    [self shareApplicationToWeChatWithSence:WXSceneSession];
}


- (void)shareApplicationInfoToWeChatTimeLine
{
 //   [MobClick event:@"shareApplicationToWeChat"];
    [self shareApplicationToWeChatWithSence:WXSceneTimeline];
}


#pragma mark - Inner Method

- (WXMediaMessage *)applicationWeChatMediaMessageInSence:(NSInteger)sence
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"车小弟－查违章 查召回";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"icon_60"]];
    
    WXAppExtendObject *extendObject = [WXAppExtendObject object];
    extendObject.url = kApplicationDownloadUrl;
    message.mediaObject = extendObject;
    
    return message;
}


- (void)shareApplicationToWeChatWithSence:(NSInteger)sence
{
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.bText = NO;
    request.message = [self applicationWeChatMediaMessageInSence:sence];
    request.scene = sence;
    
    [WXApi sendReq:request];
}


#pragma mark - Notification

- (void)handleWeChatResponse:(NSNotification *)sender
{
    BaseResp *weChatResponse = [sender.userInfo objectForKey:kNotificationUserInfoKeyWeChatResponse];
    if([weChatResponse isKindOfClass:[SendMessageToWXResp class]]){
        [SVProgressHUD showImage:nil status:weChatResponse.errStr];
    }
}


- (void)handleWeChatRequest:(NSNotification *)sender
{

}
@end
