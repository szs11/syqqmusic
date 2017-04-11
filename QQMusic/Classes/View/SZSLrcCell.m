//
//  SZSLrcCell.m
//  QQMusic
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import "SZSLrcCell.h"
#import "SZSLrcLabel.h"
#import "Masonry.h"
@implementation SZSLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        SZSLrcLabel *lrcLabel = [[SZSLrcLabel alloc] init];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.font = [UIFont systemFontOfSize:14.0];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lrcLabel];
        _lrcLabel = lrcLabel;
        lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

+(instancetype)lrcCellWithTableView:(UITableView *)tableView{

    static NSString *ID = @"LrcCell";
    SZSLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SZSLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;

}
@end
