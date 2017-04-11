//
//  SZSMusicTool.h
//  QQMusic
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZSMusic;
@interface SZSMusicTool : NSObject
+(NSArray *)musics;
+(SZSMusic*)playingMusic;
+(void)setPlayingMusic:(SZSMusic *)playingMusic;
+(SZSMusic*)nextMusic;
+(SZSMusic*)previousMusic;
@end
