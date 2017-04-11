//
//  NSString+SZS.m
//  QQMusic
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import "NSString+SZS.h"

@implementation NSString (SZS)
+ (NSString *)stringWithTime:(NSTimeInterval)time{
    
    NSInteger min = time/60;
    NSInteger second = (NSInteger)time %60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,second];
}

@end
