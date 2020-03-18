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


@interface ViewController ()
<
SBGridTableViewDataSource
>

@property (nonatomic, strong) SBGridTableView *gridTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _gridTableView = [[SBGridTableView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, 300)
                                                       type:SBGridTableViewTypeSectionAndRowFixation
                                                 dataSource:self];
    _gridTableView.backgroundColor = UIColor.lightGrayColor;
    
    [_gridTableView registerClass:SBCollectionViewCell.class
       forCellWithReuseIdentifier:NSStringFromClass(SBCollectionViewCell.class)];
    
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
    
    cell.lbl.text = [NSString stringWithFormat:@"%zi - %zi", indexPath.section, indexPath.row];
    
    return cell;
    
}


- (NSInteger)numberOfSectionsInGridTableView:(SBGridTableView *)gridTableView {
    return 10;
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
            return CGSizeMake(100, 30);
        }
        return CGSizeMake(100, 20);
    }
    return CGSizeMake(65, 20);
}

- (void)gridTableView:(SBGridTableView *)gridTableView didSelectItemAtIndexPath:(NSIndexPath *)indexPath cellType:(SBGridTableViewCellType)cellType {
    NSLog(@"%s", __func__);
}


@end
