//
//  SpreadComponentry.m
//  SpreadButton-IOS
//
//  Created by wxzhi on 16/11/28.
//  Copyright © 2016年 wxzhi. All rights reserved.
//

#import "SpreadComponentry.h"
NSString *     const SpreadAnimationKeyScale = @"transform.scale";
NSTimeInterval const ViscousityDuration = 0.15; // 粘滞动画时长控制
CGFloat        const BorderSpace = 18;
CGFloat        const SpreadDis = 65; //默认弹出距离
CGFloat        const AutoFitRadiousSpace = 0; // 自动适应items之间的弧度空隙
CGFloat        const RadiusStep = 5; // 递归变量递增值

@interface SpreadComponentry ()
@property (nonatomic, assign) CGSize spSize;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGFloat fixLength;
@end

@implementation SpreadComponentry
- (instancetype)initWithSubItems:(NSArray<UIView *> *)subItems {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.subItems = subItems;
    [self spreadBasicSetting];
    [self spreadViewSetting];
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self spreadBasicSetting];
    [self spreadViewSetting];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self spreadBasicSetting];
    [self spreadViewSetting];
    [self spreadGestureRecognizerSetting];
    
    return self;
}

#pragma mark !- end init

- (void)spreadBasicSetting {
    _duration = .12;
    _style = SpreadStylePop;
    _wannaToScaleSpreadButtonEffect = YES;
    _spreadButtonOpenViscousity = NO;
    _radius = 25;
    _wannaToClips = NO;
    _spreadDis = _fixLength = SpreadDis;
    _offsetAngle = 0;
    _autoAdjustToFitSubItemsPosition = NO;
}

- (void)spreadViewSetting {
    [self spreadButtonSetting];
}

- (void)spreadButtonSetting {
    self.spreadButton = [[UIButton alloc] init];
    self.spreadButton.backgroundColor = [UIColor yellowColor];
    self.spreadButton.transform = CGAffineTransformIdentity;
    [self addSubview:self.spreadButton];
    
//    [self.spreadButton addTarget:self action:@selector(spreadButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
}

// 按钮拖拽移动
- (void)spreadGestureRecognizerSetting {
    UIPanGestureRecognizer *spPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToSpread:)];
    [self addGestureRecognizer:spPan];
}

- (void)panToSpread:(UIPanGestureRecognizer *)pan {
    if (_isSpreading == YES) {
//        [self spreadButtonDidClick:self.spreadButton];
        return;
    }
    
    [self spreadButtonUnborderFuncationCalFrame];
    
    CGPoint p = [pan translationInView:self];
    self.transform = CGAffineTransformTranslate(self.transform, p.x, p.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    // frame 是在变化的
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        if (!_spreadButtonOpenViscousity) {
            return;
        }
        
        [self spreadButtonViscousityFuncationCalFrame];
        return;
    }
}


/**
 贴边功能
 */
- (void)spreadButtonUnborderFuncationCalFrame {
    CGFloat offset_x = self.frame.origin.x + self.frame.size.width - SCREEN_WIDTH;
    CGFloat offset_y = self.frame.origin.y + self.frame.size.height - SCREEN_HEIGHT;
    if (offset_x > 0) {
        self.frame = CGRectOffset(self.frame, -offset_x, 0);
    } else if (self.frame.origin.x < 0) {
        self.frame = CGRectOffset(self.frame, -self.frame.origin.x, 0);
    }
    
    if (offset_y > 0) {
        self.frame = CGRectOffset(self.frame, 0, -offset_y);
    } else if (self.frame.origin.y < 0) {
        self.frame = CGRectOffset(self.frame, 0, -self.frame.origin.y);
    }
}

/**
 开启粘滞功能
 */
- (void)spreadButtonViscousityFuncationCalFrame {
    CGRect rect = self.frame;
    CGFloat cx = rect.origin.x - SCREEN_WIDTH / 2;
    if (cx > 0) {
        [UIView animateWithDuration:ViscousityDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectOffset(self.frame, SCREEN_WIDTH - rect.origin.x - rect.size.width, 0);
        } completion:NULL];
    } else {
        [UIView animateWithDuration:ViscousityDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectOffset(self.frame,  -rect.origin.x, 0);
        } completion:NULL];
    }
}

- (void)didMoveToSuperview {
    _spSize = self.frame.size;
    
    self.spreadButton.frame = self.bounds;
    
    if (_spreadButtonOpenViscousity) {
        [self spreadButtonViscousityFuncationCalFrame];
    }
}

- (void)tapToTempView {
    [self shrinkWithHandle:^{
    }];
}

