//
//  SZScrView.h
//  QQMusic
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZSLrcLabel;
@interface SZScrView : UIScrollView
@property (nonatomic,copy)NSString *lrcName;

@property (nonatomic,assign)NSTimeInterval currentTime;
@property (nonatomic,weak)SZSLrcLabel *lrcLabel;
@end
