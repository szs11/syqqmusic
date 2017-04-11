//
//  SZSAudioTool.h
//  QQMusic
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SZSAudioTool : NSObject

#pragma mark - 播放音乐
// 播放音乐 musicName : 音乐的名称
+ (AVAudioPlayer*)playMusicWithMusicName:(NSString *)musicName;
// 暂停音乐 musicName : 音乐的名称
+ (void)pauseMusicWithMusicName:(NSString *)musicName;
// 停止音乐 musicName : 音乐的名称
+ (void)stopMusicWithMusicName:(NSString *)musicName;

#pragma mark - 音效播放
// 播放声音文件soundName : 音效文件的名称
+ (void)playSoundWithSoundname:(NSString *)soundname;

@end