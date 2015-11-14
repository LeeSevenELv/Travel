//
//  ScrollAdv.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ScrollAdv.h"
#import "ModelImageView.h"

@interface ScrollAdv()<UICollectionViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;

@end

@implementation ScrollAdv 

- (instancetype)initFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)showDataWithImages:(NSMutableArray *)images model:(NSArray *)models titles:(NSArray *)titles handle:(HandleType)handle {
    
    self.handle = handle;
    @synchronized(self) {
        if (self.scrollView == nil) {
            self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
            self.scrollView.backgroundColor = [UIColor whiteColor];
            self.scrollView.pagingEnabled = YES;
            self.scrollView.delegate = self;
            
            if (self.pageControlHeight == 0) {
                self.pageControlHeight = 20;
            }
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.pageControlHeight, self.frame.size.width, self.pageControlHeight)];
            self.pageControl.enabled = NO;
            [self addSubview:self.scrollView];
            [self addSubview:self.pageControl];
        }
    }
    self.pageControl.numberOfPages = images.count;
    while (self.scrollView.subviews.count) {
        ModelImageView *imageView = [self.scrollView.subviews lastObject];
        [imageView sd_cancelCurrentAnimationImagesLoad];
        [imageView removeFromSuperview];
    }
    if (images.count == models.count && images.count > 1) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        NSString *url = images[images.count - 1];
        ModelImageView *imageView = [[ModelImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        CGSize size = imageView.frame.size;
        if (titles.count == images.count) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (size.height-30)/2, size.width, 30)];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titles[images.count - 1];
            [imageView addSubview:label];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        imageView.model = models[images.count - 1];
        [self.scrollView addSubview:imageView];
        
        for (NSInteger i = 0; i < images.count; i++) {
            NSString *url = images[i];
            ModelImageView *imageView = [[ModelImageView alloc] initWithFrame:CGRectMake((i+1)*width, 0, width, height)];
            CGSize size = imageView.frame.size;
            if (titles.count == images.count) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (size.height - 30)/2, width, 30)];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = titles[i];
                [imageView addSubview:label];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            imageView.model = models[i];
            [self.scrollView addSubview:imageView];
        }
        
        //添加尾部imageView
        {
            NSString *url = images[0];
            ModelImageView *imageView = [[ModelImageView alloc] initWithFrame:CGRectMake((images.count+1)*width, 0, width, height)];
            //TWidth += width;
            CGSize size = imageView.frame.size;
            if (titles.count == images.count) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (size.height-30)/2.0, size.width, 30)];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = titles[0];
                [imageView addSubview:label];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            imageView.model = models[0];
            [self.scrollView addSubview:imageView];
        }
        
        self.scrollView.contentSize = CGSizeMake(width*(2+images.count), height);
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.handle) {
        ModelImageView *imageView = (ModelImageView *)tap.view;
        self.handle(imageView.model);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSInteger pageCount = scrollView.contentSize.width/scrollView.frame.size.width;
    if (currentPage == 0) {
        [self.scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 2*scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = pageCount - 2;
    } else if (currentPage == pageCount - 1) {
        [self.scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}




@end
