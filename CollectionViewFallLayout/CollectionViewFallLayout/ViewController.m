//
//  ViewController.m
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import "ViewController.h"
#import "ProductModel.h"
#import "ProductViewCell.h"
#import "ProductHeaderView.h"
#import <XRCollectionViewFallLayout/XRCollectionViewFallLayout.h>

@interface ViewController () <XRCollectionViewDelegateFallLayout, ProductHeaderViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *listTV;
@property (strong, nonatomic) NSArray<ProductModel *> *listArray;

@end

static NSString *const Header = @"Header";
static NSString *const Identifier1 = @"Cell1";
static NSString *const Identifier2 = @"Cell2";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArray = [self testArray];
    //
    XRCollectionViewFallLayout *layout = [[XRCollectionViewFallLayout alloc] init];
//    layout.fallDelegate = self;
    if (@available(iOS 9, *)) {
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    self.listTV.collectionViewLayout = layout;
    [self.listTV registerClass:[ProductHeaderView class]
    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
           withReuseIdentifier:Header];
}

#pragma mark - Test Data
- (NSArray<ProductModel *> *)testArray {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (int i=0; i<14; i++) {
        int length = rand()%5 + 1;
        NSMutableString *msTitle = [[NSMutableString alloc] init];
        for (int j=0; j<length; j++) {
            [msTitle appendString:@"这就是权益名称"];
        }
        NSMutableString *msIntro = [[NSMutableString alloc] init];
        for (int j=0; j<length; j++) {
            [msIntro appendString:@"这就是权益描述"];
        }
        ProductModel *m = [[ProductModel alloc] init];
        if (length%2 == 0) {
            m.tag = YES;
        }else {
            m.tag = NO;
        }
        m.title = [msTitle copy];
        m.intro = [msIntro copy];
        m.price = [NSString stringWithFormat:@"¥%04d",i];
        m.level = @">1000级专享";
        m.costPrice = @"原价¥2000";
        m.sales = @"销量20000";
        [tmpArray addObject:m];
    }
    return [tmpArray copy];
}

- (CGSize)cx_cellSize:(ProductModel *)model {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat imgHeight = (size.width - 35.0)/2.0 - 20.0;
    CGSize sizeOfTitle = [model.title boundingRectWithSize:CGSizeMake(imgHeight, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
    CGSize sizeOfIntro = [model.intro boundingRectWithSize:CGSizeMake(imgHeight, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} context:nil].size;
    CGSize sizeOfPrice = CGSizeMake(imgHeight, 15.0);
    CGSize sizeOfSales = CGSizeMake(imgHeight, 15.0);
    CGFloat height;
    if (!model.tag) {
        height = 10.0 + imgHeight + 10.0 + sizeOfTitle.height + 10.0 + sizeOfIntro.height + 10.0 + sizeOfPrice.height + 5.0 + sizeOfSales.height + 10.0;
    }else {
        height = 10.0 + imgHeight + 10.0 + 15.0 + 10.0 + sizeOfTitle.height + 10.0 + sizeOfIntro.height + 10.0 + sizeOfPrice.height + 5.0 + sizeOfSales.height + 10.0;
    }
    size = CGSizeMake((size.width - 35.0)/2.0, height);
    NSLog(@"model price:%@==%@",model.price,NSStringFromCGSize(size));
    return size;
}

#pragma mark - ProductHeaderViewDelegate

- (void)didSelectedHeaderItem:(id)item {
    //刷新界面
    self.listArray = [self testArray];
    [self.listTV reloadData];
//    __weak typeof(self) weakSelf = self;
//    [UIView performWithoutAnimation:^{
//        if (weakSelf.listTV.numberOfSections > 1) {
//            [weakSelf.listTV reloadSections:[NSIndexSet indexSetWithIndex:1]];
//        }
//    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else if (section == 1) {
        return 10;
    }else {
        return self.listArray.count;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier1 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }else if (indexPath.section == 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier1 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
        return cell;
    }else {
        ProductModel *model = self.listArray[indexPath.row];
        ProductViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier2 forIndexPath:indexPath];
        [cell updateData:model];
        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProductHeaderView *view = (ProductHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:Header forIndexPath:indexPath ];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        return view;
    }else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath:%@",indexPath);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (indexPath.section == 0) {
        return CGSizeMake((size.width - 5.0)/2.0, 50.0);
    }else if (indexPath.section == 1) {
        return CGSizeMake((size.width - 5.0)/2.0, 50.0);
    }else {
        ProductModel *model = self.listArray[indexPath.row];
        return [self cx_cellSize:model];
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }else if (section == 1) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }else {
        return UIEdgeInsetsMake(10, 15, 0, 15);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }else if (section == 1) {
        return CGSizeZero;
    }else {
        CGSize size = [UIScreen mainScreen].bounds.size;
        return CGSizeMake(size.width, 50.0);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - XRCollectionViewDelegateFallLayout

// section是否使用瀑布流布局
- (BOOL)xr_collectionView:(UICollectionView *)collectionView useFallInSection:(NSInteger)section {
    if (section == 0) {
        return NO;
    }else if (section == 1) {
        return NO;
    }else if (section == 2) {
        return YES;
    }else {
        return NO;
    }
}

// collectionView是否在透明导航栏下面（默认透明）
- (BOOL)xr_navigationBarTranslucent {
    return self.navigationController.navigationBar.isTranslucent;
}
// section瀑布流列数(默认两列)
- (NSInteger)xr_collectionView:(UICollectionView *)collectionView numberOfColumnInSection:(NSInteger)section {
    return 2;
}

@end
