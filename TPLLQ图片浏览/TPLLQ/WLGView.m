//
//  WLGView.m
//  TPLLQ
//
//  Created by 汪利钢 on 16/2/26.
//  Copyright © 2016年 汪利钢. All rights reserved.
//

#import "WLGView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
// 图片保存成功提示文字
#define SDPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define SDPhotoBrowserSaveImageFailText @" >_< 保存失败 ";


#define WLGScreemSize [UIScreen mainScreen].bounds.size

@implementation WLGView
{
    UIImageView *_imageView;
    UITapGestureRecognizer *_tap;//放大的手势
    NSMutableArray *_arrImg;
        UIActivityIndicatorView *_indicatorView;
    UIButton *_saveButton;

}
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
//        [self initView];
        _arrImg = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)setImageCount:(NSInteger)imageCount{
    if (_imageCount != imageCount) {
        _imageCount = imageCount;
        [self initView];

    }
}
-(void)initView{
    
    UIButton *btn = [_sourceImagesContainerView subviews][_currentImageIndex];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WLGScreemSize.width, WLGScreemSize.height)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor greenColor];

    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WLGScreemSize.width * _imageCount, WLGScreemSize.height);
      _scrollView.contentOffset=CGPointMake((WLGScreemSize.width)*_currentImageIndex, 0);
    [self addSubview:_scrollView];
    
    for (int i = 0; i < _imageCount; i++) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WLGScreemSize.width * i , 20, WLGScreemSize.width , WLGScreemSize.height - 40)];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor redColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgArr[i]] placeholderImage:btn.currentBackgroundImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
            NSLog(@"%f",(CGFloat)receivedSize/expectedSize);
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
        }];

        [_arrImg addObject:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutImageView:)];
        [_imageView addGestureRecognizer:tap];
        [_scrollView addSubview:_imageView];
    }

//    UIButton *btn = [_sourceImagesContainerView subviews][_currentImageIndex];
    
    UIImageView *imgV = _arrImg[_currentImageIndex];
    
    
    
   
    //放大
    imgV.frame = [[_sourceImagesContainerView subviews][_currentImageIndex]  convertRect:[_sourceImagesContainerView subviews][_currentImageIndex].bounds toView:_scrollView];
    [UIView animateWithDuration:0.4 animations:^{
        
        //获取比例得到相对应的高度
        CGFloat height =  WLGScreemSize.width /  (imgV.image.size.width / imgV.image.size.height);
        
        _scrollView.contentSize = CGSizeMake(WLGScreemSize.width * _imageCount, height);

        
         imgV.frame = CGRectMake(WLGScreemSize.width *_currentImageIndex  , 20, WLGScreemSize.width  , MAX(height - 40, WLGScreemSize.height - 40));
         _scrollView.contentOffset=CGPointMake((WLGScreemSize.width)*_currentImageIndex, 0);
        
    } completion:^(BOOL finished) {
        
    
               [imgV sd_setImageWithURL:[NSURL URLWithString:_imgArr[_currentImageIndex]] placeholderImage:btn.currentBackgroundImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
            NSLog(@"%f",(CGFloat)receivedSize/expectedSize);
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                UILabel *label = [[UILabel alloc] init];
                label.bounds = CGRectMake(0, 0, 160, 30);
                label.center = CGPointMake(imgV.bounds.size.width * 0.5, imgV.bounds.size.height * 0.5);
                label.text = @"图片加载失败";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
                label.layer.cornerRadius = 5;
                label.clipsToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [imgV addSubview:label];
            }
            
        }];

        
    }];

    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];

    
}

//保存图片
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

//缩小
- (void)zoomOutImageView:(UITapGestureRecognizer *)tap
{
    _saveButton.hidden = YES;
    
    UIImageView *imgV = _arrImg[_currentImageIndex];
  NSArray *imga = [imgV subviews];
    if (imga.count != 0) {
        UILabel *label = imga[0];
        label.hidden = YES;
    }
    [UIView animateWithDuration:0.4 animations:^{
        
        imgV.frame = [[_sourceImagesContainerView subviews][_currentImageIndex] convertRect:[_sourceImagesContainerView subviews][_currentImageIndex].bounds toView:_scrollView];

        
        
        //        _fullimageView.frame = self.frame;
        
        _scrollView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        
        [self removeFromSuperview];
        
    }];
  
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / WLGScreemSize.width;
        NSLog(@"%d",index);
    _currentImageIndex = index;

    
    
}


@end
