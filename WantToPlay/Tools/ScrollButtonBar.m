//
//  ScrollButtonBar.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ScrollButtonBar.h"
#define kColor [UIColor orangeColor]

@interface ScrollButtonBar()

@property (nonatomic, copy) BlockType myBlock;
@property (nonatomic) UIView *line;
@property (nonatomic) UIButton *lastButton;

@end
@implementation ScrollButtonBar

- (instancetype)initWithTitles:(NSArray *)titles viewFrame:(CGRect)frame handle:(BlockType)handle {
    
    CGFloat buttonWidth = 60;
    CGFloat selfHeight = frame.size.height;
    CGFloat lineHeight = 3;
    
    
    if (self = [super initWithFrame:frame]) {
        self.myBlock = handle;
        
        self.backgroundColor = [UIColor whiteColor];
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, selfHeight - lineHeight, buttonWidth, lineHeight)];
        _line.backgroundColor = kColor;
        [self addSubview:_line];
        
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:kColor forState:UIControlStateSelected];
            [button setTintColor:[UIColor clearColor]];
            if (i == 0) {
                _lastButton = button;
                button.selected = YES;
            }
            
            button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, selfHeight - lineHeight);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(buttonWidth*titles.count, 0);
    
    return self;
}
- (void)buttonClick:(UIButton *)button {
    if (button == _lastButton) return;
    
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    
    CGRect lineFrame = _line.frame;
    lineFrame.origin.x = button.frame.origin.x;
    _line.frame = lineFrame;
    
    if (_myBlock) _myBlock(button);
}


@end
