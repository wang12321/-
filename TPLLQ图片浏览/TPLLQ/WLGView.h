//
//  WLGView.h
//  TPLLQ
//
//  Created by 汪利钢 on 16/2/26.
//  Copyright © 2016年 汪利钢. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLGView ;

@protocol WLGPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(WLGView *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(WLGView *)browser highQualityImageURLForIndex:(NSInteger)index;
@end

@interface WLGView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;

}
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) NSArray *imgArr;

@property (nonatomic, weak) id<WLGPhotoBrowserDelegate> delegate;

- (void)show;
@end
