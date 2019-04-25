//
//  ViewController.m
//  SpreadButton-IOS
//
//  Created by wxzhi on 2019/4/25.
//  Copyright © 2019 wxzhi. All rights reserved.
//

#import "ViewController.h"
#import "SpreadButton.h"

@interface ViewController ()
@property (nonatomic, strong) SpreadButton *spreadButton;
@end

#define NEWWEAKSELF __weak typeof(self) weakSelf = self;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSpreadBut];
}

/** 缩放按钮 */
- (void)showSpreadBut {
    if (!_spreadButton) {
        _spreadButton = [[SpreadButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 72, SCREEN_HEIGHT - 200, 53, 53)];
        [self.view addSubview:_spreadButton];
        
        _spreadButton.radius = 23;
        _spreadButton.itemsNum = 5;
        _spreadButton.alpha = 0;
//        _spreadButton.normalImage = [UIImage imageNamed:@"normalImage"];
//        _spreadButton.selImage = [UIImage imageNamed:@"selImage"];
//        _spreadButton.images = @[
//                                 @"image1",
//                                 @"image2",
//                                 @"image3",
//                                 @"image4",
//                                 @"image5"];
        
        [_spreadButton.spreadButton addTarget:self action:@selector(spreadButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NEWWEAKSELF
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.spreadButton.alpha = 1;
        }];
        
        //添加按钮选择操作
        [_spreadButton spreadButtonDidClickItemAtIndex:^(NSUInteger index) {
            NSLog(@"点击了 = %zd",index);
        }];
    } else {
        [_spreadButton setHidden:NO];
        _spreadButton.alpha = 1;
    }
}

- (void)spreadButtonDidClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == YES) {
        [_spreadButton spreadWithHandle:NULL];
    } else {
//        [self hiddenSpreadBut];
        [_spreadButton shrinkWithHandle:NULL];
    }
}


@end
