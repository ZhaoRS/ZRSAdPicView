//
//  ZRSViewController.m
//  ZRSAdPicView
//
//  Created by Rathen on 05/07/2018.
//  Copyright (c) 2018 Rathen. All rights reserved.
//

#import "ZRSViewController.h"
#import "ZRSAdPicView.h"
#import "ZRSAdPicModel.h"
#import "UIImageView+WebCache.h"

@interface ZRSViewController ()

@end

@implementation ZRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ZRSAdPicView *adView = [ZRSAdPicView picViewWithLoadImageBlock:^(UIImageView *imageView, NSURL *url) {
       
        [imageView sd_setImageWithURL:url];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            if(data){
//                UIImage *image = [UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    imageView.image = image;
//                });
//            }
//
//        });
    }];
    adView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    
    adView.backgroundColor = [UIColor redColor];
    [self.view addSubview:adView];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 5; i ++) {
        ZRSAdPicModel *model = [[ZRSAdPicModel alloc] init];
        model.adImgURL = [NSURL URLWithString:@"http://img07.tooopen.com/images/20170316/tooopen_sy_201956178977.jpg"];
        [array addObject:model];
    }
    
    adView.picModels = array;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
