//
//  JWZoomImageView.h
//  jiawo
//
//  Created by 汪利钢 on 15/12/15.
//  Copyright © 2015年 ZHE JIANG ASUN PROPERTY MANAGEMENT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol zoomProtocol <NSObject>

-(void)changer;

-(void)huangyuan;
@end

@interface JWZoomImageView : UIImageView
{
    UIScrollView *_scrllView; //活动视图-->添加到window上
    UIImageView *_fullimageView;//放大的图片视图
  
    UITapGestureRecognizer *_tap;//放大的手势
    
    NSString *_fullImageUrl; //放大后图片的地址
    NSMutableArray *_mutableArray;
}
@property(nonatomic,weak)id<zoomProtocol>zoomdelegate;

//添加一个点击事件用来放大图片
- (void)addTopZoomInImageViewWithFullString:(NSString*)urlString;

- (void)addTopZoomInImageViewWithFullArray:(NSArray*)urlArr;



@end
