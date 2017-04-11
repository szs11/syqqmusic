//
//  SZSLrcCell.h
//  QQMusic
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZSLrcLabel;

@interface SZSLrcCell : UITableViewCell
@property (nonatomic, weak, readonly) SZSLrcLabel *lrcLabel;

+(instancetype)lrcCellWithTableView:(UITableView *)tableView;
@end
