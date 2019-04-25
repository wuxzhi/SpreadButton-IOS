//
//  SpreadComponentry.h
//  SpreadButton-IOS
//
//  Created by wxzhi on 16/11/28.
//  Copyright © 2016年 wxzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SpreadStyle) {
    SpreadStylePop,   // 弹出
    SpreadStyleShape, // 扇形
};

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface SpreadComponentry : UIView
@property (nonatomic, strong) UIButton *spreadButton;
/** 开启按钮缩放 */
@property (nonatomic, assign) BOOL wannaToScaleSpreadButtonEffect;
@property (nonatomic, assign) SpreadStyle style;
@property (nonatomic, strong) NSArray <UIView *> *subItems;
@property (nonatomic, assign) NSTimeInterval duration;
/** 开启粘滞功能 */
@property (nonatomic, assign) BOOL spreadButtonOpenViscousity;
/** 弹出btn半径 default:70*/
@property (nonatomic, assign) CGFloat radius;
/** 切圆 */
@property (nonatomic, assign) BOOL wannaToClips;
/** 偏移角度,默认0,90度方向开始展开*/
@property (nonatomic, assign) CGFloat offsetAngle;
/** 自动适配subItems的位置 #NO*/
@property (nonatomic, assign) BOOL autoAdjustToFitSubItemsPosition;
/** 弹开的距离, 需要设置autoAdjustToFitSubItemsPosition = NO*/
@property (nonatomic, assign) CGFloat spreadDis;
/** 是否是展开状态*/
@property (nonatomic, assign) BOOL isSpreading;
- (instancetype)initWithSubItems:(NSArray <UIView *> *)subItems;
- (void)spreadWithHandle:(void(^)(void))handle;
- (void)shrinkWithHandle:(void(^)(void))handle;
@end
