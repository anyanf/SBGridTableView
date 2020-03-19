//
//  SBFormCollectionViewFlowLayout.m
//  SBUIKit
//
//  Created by 安康 on 2019/11/16.
//

#import "SBGridTableCollectionViewFlowLayout.h"

#import "SBCollectionViewLayoutAttributes.h"

@interface SBGridTableCollectionViewFlowLayout ()

/** 所有item的布局  */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *itemAttributes;
/** 一行里面所有item的宽，每一行都是一样的  */
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSValue *> *> *itemsSize;
/** collectionView的contentSize大小  */
@property (nonatomic, assign) CGSize contentSize;

@end


@implementation SBGridTableCollectionViewFlowLayout


#pragma mark - private
/**
 设置 行 里面的 item 的Size
 （每一列的宽度一样，所以只需要确定一行的item的宽度）
 */
- (void)calculateItemsSize{
    
    for (NSInteger section = 0; section<[self.collectionView numberOfSections]; section++) {
        NSMutableArray *sectionsSize = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            
            if ([_dataSource respondsToSelector:@selector(sizeForItemAtIndexPath:)]) {
                CGSize itemSize = [_dataSource sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
                [sectionsSize addObject:itemSizeValue];
            }
        }
        [self.itemsSize addObject:sectionsSize];
    }
}


/**
 每一个滚动都会走这里，去确定每一个item的位置
 */
