//
//  XRCollectionViewFallLayout.m
//  XRCollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import "XRCollectionViewFallLayout.h"
#import <UIKit/UICollectionViewFlowLayout.h>

#define kHeaderBeginY   @"headerBeginY"
#define kFooterBeginY   @"footerBeginY"
#define kMaxHeight      @"maxHeight"
#define kItems          @"items"

@interface XRCollectionViewFallLayout ()

//section 对应的item 开始
/*
 [
     {
     "headerBeginY":"0.0",
     "footerBeginY":"0.0",
     "maxHeight":"0.0",
     "items":[@(rect),@(rect)]
     },
     {
     "headerBeginY":"0.0",
     "footerBeginY":"0.0",
     "maxHeight":"0.0",
     "items":[@(rect),@(rect)]
     },
 ]
 */
@property (nonatomic, strong) NSMutableArray *prepareArray;

@end

@implementation XRCollectionViewFallLayout


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.prepareArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Get

/**
 瀑布流的代理
 如果为空，则默认返回UICollectionViewDelegate

 @return 代理
 */
- (id<XRCollectionViewDelegateFallLayout>)fallDelegate {
    if (_fallDelegate == nil) {
        id<XRCollectionViewDelegateFallLayout> delegate = (id<XRCollectionViewDelegateFallLayout>)self.collectionView.delegate;
        return delegate;
    }else {
        return _fallDelegate;
    }
}

#pragma mark - OverWrite Method

- (void)prepareLayout {
    [super prepareLayout];
    NSLog(@"==prepareLayout==");
    [self.prepareArray removeAllObjects];
    NSInteger sections = [self.collectionView numberOfSections];
    [self beginOffsetYOfSection:sections];
}

