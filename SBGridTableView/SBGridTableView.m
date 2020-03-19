//
//  SBGridTableView.m
//  SBUIKit
//
//  Created by 安康 on 2019/11/16.
//

#import "SBGridTableView.h"


@implementation SBGridTableViewIndexPath

@end

@interface SBGridTableView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SBGridTableCollectionViewFlowLayoutDataSource
>

/**
 主要渲染CollectionView
 */
@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong, readwrite) SBGridTableCollectionViewFlowLayout *mainLayout;

@property (nonatomic, assign) SBGridTableViewType fixationType;

@property (nonatomic, assign) NSInteger suspendRow;

@property (nonatomic, assign) NSInteger suspendSection;

@end


@implementation SBGridTableView


- (instancetype)initWithFrame:(CGRect)frame
                         type:(SBGridTableViewType)type
                   dataSource:(id<SBGridTableViewDataSource>)dataSource {
    if (self = [super initWithFrame:frame]) {
        _fixationType = type;
        _dataSource = dataSource;
        [self configUIWithType:type];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainCollectionView.frame = self.bounds;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reload];
}

#pragma mark - Private Methods

- (void)configUIWithType:(SBGridTableViewType)type{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.mainCollectionView];
}

/** 获取面向DataSource的index */
- (NSIndexPath *)getDataSourceIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *dataSourceIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                          inSection:indexPath.section];;
    if (indexPath.section < self.suspendSection) {
        
    } else if (indexPath.row < self.suspendRow) {
        dataSourceIndexPath = [NSIndexPath indexPathForRow:dataSourceIndexPath.row
                                                 inSection:dataSourceIndexPath.section - self.suspendSection];
    } else {
        dataSourceIndexPath = [NSIndexPath indexPathForRow:dataSourceIndexPath.row - self.suspendRow
                                                 inSection:dataSourceIndexPath.section - self.suspendSection];
    }
    return dataSourceIndexPath;
}

/** 获取面向getcollectionViewIndexPath的index */
- (NSIndexPath *)getCollectionViewIndexPath:(NSIndexPath *)dataSourceIndexPath
                                   cellType:(SBGridTableViewCellType)cellType {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataSourceIndexPath.row
                                                inSection:dataSourceIndexPath.section];

    switch (cellType) {
        case SBGridTableViewCellTypeMain: {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row + self.suspendRow
                                           inSection:indexPath.section + self.suspendSection];
            
        }
            break;
            
        case SBGridTableViewCellTypeSuspendRow: {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row
                                           inSection:indexPath.section + self.suspendSection];
        }
            break;
        case SBGridTableViewCellTypeSuspendSection: {

        }
            break;
    }

    return indexPath;
}


- (SBGridTableViewCellType)getCellTypeWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.suspendSection) {
        return SBGridTableViewCellTypeSuspendSection;
    } else if (indexPath.row < self.suspendRow) {
        return SBGridTableViewCellTypeSuspendRow;
    } else {
        return SBGridTableViewCellTypeMain;
    }
}


- (void)clcLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [longRecognizer locationInView:self.mainCollectionView];
        NSIndexPath * indexPath = [self.mainCollectionView indexPathForItemAtPoint:location];

        if (!indexPath) {
            return;
        }
        
        if ([self.dataSource respondsToSelector:@selector(gridTableView:didLongPressItemAtIndexPath:cellType:)]) {
            NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];
            SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
            [self.dataSource gridTableView:self
               didLongPressItemAtIndexPath:dataSourceIndexPath
                                  cellType:cellType];
            
        }
    }
}

#pragma mark - Public Methods

