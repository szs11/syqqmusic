//
//  SZSMusicTool.m
//  QQMusic
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 SZS. All rights reserved.
//
#import "SZSMusicTool.h"
#import "MJExtension.h"
#import "SZSMusic.h"

@implementation SZSMusicTool

static NSArray *_musice;
static SZSMusic *_playingMusic;
+(void)initialize{
    if (_musice == nil) {
    _musice = [SZSMusic objectArrayWithFilename:@"Musics.plist"];
   }
    
    if (_playingMusic == nil) {
        _playingMusic = _musice[1];
    }
}


+(NSArray *)musics{
    
    return _musice;
    
}

+(SZSMusic *)playingMusic{

    return _playingMusic;
}

+(void)setPlayingMusic:(SZSMusic *)playingMusic{
    _playingMusic = playingMusic;

}

+(SZSMusic*)nextMusic{

  //1.拿到当前播放歌曲的索引
    NSInteger currentIndex = [_musice indexOfObject:_playingMusic];
  //2.取出下一首歌
    NSInteger nextIndex = ++currentIndex;
    
    if (nextIndex>=_musice.count) {
        nextIndex = 0;
    }
    SZSMusic *nextMusic = _musice[nextIndex];
    
    return nextMusic;
}

+(SZSMusic*)previousMusic{
    
    //1.拿到当前播放歌曲的索引
    NSInteger currentIndex = [_musice indexOfObject:_playingMusic];
    //2.取出下一首歌
    NSInteger nextIndex = --currentIndex;
    
    if (nextIndex<0) {
        nextIndex = _musice.count-1;
    }
    SZSMusic *previousMusic = _musice[nextIndex];
    
    return previousMusic;


}

@end
