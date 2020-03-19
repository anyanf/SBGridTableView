//
//  SBGridTableView.h
//  SBUIKit
//
//  Created by 安康 on 2019/11/16.
//

#import <UIKit/UIKit.h>

#import "SBGridTableCollectionViewFlowLayout.h"
#import "SBCollectionViewLayoutAttributes.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SBGridTableViewType) {
    SBGridTableViewTypeSectionAndRowFixation,    //  行列固定
    SBGridTableViewTypeOnlySectionFixation,      // 行固定
    SBGridTableViewTypeOnlyRowFixation,          // 列固定
    SBGridTableViewTypeNoFixation                // 无固定
};


typedef NS_ENUM(NSUInteger, SBGridTableViewCellType) {
    SBGridTableViewCellTypeMain,           // 非悬浮主区域
    SBGridTableViewCellTypeSuspendRow,     // 悬浮列区域
    SBGridTableViewCellTypeSuspendSection  // 悬浮行区域
};


@class SBGridTableView;

@interface SBGridTableViewIndexPath : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) SBGridTableViewCellType cellType;

@end


@protocol SBGridTableViewDataSource <NSObject>

@required

- (NSInteger)gridTableView:(SBGridTableView *)gridTableView
    numberOfItemsInSection:(NSInteger)section;

/** cell for item  */
- (UICollectionViewCell *)gridTableView:(SBGridTableView *)gridTableView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
                               cellType:(SBGridTableViewCellType)cellType;

/**
 对应item尺寸大小
 */
- (CGSize)gridTableView:(SBGridTableView *)gridTableView
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               cellType:(SBGridTableViewCellType)cellType;


/**
 总列数量 默认为1
 */
- (NSInteger)numberOfSectionsInGridTableView:(SBGridTableView *)gridTableView;

@optional

/**
 悬浮锁定列数
 */
- (NSInteger)numberOfSuspendSectionsInGridTableView:(SBGridTableView *)gridTableView;


/**
 悬浮锁定行数

 @param gridTableView 当前对象
 @param section 第几列
 @return 行数
 */
- (NSInteger)gridTableView:(SBGridTableView *)gridTableView numberOfSuspendItemsInSection:(NSInteger)section;


/** cell点击 */
- (void)gridTableView:(SBGridTableView *)gridTableView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                  cellType:(SBGridTableViewCellType)cellType;


/** cell长按 */
- (void)gridTableView:(SBGridTableView *)gridTableView
  didLongPressItemAtIndexPath:(NSIndexPath *)indexPath
                     cellType:(SBGridTableViewCellType)cellType;

/** 滚动 */
- (void)gridTableViewDidScroll:(SBGridTableView *)gridTableView;

/** 停止滚动时 */
- (void)gridTableViewDidEndScroll:(SBGridTableView *)gridTableView;

/** 通过layout获取指定indexpath的layoutAttributes */
- (nullable SBCollectionViewLayoutAttributes *)gridTableView:(SBGridTableView *)gridTableView
                layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath
                                                    cellType:(SBGridTableViewCellType)cellType;


@end


/** 表格控件 */
@interface SBGridTableView : UIView

@property(nonatomic)         CGPoint                      contentOffset;                  // default CGPointZero
@property(nonatomic)         CGSize                       contentSize;                    // default CGSizeZero
// default YES. if YES, bounces past edge of content and back again
@property(nonatomic)         BOOL                         bounces;

@property (nonatomic, readonly) NSArray<SBGridTableViewIndexPath *> *indexPathsForVisibleItems;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(SBGridTableViewType)type
                   dataSource:(id<SBGridTableViewDataSource>)dataSource;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:cellID;

- (void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString *)elementKind;


- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                   forDataSourceIndexPath:(NSIndexPath *)dataSourceIndexPath
                                                                 cellType:(SBGridTableViewCellType)cellType;

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind
                                                                           atIndexPath:(NSIndexPath *)dataSourceIndexPath
                                                                              cellType:(SBGridTableViewCellType)cellType;

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
               atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                       animated:(BOOL)animated;

@property (nonatomic, weak, nullable) id<SBGridTableViewDataSource> dataSource;



/**
 行悬浮区域颜色 默认灰色
 */
@property (nonatomic, strong, nullable) UIColor *suspendRowColor;

/**
 列悬浮区域颜色 默认灰色
 */
@property (nonatomic,strong, nullable) UIColor *suspendSectionColor;

/**
 主区域颜色
 */
@property (nonatomic,strong, nullable) UIColor *mainColor;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;

/**
 重新加载
 */
- (void)reload;


@end

NS_ASSUME_NONNULL_END
