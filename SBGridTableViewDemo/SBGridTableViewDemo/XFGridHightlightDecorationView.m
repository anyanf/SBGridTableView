//
//  XFGridHightlightDecorationView.m
//  SBGridTableViewDemo
//
//  Created by 安康 on 2020/3/19.
//  Copyright © 2020 安康. All rights reserved.
//

#import "XFGridHightlightDecorationView.h"

#import "SBCollectionViewLayoutAttributes.h"


@implementation XFGridHightlightDecorationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        

    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes isKindOfClass:SBCollectionViewLayoutAttributes.class]) {
        
//        if (self.layer.animationKeys > 0) {
//            return;
//        }
        
        SBCollectionViewLayoutAttributes *attr = (SBCollectionViewLayoutAttributes *)layoutAttributes;
        NSIndexPath *index = attr.model;
        NSLog(@"section = %zu, row = %zu", index.section, index.row);
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        animation.fromValue=(__bridge id _Nullable)(UIColor.whiteColor.CGColor);
        animation.toValue=(__bridge id _Nullable)(UIColor.redColor.CGColor);
        animation.autoreverses=NO;
        animation.duration=2;
        animation.repeatCount=0;
        animation.removedOnCompletion=YES;
        animation.fillMode=kCAFillModeRemoved;
        
        [self.layer addAnimation:animation forKey:@"backgroundColor"];
    }
}

@end
