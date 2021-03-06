//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"

#define SDPhotoGroupImageMargin 15

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@end

@implementation SDPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    int imageCount = (int)self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    
    int totalRowCount = imageCount / perRowImageCount + 0.99999; // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    CGFloat w = 80;
    CGFloat h = 80;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        int rowIndex = (int)idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + SDPhotoGroupImageMargin);
        CGFloat y = rowIndex * (h + SDPhotoGroupImageMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];

    self.frame = CGRectMake(10, 10, 280, totalRowCount * (SDPhotoGroupImageMargin + h));
}

- (void)buttonClick:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = (int)button.tag;
    NSLog(@"%ld",(long)button.tag);
    browser.delegate = self;
    [browser show]; 
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return nil;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com