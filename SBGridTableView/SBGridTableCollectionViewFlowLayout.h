//
//  SBFormCollectionViewFlowLayout.h
//  SBUIKit
//
//  Created by 安康 on 2019/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SBGridTableCollectionViewFlowLayout;
@class SBCollectionViewLayoutAttributes;

@protocol SBGridTableCollectionViewFlowLayoutDataSource <NSObject>

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (nullable SBCollectionViewLayoutAttributes *)flowLayout:(SBGridTableCollectionViewFlowLayout *)flowLayout layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SBGridTableCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 需要灵活item 尺寸 就需要遵守
 */
@property (nonatomic, weak) id<SBGridTableCollectionViewFlowLayoutDataSource> dataSource;


/**
 锁定行数
 */
@property (nonatomic, assign)NSInteger suspendRowNum;


/**
 锁定列数
 */
@property (nonatomic, assign)NSInteger suspendSectionNum;



- (void)reload;

@end

NS_ASSUME_NONNULL_END
