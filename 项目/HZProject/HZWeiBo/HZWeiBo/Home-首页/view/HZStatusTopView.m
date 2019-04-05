//
//  HZStatusTopView.m
//  HZWeiBo
//
//  Created by 华天杰 on 2018/10/15.
//  Copyright © 2018年 BQ. All rights reserved.
//

#import "HZStatusTopView.h"
#import "HZStatus.h"
#import "HZStatusFrame.h"
#import "HZUser.h"
#import <UIImageView+WebCache.h>
#import "HZRetweetStatusView.h"
#import "HZPhoto.h"
#import "HZPhotoView.h"
#import "HZPhotosView.h"
#import "UIImage+HZ.h"

@interface HZStatusTopView()
/** 原创微博头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 原创微博昵称 */
@property (nonatomic, weak) UIButton *nameBtn;
/** 原创微博vip */
@property (nonatomic, weak) UIImageView *vipView;
/** 原创微博时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 原创微博来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 原创微博正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 原创微博配图 */
@property (nonatomic, weak) HZPhotosView *photosView;

/** 转发微博父控件 */
@property (nonatomic, weak) HZRetweetStatusView *retweetView;
@end

@implementation HZStatusTopView

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        // 1. 头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 2. 昵称
        UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nameBtn.titleLabel.font = [UIFont systemFontOfSize:HZStatusNameFont];
        [self addSubview:nameBtn];
        self.nameBtn = nameBtn;
        
        // 3. 会员图标
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [self addSubview:vipView];
        self.vipView = vipView;
        
        // 4. 时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:HZStatusTimeFont];
        timeLabel.textColor = RGBColor(135, 135, 135);
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 5. 来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = [UIFont systemFontOfSize:HZStatusSourceFont];
        sourceLabel.textColor = RGBColor(135, 135, 135);
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 6. 正文
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:HZStatusContentFont];
        contentLabel.textColor = RGBColor(35, 35, 35);
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 7. 配图
        HZPhotosView *photosView = [[HZPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
        
        // 8. 初始化转发微博
        [self setupRetweetStatus];
    }
    return self;
}

/**
 *  初始化转发微博
 */
- (void)setupRetweetStatus
{
    HZRetweetStatusView *retweetView = [[HZRetweetStatusView alloc] init];
    [self addSubview:retweetView];
    self.retweetView = retweetView;
}

#pragma mark - 设置数据

- (void)setStatusFrame:(HZStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    HZStatus *status = statusFrame.status;
    HZUser *user = status.user;
    
    // 头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url]
                     placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.iconView.frame = statusFrame.iconViewF;
    
    // 昵称
    [self.nameBtn setTitle:status.user.name forState:UIControlStateNormal];
    self.nameBtn.frame = statusFrame.nameBtnF;
    
    // vip
    if (status.user.mbtype > 0) {
        self.vipView.hidden = NO;
        NSString *name = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:name];
        self.vipView.frame = statusFrame.vipViewF;
        
        [self.nameBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    } else {
        self.vipView.hidden = YES;
        
        [self.nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    // 时间
    self.timeLabel.text = status.created_at;
    CGFloat timeX = self.statusFrame.nameBtnF.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.statusFrame.nameBtnF) +  HZStatusPadding * 0.5;
    CGSize timeSize = [status.created_at sizeWithFont:[UIFont systemFontOfSize: HZStatusTimeFont]];
    self.timeLabel.frame = (CGRect){timeX, timeY, timeSize};
    
    // 来源
    self.sourceLabel.text = status.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) +  HZStatusPadding * 0.5;
    CGFloat sourceY = self.statusFrame.timeLabelF.origin.y;
    CGSize sourceSize = [status.source sizeWithFont:[UIFont systemFontOfSize: HZStatusSourceFont]];
    self.sourceLabel.frame = (CGRect){sourceX, sourceY, sourceSize};
    
    // 正文
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    // 配图
    if (status.pic_urls.count) {
        self.photosView.hidden = NO;
        
        self.photosView.photos = status.pic_urls;
        
        self.photosView.frame = statusFrame.photoViewF;
    } else {
        self.photosView.hidden = YES;
    }
    
#warning 测试账号id
    if ([user.idstr isEqualToString:@"5390775469"]) {
        [self.nameBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    // 设置转发微博数据和frame
    [self setupRetweetData];
}

/**
 *  设置转发微博数据和frame
 */
- (void)setupRetweetData
{
     HZStatusFrame *statusFrame = self.statusFrame;
     HZStatus *status = statusFrame.status;
    
    // 转发微博
    if (status.retweeted_status) {
        self.retweetView.hidden = NO;
        self.retweetView.frame = statusFrame.retweetViewF;
        
        // 传递模型数据
        self.retweetView.statusFrame = statusFrame;
    } else {
        self.retweetView.hidden = YES;
    }
}

@end