- (void)prepareLayout {
    
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSUInteger column           = 0;//列
    CGFloat xOffset             = 0.0;//X方向的偏移量
    CGFloat yOffset             = 0.0;//Y方向的偏移量
    CGFloat contentWidth        = 0.0;//collectionView.contentSize的宽度
    CGFloat contentHeight       = 0.0;//collectionView.contentSize的高度
    
    
    if (self.itemAttributes.count > 0) {
        
        for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems        = [self.collectionView numberOfItemsInSection:section];
            
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                // 非锁定区域 不固定 直接过滤
                if (row >= self.suspendRowNum && section >= self.suspendSectionNum) {
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
                
                // 锁定行
                if (section <self.suspendSectionNum) {
                    
                    CGRect frame            = attributes.frame;
                    float offsetY           = 0;
                    if (index > 0) {
                        for (int y = 0; y < section; y++) {
                            offsetY +=  [self.itemsSize[y][row] CGSizeValue].height;
                        }
                    }
                    frame.origin.y          = self.collectionView.contentOffset.y + offsetY;
                    attributes.frame        = frame;
                }
                
                // 锁定列
                if (row < self.suspendRowNum) {
                    CGRect frame            = attributes.frame;
                    float offsetX           = 0;
                    if (index > 0) {
                        for (int i = 0; i < row; i++) {
                            offsetX +=  [self.itemsSize[section][i] CGSizeValue].width;
                        }
                    }
                    
                    frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                    attributes.frame = frame;
                }
            }
        }
        
        return;
    }
    
    // The following code is only executed the first time we prepare the layout
    self.itemAttributes                     = [@[] mutableCopy];
    self.itemsSize                          = [@[] mutableCopy];
    
    // Tip: If we don't know the number of columns we can call the following method and use the NSUInteger object instead of the NUMBEROFCOLUMNS macro
    // NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    // We calculate the item size of each column
    if (self.itemsSize.count != [self.collectionView numberOfSections]) {
        [self calculateItemsSize];
    }
    
    // We loop through all items
    for (NSInteger section = 0; section <  [self.collectionView numberOfSections]; section ++) {
        
        NSMutableArray *sectionAttributes   = [@[] mutableCopy];
        
        CGFloat maxSectionHeight = 0;
        
        for (NSUInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row++) {
            
            CGSize itemSize                 = [self.itemsSize[section][row] CGSizeValue];
            
            maxSectionHeight                = MAX(itemSize.height, maxSectionHeight);
            
            // We create the UICollectionViewLayoutAttributes object for each item and add it to our array.
            // We will use this later in layoutAttributesForItemAtIndexPath:
            NSIndexPath *indexPath          = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame                = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            if (section < self.suspendSectionNum && row < self.suspendRowNum) {
                // Set this value for the first item (Sec0Row0) in order to make it visible over first column and first row
                attributes.zIndex = 2015;
            }else if (section < self.suspendSectionNum || row < self.suspendRowNum) {
                // Set this value for the first row or section in order to set visible over the rest of the items
                attributes.zIndex = 2014;
            }
            
            if (section < self.suspendSectionNum) {
                
                CGRect frame                = attributes.frame;
                float offsetY               = 0;
                if (rindex > 0) {
                    for (int y = 0; y < section; y++) {
                        offsetY += [self.itemsSize[y][row] CGSizeValue].height;
                    }
                }
                frame.origin.y              = self.collectionView.contentOffset.y+offsetY;
                //                frame.origin.y = self.collectionView.contentOffset.y;
                
                attributes.frame            = frame; // Stick to the top
            }
            
            if (row < self.suspendRowNum) {
                
                CGRect frame                = attributes.frame;
                float offsetX               = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [self.itemsSize[section][i] CGSizeValue].width;
                    }
                }
                
                frame.origin.x              = self.collectionView.contentOffset.x + offsetX;
                attributes.frame            = frame; // Stick to the left
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset                         = xOffset + itemSize.width + self.minimumInteritemSpacing;
            column ++;
            
            // Create a new row if this was the last column
            if (column == [self.collectionView numberOfItemsInSection:section]) {
                
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // 重置基本变量
                column                      = 0;
                xOffset                     = 0;
                yOffset                     = yOffset + maxSectionHeight + self.minimumLineSpacing;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // 获取右下角最有一个item，确定collectionView的contentSize大小
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight                           = attributes.frame.origin.y + attributes.frame.size.height;
    _contentSize                            = CGSizeMake(contentWidth, contentHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [@[] mutableCopy];
    
    for (NSArray<UICollectionViewLayoutAttributes *> *section in self.itemAttributes) {
        
        // 只计算屏幕显示的
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject,
                                              NSDictionary *bindings) {
            CGRect frame = [evaluatedObject frame];
            return CGRectIntersectsRect(rect, frame);
        }];
        
        NSArray<UICollectionViewLayoutAttributes *> *sectionAttrs = [section filteredArrayUsingPredicate:predicate];
        
        [attributes addObjectsFromArray:sectionAttrs];
        
        
        if (sectionAttrs.count > 0) {
            // 装饰view
            if ([self.dataSource respondsToSelector:@selector(flowLayout:layoutAttributesForDecorationViewAtIndexPath:)]) {
                SBCollectionViewLayoutAttributes *decorationAttr = [self.dataSource flowLayout:self layoutAttributesForDecorationViewAtIndexPath:sectionAttrs.firstObject.indexPath];
                
                if (decorationAttr) {
                    [attributes addObject:decorationAttr];
                }
            }
        }

    }
    
    
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath {
    
    SBCollectionViewLayoutAttributes *attributes = [SBCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath: indexPath];

    NSArray<UICollectionViewLayoutAttributes *> *sectionAttrs = self.itemAttributes[indexPath.section];
    
    if (sectionAttrs.count == 0) {
        return nil;
    }
    
    CGRect attrFrame = CGRectZero;
    for (int i = 0; i < sectionAttrs.count; i++) {
        
        UICollectionViewLayoutAttributes *attributes = sectionAttrs[i];
        if (i == 0) {
            attrFrame.origin.x = attributes.frame.origin.x;
            attrFrame.origin.y = attributes.frame.origin.y;
        }
        
        if (i == sectionAttrs.count - 1) {
            attrFrame.size.width = CGRectGetMaxX(attributes.frame);
        }
        
        attrFrame.size.height = MAX(attrFrame.size.height, attributes.frame.size.height);
    }
    
    attributes.frame = attrFrame;
    attributes.zIndex -= 1;
    return attributes;
}


- (CGSize)collectionViewContentSize{
    return  _contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES; // Set this to YES to call prepareLayout on every scroll
}

- (void)reload{
    if (self.itemAttributes) {
        [self.itemAttributes removeAllObjects];
    }
    if (self.itemsSize) {
        [self.itemsSize removeAllObjects];
    }
}

@end
