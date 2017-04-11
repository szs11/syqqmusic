//
//  SZSPlayingViewController.m
//  QQMusic
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 SZS. All rights reserved.
//
#import "SZSPlayingViewController.h"
#import "Masonry.h"
#import "SZSMusicTool.h"
#import "SZSMusic.h"
#import "SZSAudioTool.h"
#import "CALayer+PauseAimate.h"
#import "NSString+SZS.h"
#import "SZScrView.h"
#import "SZSLrcLabel.h"

#define XMGColor(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface SZSPlayingViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet SZScrView *lrcView;
@property (weak, nonatomic) IBOutlet SZSLrcLabel *lrcLabel;

// 滑块
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (nonatomic,strong)NSTimer *progressTimer;
@property (nonatomic ,strong)CADisplayLink *licTimer;

@property (nonatomic ,strong) AVAudioPlayer *currentPlayer;
- (IBAction)startSider;
- (IBAction)siderValueChange:(id)sender;
- (IBAction)endSider:(id)sender;
- (IBAction)playofpause;
- (IBAction)previous;
- (IBAction)next;
- (IBAction)siderClick:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@end

@implementation SZSPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.添加毛玻璃效果
    [self setupBlurView];
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    [self startPlayingMusic];
    
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width*2, 0);
    self.lrcView.lrcLabel = self.lrcLabel;
  }


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width *0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 8.0;
    self.iconView.layer.borderColor = XMGColor(36, 36, 36).CGColor;

}


- (void)setupBlurView{

    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar setBarStyle:UIBarStyleBlack];
    [self.albumView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumView.mas_top);
        make.bottom.equalTo(self.albumView.mas_bottom);
        make.right.equalTo(self.albumView.mas_right);
        make.left.equalTo(self.albumView.mas_left);
    }];
    
    
}

 
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)startPlayingMusic{
  
   //1.取出当前播放歌曲
    SZSMusic *playingMusic = [SZSMusicTool playingMusic];
    
    //2.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    AVAudioPlayer *currentPlayer = [SZSAudioTool playMusicWithMusicName:playingMusic.filename];
    self.totalTimeLabel.text =  [NSString stringWithTime:currentPlayer.duration];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.currentPlayer = currentPlayer;
    self.playOrPauseBtn.selected = self.currentPlayer.isPlaying;
    
    self.lrcView.lrcName = playingMusic.lrcname;
    
    [self startIconViewAnimate];
    [self removeProgressTimer];
    
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLicTimer];
    
}

- (void)startIconViewAnimate{
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.fromValue = @(0);
    rotateAnim.toValue = @(M_PI *2);
    rotateAnim.repeatCount = NSIntegerMax;
    rotateAnim.duration = 30;
    
    [self.iconView.layer addAnimation:rotateAnim forKey:nil];
    

}

-(void)addProgressTimer{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];

}

-(void)removeProgressTimer{

    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
}

- (void)addLicTimer{

    self.licTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.licTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer{

    [self.licTimer invalidate];
    self.licTimer= nil;

}

- (void)updateProgressInfo{

    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.progressSlider.value = self.currentPlayer.currentTime/self.currentPlayer.duration;
    
}

- (void)updateLrc{

    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

- (IBAction)startSider {
    [self removeProgressTimer];
}

- (IBAction)siderValueChange:(id)sender {
    self.currentTimeLabel.text = [NSString stringWithTime: self.currentPlayer.duration *self.progressSlider.value ];
    
}

- (IBAction)endSider:(id)sender {
    
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    [self addProgressTimer];
    
}

- (IBAction)playofpause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if (self.currentPlayer.playing) {
        [self.currentPlayer pause];
        [self removeProgressTimer];
        [self.iconView.layer pauseAnimate];
    } else{
        [self.currentPlayer play];
        [self addProgressTimer];
        [self.iconView.layer resumeAnimate];
    }
    
}

- (IBAction)previous {
    SZSMusic *previousMusic = [SZSMusicTool previousMusic];
    [self playingMusicWithMusic:previousMusic];
}

- (IBAction)next {
    SZSMusic *nextMusic = [SZSMusicTool nextMusic];
    [self playingMusicWithMusic:nextMusic];
}

- (void)playingMusicWithMusic:(SZSMusic*)music{

    SZSMusic *playingMusic = [SZSMusicTool playingMusic];
    [SZSAudioTool stopMusicWithMusicName:playingMusic.filename];
    
    [SZSAudioTool playMusicWithMusicName:music.filename];
    [SZSMusicTool setPlayingMusic:music];
    
    [self startPlayingMusic];


}


- (IBAction)siderClick:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    self.progressSlider.value = ratio;
    
    self.currentPlayer.currentTime = ratio * self.currentPlayer.duration;
    
    [self updateProgressInfo];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     CGPoint point = scrollView.contentOffset;
     CGFloat ratio = 1 - point.x / scrollView.bounds.size.width;
     self.iconView.alpha = ratio;
     self.lrcLabel.alpha = ratio;

}
@end