#pragma mark -

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *superArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
    @autoreleasepool {
        BOOL useSystem;
        if (@available(iOS 9, *)) {
            //导航栏不透明
            if (self.sectionHeadersPinToVisibleBounds) {
                useSystem = YES;
            }else {
                useSystem = NO;
            }
        }else {
            useSystem = NO;
        }
        if (!useSystem) {
            //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
            NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
            //遍历superArray，得到一个当前屏幕中所有的section数组
            for (UICollectionViewLayoutAttributes *attributes in superArray) {
                //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
                if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                    [noneHeaderSections addIndex:attributes.indexPath.section];
                }
            }
            //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
            //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
            for (UICollectionViewLayoutAttributes *attributes in superArray) {
                //如果当前的元素是一个header，将header所在的section从数组中移除
                if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                    [noneHeaderSections removeIndex:attributes.indexPath.section];
                }
            }
            //遍历当前屏幕中没有header的section数组
            [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
                if ([self.collectionView numberOfItemsInSection:idx] > 0) {
                    //取到当前section中第一个item的indexPath
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
                    //获取当前section在正常情况下已经离开屏幕的header结构信息
                    UICollectionViewLayoutAttributes *attrHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    //如果当前分区确实有因为离开屏幕而被系统回收的header
                    if (attrHeader != nil && !CGSizeEqualToSize(attrHeader.size, CGSizeZero)) {
                        //将该header结构信息重新加入到superArray中去
                        [superArray addObject:attrHeader];
                    }
                }
            }];
        }
        for (UICollectionViewLayoutAttributes *attrItem in superArray) {
            NSInteger section = attrItem.indexPath.section;
            if (attrItem.representedElementKind != nil) {
                // Section Header
                if ([attrItem.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                    //取最大
                    CGFloat beginY = [[self.prepareArray[section] objectForKey:kHeaderBeginY] floatValue];
                    if (useSystem) {
                        NSLog(@"beginY1[%@]:%f",@(section),beginY);
                        //获取当前header的frame
                        CGRect irect = attrItem.frame;
                        irect.origin.y = beginY;
                        attrItem.frame = irect;
                        attrItem.zIndex = 1024;
                    }else {
                        NSLog(@"beginY2[%@]:%f",@(section),beginY);
                        //滑动偏移
                        CGFloat offset;
                        if (![self navigationBarTranslucent]) {
                            offset = self.collectionView.contentOffset.y;
                        }else {
                            if (@available(iOS 11.0, *)) {
                                UIEdgeInsets insets = [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
                                offset = self.collectionView.contentOffset.y + MAX(insets.top, 20.0) + 44.0;
                            }else {
                                offset = self.collectionView.contentOffset.y + 64.0;
                            }
                        }
                        //取最大
                        CGFloat maxY = MAX(offset, beginY);
                        //获取当前header的frame
                        CGRect irect = attrItem.frame;
                        irect.origin.y = maxY;
                        attrItem.frame = irect;
                        attrItem.zIndex = 1024;
                    }
                }else {
                    // Section Footer
                    CGFloat beginY = [[self.prepareArray[section] objectForKey:kFooterBeginY] floatValue];
                    CGRect irect = attrItem.frame;
                    irect.origin.y = beginY;
                    attrItem.frame = irect;
                }
            }else {
                // Section Cells
                id items = self.prepareArray[section];
                attrItem.frame = CGRectFromString([items[kItems] objectAtIndex:attrItem.indexPath.row]);
            }
        }
    }
    return [superArray copy];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

#pragma mark -

- (CGSize)collectionViewContentSize {
    id last = [self.prepareArray lastObject];
    CGFloat height = [last[kMaxHeight] floatValue];
    CGSize size = [super collectionViewContentSize];
    NSLog(@"size1:%@",NSStringFromCGSize(size));
    size.height = height;
    NSLog(@"size2:%@",NSStringFromCGSize(size));
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (@available(iOS 9, *)) {
        return YES;
    }else {
        return YES;
    }
    return YES;
}

#pragma mark - Private Methods

- (void)beginOffsetYOfSection:(NSInteger)section {
    CGFloat offsetY = 0.0;
    CGFloat lastY = 0.0;
    for (NSInteger i=0; i<section; i++) {
        @autoreleasepool {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithFloat:0.0] forKey:kHeaderBeginY];
            [dict setValue:[NSNumber numberWithFloat:0.0] forKey:kFooterBeginY];
            [dict setValue:[NSNumber numberWithFloat:0.0] forKey:kMaxHeight];
            [self.prepareArray addObject:[dict copy]];
            //
            if (i > 0) {
                id beforeSection = self.prepareArray[i - 1];
                lastY = [beforeSection[kMaxHeight] floatValue];
            }else {
                lastY = 0.0;
            }
            [dict setValue:[NSNumber numberWithFloat:lastY] forKey:kHeaderBeginY];
            offsetY = 0.0;
            //
            NSInteger items = [self.collectionView numberOfItemsInSection:i];
            if (items == 0) {
                [self.prepareArray replaceObjectAtIndex:i withObject:[dict copy]];
                continue;
            }
            //第一个Item
            NSIndexPath *fIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            //Header
            UICollectionViewLayoutAttributes *attrHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:fIndexPath];
            NSLog(@"attrHeader[%@]:%@",@(i),NSStringFromCGRect(attrHeader.frame));
            if (attrHeader != nil && !CGSizeEqualToSize(attrHeader.size, CGSizeZero)) {
                offsetY += attrHeader.frame.size.height;
            }
            //边界
            UIEdgeInsets insets = [self insetForSectionAtIndex:i];
            //top
            offsetY += insets.top;
            //item
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *tmpHeight = [[NSMutableArray alloc] init];
            NSInteger column = [self numberOfColumnInSection:i];
            for (NSInteger k=0; k<column; k++) {
                [tmpHeight addObject:[NSNumber numberWithFloat:0.0]];
            }
            NSInteger lastIndex = -1;
            for (NSInteger j=0; j<items; j++) {
                @autoreleasepool {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                    UICollectionViewLayoutAttributes *attrItem = [self layoutAttributesForItemAtIndexPath:indexPath];
                    if (attrItem != nil && !CGSizeEqualToSize(attrItem.size, CGSizeZero)) {
                        if (![self useFallInSection:i]) {
                            //没有使用瀑布流，使用默认布局
                            CGRect rect = attrItem.frame;
                            rect.origin.y -= (attrHeader.frame.origin.y - lastY);
                            [array addObject:NSStringFromCGRect(rect)];
                            lastIndex = j;
                        }else {
                            //使用瀑布流
                            id imin = [tmpHeight valueForKeyPath:@"@min.self"];
                            CGFloat min = [imin floatValue];
                            NSLog(@"=A=[%@]min:%f==%f==%f", @(j), min, lastY, offsetY);
                            CGRect rect = attrItem.frame;
                            NSInteger index = [tmpHeight indexOfObject:imin];
                            if (index != j%column) {
                                if (index == 0) {
                                    rect.origin.x = insets.left;
                                }else {
                                    rect.origin.x = insets.left + index*(attrItem.frame.size.width + [self minimumInteritemSpacingForSectionAtIndex:i]);
                                }
                            }
                            if (j < column) {
                                rect.origin.y = lastY + offsetY + min;
                            }else {
                                rect.origin.y = lastY + offsetY + min;
                            }
                            [array addObject:NSStringFromCGRect(rect)];
                            min += rect.size.height + [self minimumLineSpacingForSectionAtIndex:i];
                            NSLog(@"=B=[%@]min:%f==%@", @(j), min, NSStringFromCGRect(rect));
                            [tmpHeight replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:min]];
                        }
                        NSLog(@"=C=%@",tmpHeight);
                    }else {
                        [array addObject:NSStringFromCGRect(CGRectZero)];
                        lastIndex = j;
                    }
                }
            }
            [dict setValue:array forKey:kItems];
            if (lastIndex != -1) {
                //最后一个item
                NSIndexPath *lIndexPath = [NSIndexPath indexPathForItem:lastIndex inSection:i];
                UICollectionViewLayoutAttributes *attrItem = [self layoutAttributesForItemAtIndexPath:lIndexPath];
                if (attrItem != nil && !CGSizeEqualToSize(attrItem.size, CGSizeZero)) {
                    offsetY = attrItem.frame.origin.y + attrItem.frame.size.height;
                }
            }else {
                CGFloat maxH = 0.0;
                for (NSString *string in array) {
                    CGRect tRect = CGRectFromString(string);
                    CGFloat tHeight = tRect.origin.y + tRect.size.height;
                    maxH = tHeight > maxH ? tHeight : maxH;
                }
                offsetY = maxH;
            }
            
            //bottom
            offsetY += insets.bottom;
            [dict setValue:[NSNumber numberWithFloat:offsetY] forKey:kFooterBeginY];
            //Footer
            UICollectionViewLayoutAttributes *attrFooter = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:fIndexPath];
            if (attrFooter != nil && !CGSizeEqualToSize(attrFooter.size, CGSizeZero)) {
                offsetY += attrFooter.frame.size.height;
            }
            NSLog(@"offsetY[%@]:%@==%f",@(i),@(lastIndex),offsetY);
            [dict setValue:[NSNumber numberWithFloat:offsetY] forKey:kMaxHeight];
            [self.prepareArray replaceObjectAtIndex:i withObject:[dict copy]];
        }
    }
    NSLog(@"offsetY[%@]:%f=%@",@(section),offsetY,self.prepareArray);
}