- (void)spreadScaleToSmallWithAnimated:(BOOL)animated {
    if (!animated) {
        return;
    }
    [self basicAnimationForSpreadButtonWithKeyPath:SpreadAnimationKeyScale fromValue:@1 toValue:@1];
}

- (void)spreadScaleToBigWithAnimated:(BOOL)animated {
    if (!animated) {
        return;
    }
    [self basicAnimationForSpreadButtonWithKeyPath:SpreadAnimationKeyScale fromValue:@1 toValue:@1];
}

- (void)basicAnimationForSpreadButtonWithKeyPath:(NSString *)keyPath fromValue:(id)v1 toValue:(id)v2 {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.duration = _duration;
    anim.fromValue = v1;
    anim.toValue = v2;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    [self.spreadButton.layer addAnimation:anim forKey:nil];
}

/**
 展开
 subItems
 radius
 1.弹出的角度
 2.弹出的距离
 3.初始的角度
 */
- (void)spreadWithHandle:(void (^)(void))handle {
    [self spreadScaleToSmallWithAnimated:_wannaToScaleSpreadButtonEffect];
    self.spreadButton.selected = YES;
    
    CGFloat angle_ = M_PI * 2;
    CGFloat sAngle = _offsetAngle; // 初始偏移
    _fixLength = SpreadDis; // 重置变量
    
    CGFloat averageAngle = [self autoCalSpreadDisWithStartAngle:&sAngle totalAngle:&angle_];// 平均角度
    
    for (int i = 0; i < self.subItems.count; i++) {
        UIView *subView = self.subItems[i];
        subView.frame = CGRectMake((_spSize.width / _radius * 2) / 2, (_spSize.height / _radius) / 2, _radius * 2, _radius * 2);
        subView.transform = CGAffineTransformMakeScale(0, 0);
        subView.alpha = 0;
        [self addSubview:subView];
        
        CGPoint p = [self calSubItemOffsetPointWithAverageAngle:i * averageAngle offsetAngle:sAngle];
        
        [UIView animateWithDuration:_duration delay:0.02 * i options:UIViewAnimationOptionCurveEaseIn animations:^{
            subView.transform = CGAffineTransformMakeScale(1, 1);
            subView.alpha = 1;
            subView.frame = CGRectOffset(subView.frame, p.x, -p.y);
        } completion:^(BOOL finished) {
            if (handle && i == 0) {
                handle();
            }
        }];
    }
    
    _isSpreading = YES;
}

/**
 * 收缩
 */
- (void)shrinkWithHandle:(void (^)(void))handle {
    [self spreadScaleToBigWithAnimated:_wannaToScaleSpreadButtonEffect];
    self.spreadButton.selected = NO;
    
    for (int i = 0; i < self.subItems.count; i++) {
        UIView *subView = self.subItems[i];
        
        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            subView.alpha = 0;
            subView.frame = CGRectMake((_spSize.width / _radius * 2) / 2, (_spSize.height / _radius) / 2, _radius * 2, _radius * 2);
            subView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            subView.transform = CGAffineTransformIdentity;
            [subView removeFromSuperview];
            if (handle && i == self.subItems.count - 1) {
                handle();
            }
        }];
    }
    
    _isSpreading = NO;
}

/**
 * 处理边缘情况
 */
