//
//  ZRSAdPicProtocol.h
//  ZRSAdPicView_Example
//
//  Created by Rathen on 2018/5/7.
//  Copyright © 2018年 Rathen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZRSAdPicProtocol <NSObject>

/**
 广告位普片URL
 */
@property (nonatomic, copy, readonly) NSURL *adImgURL;

/**
 点击执行的代码块（优先级高于adlinkUrl）
 */
@property (nonatomic, copy) void (^clickBlock)();


@end
