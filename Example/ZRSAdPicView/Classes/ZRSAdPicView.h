//
//  ZRSAdPicView.h
//  ZRSAdPicView_Example
//
//  Created by Rathen on 2018/5/7.
//  Copyright © 2018年 Rathen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSAdPicProtocol.h"





typedef void(^LoadImageBlock)(UIImageView *imageView, NSURL *url);


@protocol ZRSAdPicViewDelegate <NSObject>

- (void)adPicViewDidSelectedPicModel: (id <ZRSAdPicProtocol>)picM;

@end

@interface ZRSAdPicView : UIView

+ (instancetype)picViewWithLoadImageBlock:(LoadImageBlock)loadBlock;


/**
 用于加载图片的代码块，必须赋值
 */
@property (nonatomic, copy) LoadImageBlock loadBlock;

/**
 通知外界，当前滚动的是哪个广告位
 */
@property (nonatomic, assign) id <ZRSAdPicViewDelegate> delegate;


/**
 用来展示图片的数据源
 */
@property (nonatomic, strong) NSArray <id <ZRSAdPicProtocol>> *picModels;

@end