- (BOOL)calInitialAngleWithTotalAngle:(CGFloat *)angle offsetAngle:(CGFloat *)sAngle {
    
    CGPoint cp = CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    // a1 item1偏移y轴的弧度
    // a2 itemn偏移x轴的弧度
    // at 偏移的角度
    // ac 多余的弧度
    CGFloat a1 = 0, a2 = 0, at = 0, ac = 0, l = _autoAdjustToFitSubItemsPosition? _fixLength : _spreadDis;
    CGFloat lmax = l + _radius + BorderSpace;
    
    if (cp.y < lmax) {
        a1 = acos((cp.y - lmax + l) / l);
        at = a1;
        ac = a1 * 2;
        
        if (SCREEN_WIDTH - lmax < cp.x) {
            a2 = acos((SCREEN_WIDTH - cp.x - lmax + l) / l);
            at = M_PI_2 + a2;
            ac = M_PI_2 + a1 + a2;
        }
        if (cp.x < lmax) {
            a2 = acos((cp.x - lmax + l) / l);
            ac = M_PI_2 + a1 + a2;
        }
        
        *sAngle += at;
        *angle -= ac;
        
        return YES;
    }
    
    if (SCREEN_HEIGHT - lmax < cp.y) {
        a1 = acos((SCREEN_HEIGHT - cp.y - lmax + l) / l);
        at = M_PI + a1;
        ac = a1 * 2;
        
        if (cp.x < lmax) {
            a2 = acos((cp.x - lmax + l) / l);
            at = M_PI_2 * 3 + a2;
            ac = M_PI_2 + a1 + a2;
        }
        if (SCREEN_WIDTH - lmax < cp.x) {
            a2 = acos((SCREEN_WIDTH - cp.x - lmax + l) / l);
            ac = M_PI_2 + a1 + a2;
        }
        
        *sAngle += at;
        *angle -= ac;
        
        return YES;
    }
    
    if (cp.x < lmax) {
        a2 = acos((cp.x - lmax + l) / l);
        at = M_PI_2 * 3 + a2;
        ac = 2 * a2;
        
        if (cp.y < lmax) {
            a1 = acos((cp.y - lmax + l) / l);
            at = a1;
            ac = M_PI_2 + a1 + a2;
        }
        if (SCREEN_HEIGHT - lmax < cp.y) {
            a1 = acos((SCREEN_HEIGHT - cp.y - lmax + l) / l);
            ac = M_PI_2 + a1 + a2;
        }
        
        *sAngle += at;
        *angle -= ac;
        
        return YES;
    }
    
    if (SCREEN_WIDTH - lmax < cp.x) {
        a2 = acos((SCREEN_WIDTH - cp.x - lmax + l) / l);
        at = M_PI_2 + a2;
        ac = 2 * a2;
        
        if (SCREEN_HEIGHT - lmax < cp.y) {
            a1 = acos((SCREEN_HEIGHT - cp.y - lmax + l) / l);
            ac = M_PI_2 + a1 + a2;
        }
        if (cp.y < lmax) {
            a1 = acos((cp.y - lmax + l) / l);
            ac = M_PI_2 + a1 + a2;
        }
        
        *sAngle += at;
        *angle  -= ac;
        
        return YES;
    }
    
    return NO;
}

- (CGPoint)calSubItemOffsetPointWithAverageAngle:(CGFloat)a1 offsetAngle:(CGFloat)a2 {
    CGFloat a = a1 + a2,l = _autoAdjustToFitSubItemsPosition? _fixLength : _spreadDis; // 角度
    CGPoint p = CGPointZero;
    
    p.x = l * sin(a);
    p.y = l * cos(a);
    
    return p;
}

/**
 自动调整弹出距离
 */
- (CGFloat)autoCalSpreadDisWithStartAngle:(CGFloat *)sAngle totalAngle:(CGFloat *)tAngle {
    BOOL on = [self calInitialAngleWithTotalAngle:tAngle offsetAngle:sAngle];
    CGFloat aAngle = *tAngle / (on? (self.subItems.count - 1) : self.subItems.count);
    
    if (_autoAdjustToFitSubItemsPosition) {
        CGFloat rl = 2 * M_SQRT2 * _radius + AutoFitRadiousSpace;
        if (aAngle * _fixLength < rl) {
            _fixLength += RadiusStep;
            *sAngle = _offsetAngle;
            *tAngle = M_PI * 2;
            return [self autoCalSpreadDisWithStartAngle:sAngle totalAngle:tAngle];
        }
    }
    return aAngle;
}

- (void)calAutoFixOffsetAngle:(CGFloat *)sAngle totalAngle:(CGFloat *)angle {
    CGPoint cp = CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
    
    CGFloat lmax = _fixLength + _radius + BorderSpace;
    if (cp.y < lmax) {
        CGFloat a = acos((cp.y - _radius - BorderSpace) / _fixLength) - *sAngle;
        *sAngle += a;
        *angle  -= 2 * a;
    }
}

- (void)setSpreadButtonOpenViscousity:(BOOL)spreadButtonOpenViscousity {
    _spreadButtonOpenViscousity = spreadButtonOpenViscousity;
    
    if (!spreadButtonOpenViscousity) {
        return;
    }
    [self spreadButtonViscousityFuncationCalFrame];
}

- (void)setWannaToClips:(BOOL)wannaToClips {
    _wannaToClips = wannaToClips;
    
    if (!_wannaToClips) {
        return;
    }
    
    for (UIView *subView in self.subItems) {
        subView.layer.cornerRadius = _radius;
        subView.clipsToBounds = wannaToClips;
    }
}

- (void)setSpreadDis:(CGFloat)spreadDis {
    if (_autoAdjustToFitSubItemsPosition) {
        return;
    }
    _spreadDis = spreadDis;
}


@end