#pragma mark - Delegate Method

- (BOOL)navigationBarTranslucent {
    BOOL translucent;
    if (self.fallDelegate != nil && [self.fallDelegate respondsToSelector:@selector(xr_navigationBarTranslucent)]) {
        translucent = [self.fallDelegate xr_navigationBarTranslucent];
    }else {
        translucent = YES;
    }
    return translucent;
}

- (BOOL)useFallInSection:(NSInteger)section {
    BOOL used;
    if (self.fallDelegate != nil && [self.fallDelegate respondsToSelector:@selector(xr_collectionView:useFallInSection:)]) {
        used = [self.fallDelegate xr_collectionView:self.collectionView useFallInSection:section];
    }else {
        used = NO;
    }
    return used;
}

- (NSInteger)numberOfColumnInSection:(NSInteger)section {
    NSInteger column;
    if (self.fallDelegate != nil && [self.fallDelegate respondsToSelector:@selector(xr_collectionView:numberOfColumnInSection:)]) {
        column = [self.fallDelegate xr_collectionView:self.collectionView numberOfColumnInSection:section];
        column = column > 2 ? column : 2;
    }else {
        column = 2;
    }
    return column;
}

#pragma mark -

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset;
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }else {
        inset = self.sectionInset;
    }
    NSLog(@"inset[%@]:%@",@(section),NSStringFromUIEdgeInsets(inset));
    return inset;
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space;
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        space = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }else {
        space = 0.0;
    }
    return space;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space;
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }else {
        space = 0.0;
    }
    return space;
}

@end
