//
//  SBCollectionViewCell.m
//  SBGridTableViewDemo
//
//  Created by 安康 on 2020/3/18.
//  Copyright © 2020 安康. All rights reserved.
//

#import "SBCollectionViewCell.h"

@interface SBCollectionViewCell ()


@end

@implementation SBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.grayColor;
        
        _lbl = [[UILabel alloc] initWithFrame:self.bounds];
        _lbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lbl];
        
    }
    return self;
}

@end
