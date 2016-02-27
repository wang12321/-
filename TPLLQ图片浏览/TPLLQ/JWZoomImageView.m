//
//  JWZoomImageView.m
//  jiawo
//
//  Created by 汪利钢 on 15/12/15.
//  Copyright © 2015年 ZHE JIANG ASUN PROPERTY MANAGEMENT. All rights reserved.
//

#import "JWZoomImageView.h"
#import "UIImageView+WebCache.h"
#define JWScreemSize [UIScreen mainScreen].bounds.size

@implementation JWZoomImageView

-(void)addTopZoomInImageViewWithFullArray:(NSArray *)urlArr{
    //开启点击事件
    self.userInteractionEnabled = YES;
    
    
    if (urlArr != nil) {
    
    for (int i = 0; i < urlArr.count; i ++) {
        NSDictionary *dic = urlArr[i];
        NSLog(@"%@",dic);
        NSString *str = dic[@"attachPath"];
        NSLog(@"%@",str);
       _fullImageUrl = str;
     }
  }
    //点击放大图片
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullTapzoomimage:)];
    [self addGestureRecognizer:_tap];
    
    
    
    
    
}



-(void)addTopZoomInImageViewWithFullString:(NSString *)urlString{
    //开启点击事件
    self.userInteractionEnabled = YES;
    
    
    if (urlString != nil) {
        _fullImageUrl = urlString;
    }
    
    
    //点击放大图片
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullTapzoomimage:)];
    [self addGestureRecognizer:_tap];
    
    
    
    
    
}


//点击放大图片手势
-(void)fullTapzoomimage:(UITapGestureRecognizer*)tap{
    
    if (self.image == nil) {
        return;
        
    }
    
    
    //初始化子视图
    [self _initView];
    
    //收起键盘的协议方法
    if ([self.zoomdelegate respondsToSelector:@selector(changer)]) {
        
        [self.zoomdelegate changer];
    }
    
    
    //给子视图设置frame
    //获取该视图相对于另一个视图的frame
    _fullimageView.frame = [self convertRect:self.bounds toView:self.window];
    
    
    //实现放大图片
    [UIView animateWithDuration:.4 animations:^{
        
        //获取比例得到相对应的高度
        CGFloat height =  JWScreemSize.width /  (self.image.size.width / self.image.size.height);
        
        //取最大的高度
        _fullimageView.frame = CGRectMake(0, 0, JWScreemSize.width, MAX(height, JWScreemSize.height));
        
        _scrllView.contentSize =CGSizeMake(JWScreemSize.width, height);
    } completion:^(BOOL finished) {
        
        if (_fullImageUrl == nil) {
            return ;
        }
        [_fullimageView sd_setImageWithURL:[NSURL URLWithString:_fullImageUrl] placeholderImage:self.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
            NSLog(@"%f",(CGFloat)receivedSize/expectedSize);
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
        }];
        
        
    }];
    
    
}

-(void)_initView{
    
    //创建scrollview
    
    if (_scrllView == nil) {
        
        _scrllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JWScreemSize.width, JWScreemSize.height)];
        _scrllView.backgroundColor = [UIColor clearColor];
        //在滑动视图上添加缩小的手势
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutImageView:)];
        [_scrllView addGestureRecognizer:tap];
        
        
        [self.window addSubview:_scrllView];
    }
    
    
    
    //创建放大视图
   
    if (_fullimageView == nil) {
        _fullimageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _fullimageView.image = self.image;
        _fullimageView.contentMode = self.contentMode;
        [_scrllView addSubview:_fullimageView];
        
    }
    
    
}

//缩小视图

- (void)zoomOutImageView:(UITapGestureRecognizer *)tap
{
    //打开键盘的协议方法
    if ([self.zoomdelegate respondsToSelector:@selector(huangyuan)]) {
        
        [self.zoomdelegate huangyuan];
    }
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _fullimageView.frame = [self convertRect:self.bounds toView:self.window];
        
        //        _fullimageView.frame = self.frame;
        
        _scrllView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
        [_fullimageView removeFromSuperview];
        _fullimageView = nil;
        
        [_scrllView removeFromSuperview];
        _scrllView = nil;
        
    }];
    
    
    
}


@end
