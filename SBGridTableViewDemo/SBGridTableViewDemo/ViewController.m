//
//  ViewController.m
//  SBGridTableViewDemo
//
//  Created by 安康 on 2020/3/18.
//  Copyright © 2020 安康. All rights reserved.
//

#import "ViewController.h"

#import "SBGridTableView.h"

#import "SBCollectionViewCell.h"
#import "XFGridHightlightDecorationView.h"


@interface ViewController ()
<
SBGridTableViewDataSource
>

@property (nonatomic, strong) SBGridTableView *gridTableView;

@property (nonatomic, assign) NSInteger rowCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.rowCount = 30;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _gridTableView = [[SBGridTableView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, 300)
                                                       type:SBGridTableViewTypeSectionAndRowFixation
                                                 dataSource:self];
    _gridTableView.backgroundColor = UIColor.lightGrayColor;
    
    [_gridTableView registerClass:SBCollectionViewCell.class
       forCellWithReuseIdentifier:NSStringFromClass(SBCollectionViewCell.class)];
    [_gridTableView registerClass:XFGridHightlightDecorationView.class
          forDecorationViewOfKind:NSStringFromClass(XFGridHightlightDecorationView.class)];
    _gridTableView.minimumInteritemSpacing = 5;
    _gridTableView.minimumLineSpacing = 10;
    
    [self.view addSubview:self.gridTableView];
    
    
    
}



#pragma mark - SBGridTableViewDataSource

- (NSInteger)gridTableView:(SBGridTableView *)gridTableView
    numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 9;
    }
}

- (UICollectionViewCell *)gridTableView:(SBGridTableView *)gridTableView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
                               cellType:(SBGridTableViewCellType)cellType {
    
    SBCollectionViewCell *cell = [gridTableView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SBCollectionViewCell.class)
                                                                forDataSourceIndexPath:indexPath
                                                                              cellType:cellType];
    
    if (cellType == SBGridTableViewCellTypeSuspendSection) {
        cell.contentView.backgroundColor = UIColor.blueColor;
    } else {
        cell.contentView.backgroundColor = UIColor.yellowColor;
    }
    
    cell.lbl.text = [NSString stringWithFormat:@"%zi - %zi", indexPath.section, indexPath.row];
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInGridTableView:(SBGridTableView *)gridTableView {
    return self.rowCount;
}

- (NSInteger)numberOfSuspendSectionsInGridTableView:(SBGridTableView *)gridTableView {
    return 1;
}

- (NSInteger)gridTableView:(SBGridTableView *)gridTableView numberOfSuspendItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)gridTableView:(SBGridTableView *)gridTableView
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
               cellType:(SBGridTableViewCellType)cellType {
    if (indexPath.section == 5) {
        if (indexPath.row == 3) {
            return CGSizeMake(100, 64);
        }
        return CGSizeMake(100, 44);
    }
    return CGSizeMake(65, 44);
}

- (void)gridTableView:(SBGridTableView *)gridTableView didSelectItemAtIndexPath:(NSIndexPath *)indexPath cellType:(SBGridTableViewCellType)cellType {
    NSLog(@"%s", __func__);
}

- (nullable UICollectionViewLayoutAttributes *)gridTableView:(SBGridTableView *)gridTableView
                layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath
                                                    cellType:(SBGridTableViewCellType)cellType {
    UICollectionViewLayoutAttributes *layoutAttributes = [gridTableView layoutAttributesForDecorationViewOfKind:NSStringFromClass(XFGridHightlightDecorationView.class)
                                            atIndexPath:indexPath cellType:cellType];

    if ([layoutAttributes isKindOfClass:SBCollectionViewLayoutAttributes.class]) {
        SBCollectionViewLayoutAttributes *attrs = (SBCollectionViewLayoutAttributes *)layoutAttributes;
        if (indexPath.section == 4) {
            attrs.model = indexPath;
            return attrs;
        }

    }


    return nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.rowCount -= 2;
    [self.gridTableView reload];
}
@end
