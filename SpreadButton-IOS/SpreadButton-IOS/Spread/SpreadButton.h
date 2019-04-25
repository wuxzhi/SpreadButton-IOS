//
//  SpreadButton.h
//  SpreadButton-IOS
//
//  Created by wxzhi on 16/11/28.
//  Copyright © 2016年 wxzhi. All rights reserved.
//

#import "SpreadComponentry.h"

@protocol SpreadButtonDelegate;
@interface SpreadButton : SpreadComponentry
@property (nonatomic, assign) id <SpreadButtonDelegate> delegate;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selImage;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSUInteger itemsNum;

+ (instancetype)spreadButtonWithCapacity:(NSUInteger)itemsNum;
- (void)spreadButtonDidClickItemAtIndex:(void(^)(NSUInteger index))indexBlock;
@end

@protocol SpreadButtonDelegate <NSObject>
@optional
- (void)spreadButton:(SpreadButton *)spreadButton didSelectedAtIndex:(NSUInteger)index withSelButton:(UIButton *)button;
@end
