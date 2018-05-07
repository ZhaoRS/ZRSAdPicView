//
//  ZRSAdPicModel.h
//  ZRSAdPicView_Example
//
//  Created by Rathen on 2018/5/7.
//  Copyright © 2018年 Rathen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRSAdPicModel : NSObject
/**
 *  广告图片URL
 */
@property (nonatomic, copy) NSURL *adImgURL;

/**
 *  点击广告, 需要跳转的URL
 */
@property (nonatomic, copy) NSURL *adLinkURL;

/**
 *  点击执行的代码块(优先级高于adLinkURL)
 */
@property (nonatomic, copy) void(^clickBlock)();

@end
