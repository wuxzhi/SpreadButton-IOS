//
//  SpreadButton.m
//  SpreadButton-IOS
//
//  Created by wxzhi on 16/11/28.
//  Copyright © 2016年 wxzhi. All rights reserved.
//

#import "SpreadButton.h"

typedef void(^spreadHandle)(NSUInteger index);
@interface SpreadButton ()
@property (nonatomic, copy) spreadHandle indexBlock;
@end

@implementation SpreadButton

- (instancetype)initWithCapacity:(NSUInteger)itemsNum {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.subItems = [self itemsArrFromGetItemsNum:itemsNum];
    return self;
}

+ (instancetype)spreadButtonWithCapacity:(NSUInteger)itemsNum {
    return [[self alloc] initWithCapacity:itemsNum];
}

- (NSArray *)itemsArrFromGetItemsNum:(NSUInteger)itemsNum {
    NSMutableArray *itemsArr = [NSMutableArray arrayWithCapacity:itemsNum];
    for (int i = 0; i < itemsNum; i++) {
        UIButton *item = [[UIButton alloc] init];
        item.backgroundColor = [UIColor blackColor];
        [item setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        item.tag = i;
        [itemsArr addObject:item];
        
        [item addTarget:self action:@selector(didClickButtonAtItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [itemsArr copy];
}

- (void)spreadButtonDidClickItemAtIndex:(void (^)(NSUInteger index))indexBlock {
    if (indexBlock) {
        self.indexBlock = indexBlock;
    }
}

/** 按钮点击方法 */
- (void)didClickButtonAtItem:(UIButton *)item {
    ![self.delegate respondsToSelector:@selector(spreadButton:didSelectedAtIndex:withSelButton:)] ?: [self.delegate spreadButton:self didSelectedAtIndex:item.tag withSelButton:item];
    !self.indexBlock ?: self.indexBlock(item.tag);
    [self shrinkWithHandle:NULL];
}

/**
 重写点击方法，解决按钮超出部分无法被点击的问题
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.isSpreading) {
        if (CGRectContainsPoint(self.bounds, point)) {
            return YES;
        }
        for (UIButton *btn in self.subItems) {
            if (CGRectContainsPoint(btn.frame, point)) {
                return YES;
            }
        }
        return NO;
    } else {
        return [super pointInside:point withEvent:event];
    }
}


#pragma mark - set
- (void)setItemsNum:(NSUInteger)itemsNum {
    _itemsNum = itemsNum;
    
    self.subItems = [self itemsArrFromGetItemsNum:itemsNum];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    for (int i = 0; i < images.count; i++) {
        UIButton *button = (UIButton *)self.subItems[i];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
    }
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [self.spreadButton setImage:normalImage forState:UIControlStateNormal];
}

- (void)setSelImage:(UIImage *)selImage {
    _selImage = selImage;
    [self.spreadButton setImage:selImage forState:UIControlStateSelected];
}

@end
