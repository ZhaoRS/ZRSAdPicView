//
//  ZRSAdPicView.m
//  ZRSAdPicView_Example
//
//  Created by Rathen on 2018/5/7.
//  Copyright © 2018年 Rathen. All rights reserved.
//

#import "ZRSAdPicView.h"

static NSInteger const radio = 10;

@interface ZRSAdPicView ()<UIScrollViewDelegate>
{
    NSInteger _currentPage;
}

/**
 记录着根据模型数组，添加的imageView控件
 */
@property (nonatomic, strong) NSMutableArray <UIImageView *>*adpics;

/**
 存放图片的内容视图
 */
@property (nonatomic, strong) UIScrollView *contentView;


/**
 页码指示
 */
@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation ZRSAdPicView

+ (instancetype)picViewWithLoadImageBlock:(LoadImageBlock)loadBlock{
    ZRSAdPicView *adView = [[ZRSAdPicView alloc] init];
    adView.loadBlock = loadBlock;
    return adView;
}

- (NSTimer *)scrollTimer {
    if (_scrollTimer == nil) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
    return _scrollTimer;
}

- (void)autoScrollNextPage {
    NSInteger page = _currentPage + 1;
    [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * page, 0) animated:YES];
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIScrollView *)contentView {
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.pagingEnabled = YES;
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.delegate = self;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (NSMutableArray<UIImageView *> *)adpics {
    if (_adpics == nil) {
        _adpics = [NSMutableArray array];
    }
    return _adpics;
}

- (void)setPicModels:(NSArray<id<ZRSAdPicProtocol>> *)picModels{
    _picModels = picModels;
    //1. 移除之前控件
    [self.adpics makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.adpics = nil;
    
    //根据模型添加新的控件
    NSInteger baseCount = picModels.count;
    NSInteger count = baseCount;
    if (baseCount > 1) {
        count = baseCount * radio;
    }
    
    for (int i = 0; i < count; i ++) {
        id <ZRSAdPicProtocol> picM = picModels[i % baseCount];
        //1.创建控件
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = self.adpics.count;
        
        //2.设置图片
        if (self.loadBlock) {
            self.loadBlock(imageView, picM.adImgURL);
        }
        
        //3.添加收拾，点击图片跳转
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        //4.添加到父控件，以及数组保存
        [self.contentView addSubview:imageView];
        [self.adpics addObject:imageView];
    }
    
    self.pageControl.numberOfPages = picModels.count;
    [self setNeedsLayout];
    
    if (picModels.count > 1) {
        [self.scrollTimer fire];
    } else {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)jumpToLink:(UITapGestureRecognizer *)gester {
    UIView *imageView = gester.view;
    NSInteger tag = imageView.tag % self.picModels.count;
    id<ZRSAdPicProtocol> adM = self.picModels[tag];
    
    if (adM.clickBlock != nil) {
        adM.clickBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    
    NSInteger count = self.adpics.count;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    for (int i = 0 ; i < count; i ++) {
        UIImageView *imageView = self.adpics[i];
        imageView.frame = CGRectMake(i * width, 0, width, height);
    }
    
    self.contentView.contentSize = CGSizeMake(width * count, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.adpics.count >  1) {
        [self scrollTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self caculateCurrentPage:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self caculateCurrentPage:scrollView];
}

- (void)caculateCurrentPage:(UIScrollView *)scrollView {
    
    if (self.picModels.count == 0) {
        return;
    }
    
    if (self.picModels.count == 1) {
        _currentPage = 1;
        if ([self.delegate respondsToSelector:@selector(adPicViewDidSelectedPicModel:)]) {
            [self.delegate adPicViewDidSelectedPicModel:self.picModels[self.pageControl.currentPage]];
        }
        return;
    }
    
    
    //确认中间区域
    NSInteger min = self.picModels.count * (radio / 2);
    NSInteger max = self.picModels.count * (radio / 2 + 1);
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page % self.picModels.count;
    
    if (page < min || page > max) {
        page = min + page % self.picModels.count;
        [scrollView setContentOffset:CGPointMake(page * scrollView.frame.size.width, 0)];
    }
    
    _currentPage = page;
    if ([self.delegate respondsToSelector:@selector(adPicViewDidSelectedPicModel:)]) {
        [self.delegate adPicViewDidSelectedPicModel:self.picModels[self.pageControl.currentPage]];
    }
    
    
    
    
    
}



@end
