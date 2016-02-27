//
//  TableViewCell.m
//  TPLLQ
//
//  Created by 汪利钢 on 16/2/27.
//  Copyright © 2016年 汪利钢. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self initcell];

    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
    }
    [self initcell];

}
-(void)initcell{
    bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 375 - 40, 200 - 40)];
//    bgview.tag = _indexPath.row;
    //    [arr addObject:bgview];
    [self.contentView addSubview:bgview];
    for (int i = 0; i < 3; i++) {
        UIButton* _cyhImgV = [[UIButton alloc]initWithFrame:CGRectZero];
        _cyhImgV.frame = CGRectMake((335 - 20) / 3 * i + 10 * i, 0, (335 - 20) / 3 , 80);
        _cyhImgV.tag = i + 100;
        [_cyhImgV addTarget:self action:@selector(buttonpol:) forControlEvents:UIControlEventTouchUpInside];
        [_cyhImgV sd_setBackgroundImageWithURL:[NSURL URLWithString:_srcStringArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
        [bgview addSubview:_cyhImgV];
    }
    

}

-(void)buttonpol:(UIButton *)btn{
    
    
    browser = [[WLGView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    
    browser.sourceImagesContainerView = bgview; // 原图的父控件
    browser.currentImageIndex = (int)btn.tag - 100;
    browser.imgArr = _srcStringArray1 ;
    browser.imageCount = _srcStringArray.count; // 图片总数
    NSLog(@"%ld",(long)btn.tag);
    browser.delegate = self;
    [browser show];
}

- (UIImage *)photoBrowser:(WLGView *)browser placeholderImageForIndex:(NSInteger)index{
    return nil;
}



- (NSURL *)photoBrowser:(WLGView *)browser highQualityImageURLForIndex:(NSInteger)index{
    return nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
