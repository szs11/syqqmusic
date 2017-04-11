//
//  SZSLrcline.h
//  QQMusic
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZSLrcline : NSObject
@property (nonatomic,copy) NSString *text;
@property (nonatomic ,assign)NSTimeInterval time;

- (instancetype)initWithLrclineString:(NSString*)lrclineString;
+(instancetype)lrcLineWithLrclineString:(NSString*)lrclineString;
@end
