//
//  ProductHeaderView.m
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/4.
//  Copyright © 2019 LL. All rights reserved.
//

#import "ProductHeaderView.h"

@interface ProductHeaderCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *labTitle;//标题

@end

@implementation ProductHeaderCell

#pragma mark - Get

- (UILabel *)labTitle {
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        _labTitle.font = [UIFont systemFontOfSize:15.0];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labTitle;
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self customView];
}

#pragma mark - View

- (void)customView {
    NSArray *hContraints;
    NSArray *vContraints;
    //标题
    [self.contentView addSubview:self.labTitle];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_labTitle]-5-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labTitle)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_labTitle]-5-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_labTitle)];
    [self.contentView addConstraints:hContraints];
    [self.contentView addConstraints:vContraints];
}

#pragma mark - Selected

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.labTitle.textColor = [UIColor colorWithRed:0xff/255.0 green:0x57/255.0 blue:0x0f/255.0 alpha:1.0];
    }else {
        self.labTitle.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
    }
}

@end

@interface ProductHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) NSArray *listArray;

@end

@implementation ProductHeaderView

static NSString *const Identifier = @"Cell";

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.listArray = [NSArray arrayWithArray:[self test_array]];
    }
    return self;
}

#pragma mark - Test Data

- (NSArray *)test_array {
    return @[@{@"name":@"推荐",@"ID":@(0)}, @{@"name":@"酒店",@"ID":@(1)}, @{@"name":@"旅游",@"ID":@(2)}, @{@"name":@"物流",@"ID":@(3)}, @{@"name":@"教育",@"ID":@(4)}, @{@"name":@"医疗",@"ID":@(5)}, @{@"name":@"科技",@"ID":@(6)}, @{@"name":@"家居",@"ID":@(7)}, @{@"name":@"美妆",@"ID":@(8)}];
}

#pragma mark - Get & Set

- (UICollectionView *)listView {
    if (_listView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //
        _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.bounces = YES;
        _listView.scrollEnabled = YES;
        _listView.pagingEnabled = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.translatesAutoresizingMaskIntoConstraints = NO;
        //
        [_listView registerClass:[ProductHeaderCell class] forCellWithReuseIdentifier:Identifier];
    }
    return _listView;
}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self customView];
}

#pragma mark - View

- (void)customView {
    NSArray *hContraints;
    NSArray *vContraints;
    //标题
    [self addSubview:self.listView];
    hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_listView]-0-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_listView)];
    vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_listView]-0-|"
                                                          options:0
                                                          metrics:nil
                                                            views:NSDictionaryOfVariableBindings(_listView)];
    [self addConstraints:hContraints];
    [self addConstraints:vContraints];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    id item = self.listArray[indexPath.row];
    id name = item[@"name"];
    if (name != nil && [name isKindOfClass:[NSString class]]) {
        cell.labTitle.text = name;
    }else {
        cell.labTitle.text = nil;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width = floor(width/5.5);
    return CGSizeMake(width, collectionView.bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
