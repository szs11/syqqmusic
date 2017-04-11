//
//  SZScrView.m
//  QQMusic
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 SZS. All rights reserved.
//

#import "SZScrView.h"
#import "Masonry.h"
#import "SZSLrcCell.h"
#import "SZSLrcTool.h"
#import "SZSLrcline.h"
#import "SZSLrcLabel.h"
@interface SZScrView() <UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** 歌词的数据 */
@property (nonatomic, strong) NSArray *lrclist;

/** 当前播放的歌词的下标 */
@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation SZScrView

//- (id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setupTableView];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] init];
   // tableView.backgroundView = nil;
    
        [self addSubview:tableView];
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView = tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
    }];
      self.tableView.backgroundColor = [UIColor clearColor];
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.tableView.rowHeight = 35;

      self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        SZSLrcCell *cell = [SZSLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    }else{
            cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    
        SZSLrcline *lrcline = self.lrclist[indexPath.row];
    cell.lrcLabel.text = lrcline.text;

        return cell;
}

#pragma mark - 重写setLrcName方法
- (void)setLrcName:(NSString *)lrcName
{
    // 0.重置保存的当前位置的下标
    self.currentIndex = 0;
    
    // 1.保存歌词名称
    _lrcName = [lrcName copy];
    
    // 2.解析歌词
    self.lrclist = [SZSLrcTool lrcToolWithLrcName:lrcName];
    
    // 3.刷新表格
    [self.tableView reloadData];
    
}

#pragma mark - 重写setCurrentTime方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    // 用当前时间和歌词进行匹配
    NSInteger count = self.lrclist.count;
    for (int i = 0; i < count; i++) {
        // 1.拿到i位置的歌词
        SZSLrcline *currentLrcLine = self.lrclist[i];
        
        // 2.拿到下一句的歌词
        NSInteger nextIndex = i + 1;
        SZSLrcline *nextLrcLine = nil;
        if (nextIndex < count) {
            nextLrcLine = self.lrclist[nextIndex];
        }

        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath =[NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            self.currentIndex = i;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.lrcLabel.text = currentLrcLine.text;
        }
        
        if (self.currentIndex == i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            SZSLrcCell *cell = (SZSLrcCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            CGFloat progress = (currentTime - currentLrcLine.time)/(nextLrcLine.time - currentLrcLine.time);
            cell.lrcLabel.progress = progress;
            self.lrcLabel.progress = progress;
        }
        
    }
}

@end
