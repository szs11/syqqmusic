//
//  SZSLrcLabel.m
//  QQMusic
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import "SZSLrcLabel.h"

@implementation SZSLrcLabel


-(void)setProgress:(CGFloat)progress {

    _progress = progress;
    [self setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
    [[UIColor redColor] set];
    //UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
    
}


@end
