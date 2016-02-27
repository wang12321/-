//
//  TableViewCell.h
//  TPLLQ
//
//  Created by 汪利钢 on 16/2/27.
//  Copyright © 2016年 汪利钢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "WLGView.h"

@interface TableViewCell : UITableViewCell<WLGPhotoBrowserDelegate>
{
    UIView *bgview;
    WLGView *browser;
}
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSArray* srcStringArray;
@property(nonatomic,strong)NSArray* srcStringArray1;

@end