- (void)reload {
    self.suspendRow = 0;
    self.suspendSection = 0;
    self.mainLayout.suspendRowNum = self.suspendRow;
    self.mainLayout.suspendSectionNum = self.suspendSection;
    self.mainLayout.minimumLineSpacing = self.minimumLineSpacing;
    self.mainLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
    [self.mainLayout reload];
    [self.mainCollectionView reloadData];
    [self.mainCollectionView layoutIfNeeded];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:cellID {
    [self.mainCollectionView registerClass:cellClass forCellWithReuseIdentifier:cellID];
}

- (void)registerClass:(nullable Class)viewClass forDecorationViewOfKind:(NSString *)elementKind {
    [self.mainLayout registerClass:viewClass forDecorationViewOfKind:elementKind];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                   forDataSourceIndexPath:(NSIndexPath *)dataSourceIndexPath
                                                                 cellType:(SBGridTableViewCellType)cellType {
    NSIndexPath *indexPath = [self getCollectionViewIndexPath:dataSourceIndexPath cellType:cellType];
    return [self.mainCollectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                              forIndexPath:indexPath];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
               atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                       animated:(BOOL)animated {
    [self.mainCollectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:scrollPosition
                                            animated:animated];
    
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind
                                                                           atIndexPath:(NSIndexPath *)dataSourceIndexPath
                                                                              cellType:(SBGridTableViewCellType)cellType {
    
    NSIndexPath *indexPath = [self getCollectionViewIndexPath:dataSourceIndexPath cellType:cellType];
    return [self.mainLayout layoutAttributesForDecorationViewOfKind:elementKind
                                                        atIndexPath:indexPath];
}

- (CGPoint)contentOffset {
    return self.mainCollectionView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.mainCollectionView.contentOffset = contentOffset;
}

- (CGSize)contentSize {
    return self.mainCollectionView.contentSize;
}

- (void)setContentSize:(CGSize)contentSize {
    self.mainCollectionView.contentSize = contentSize;
}

- (BOOL)bounces {
    return self.mainCollectionView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    self.mainCollectionView.bounces = bounces;
}

- (NSArray<SBGridTableViewIndexPath *> *)indexPathsForVisibleItems {
    
    NSMutableArray *indexPathsForVisibleItems = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.mainCollectionView.indexPathsForVisibleItems) {
        SBGridTableViewIndexPath *gridIndexPath = [[SBGridTableViewIndexPath alloc] init];
        gridIndexPath.indexPath = [self getDataSourceIndexPath:indexPath];
        gridIndexPath.cellType = [self getCellTypeWithIndexPath:indexPath];
        [indexPathsForVisibleItems addObject:gridIndexPath];
    }
    return indexPathsForVisibleItems;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [_dataSource gridTableView:self numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_dataSource numberOfSectionsInGridTableView:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
    NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];

    UICollectionViewCell *cell = [self.dataSource gridTableView:self
                                         cellForItemAtIndexPath:dataSourceIndexPath
                                                       cellType:cellType];

    switch (cellType) {
        case SBGridTableViewCellTypeMain: {
            cell.backgroundColor = self.mainColor;
        }
            break;
            
        case SBGridTableViewCellTypeSuspendRow: {
            cell.backgroundColor = self.suspendRowColor;
        }
            break;
        case SBGridTableViewCellTypeSuspendSection: {
            cell.backgroundColor = self.suspendSectionColor;
        }
            break;
    }

    return cell;
}

#pragma mark - SBGridTableCollectionViewFlowLayoutDataSource

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];
    SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
    return [_dataSource gridTableView:self
               sizeForItemAtIndexPath:dataSourceIndexPath
                             cellType:cellType];
}

- (nullable SBCollectionViewLayoutAttributes *)flowLayout:(SBGridTableCollectionViewFlowLayout *)flowLayout layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];
    SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
    
    if ([_dataSource respondsToSelector:@selector(layoutAttributesForDecorationViewOfKind:atIndexPath:)]) {
        return [_dataSource gridTableView:self layoutAttributesForDecorationViewAtIndexPath:dataSourceIndexPath
                                 cellType:cellType];
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];
    SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
    return [_dataSource gridTableView:self
               sizeForItemAtIndexPath:dataSourceIndexPath
                             cellType:cellType];
    
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(gridTableView:didSelectItemAtIndexPath:cellType:)]) {
        NSIndexPath *dataSourceIndexPath = [self getDataSourceIndexPath:indexPath];
        SBGridTableViewCellType cellType = [self getCellTypeWithIndexPath:indexPath];
        [self.dataSource gridTableView:self didSelectItemAtIndexPath:dataSourceIndexPath cellType:cellType];
    }

}

#pragma mark - UICollectionViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(gridTableViewDidScroll:)]) {
        [self.dataSource gridTableViewDidScroll:self];
    }
}

//  惯性停止滚动的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([self.dataSource respondsToSelector:@selector(gridTableViewDidEndScroll:)]) {
        [self.dataSource gridTableViewDidEndScroll:self];
    }
}

// 手指离开屏幕的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(!decelerate) {
        if ([self.dataSource respondsToSelector:@selector(gridTableViewDidEndScroll:)]) {
            [self.dataSource gridTableViewDidEndScroll:self];
        }
    }
}

#pragma mark - Getter Methods

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mainLayout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.directionalLockEnabled = YES;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.bounces = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mainCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(clcLongPress:)];
        
        longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
        [_mainCollectionView addGestureRecognizer:longPressGesture];
    }
    return _mainCollectionView;
}

- (SBGridTableCollectionViewFlowLayout *)mainLayout {
    if (!_mainLayout) {
        _mainLayout = [[SBGridTableCollectionViewFlowLayout alloc] init];
        _mainLayout.suspendRowNum = self.suspendRow;
        _mainLayout.suspendSectionNum = self.suspendSection;
        _mainLayout.dataSource = self;
        _mainLayout.minimumLineSpacing = self.minimumLineSpacing;
        _mainLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
    }
    return _mainLayout;
}

- (NSInteger)suspendRow  {
    if (!_suspendRow) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(gridTableView:numberOfSuspendItemsInSection:)]) {
            _suspendRow = [_dataSource gridTableView:self numberOfSuspendItemsInSection:0];
        }else{
            switch (_fixationType) {
                case SBGridTableViewTypeSectionAndRowFixation:
                    return 1;
                case SBGridTableViewTypeOnlySectionFixation:
                    return 0;
                case SBGridTableViewTypeOnlyRowFixation:
                    return 1;
                case SBGridTableViewTypeNoFixation:
                    return 0;
            }
            
        }
    }
    return _suspendRow;
}

- (NSInteger)suspendSection {
    if (!_suspendSection) {
        if (self.dataSource &&[self.dataSource respondsToSelector:@selector(numberOfSuspendSectionsInGridTableView:)])
        {
            _suspendSection = [_dataSource numberOfSuspendSectionsInGridTableView:self];
        }else{
            switch (_fixationType) {
                case SBGridTableViewTypeSectionAndRowFixation:
                    return 1;
                case SBGridTableViewTypeOnlySectionFixation:
                    return 1;
                case SBGridTableViewTypeOnlyRowFixation:
                    return 0;
                case SBGridTableViewTypeNoFixation:
                    return 0;
            }
        }
    }
    return _suspendSection;
}

- (UIColor *)mainColor {
    if (!_mainColor) {
        _mainColor = [UIColor clearColor];
    }
    return _mainColor;
}

- (UIColor *)suspendRowColor {
    if (!_suspendRowColor) {
        _suspendRowColor = [UIColor clearColor];
    }
    return _suspendRowColor;
}

- (UIColor *)suspendSectionColor {
    if (!_suspendSectionColor) {
        _suspendSectionColor = [UIColor clearColor];
    }
    return _suspendSectionColor;
}


@end
