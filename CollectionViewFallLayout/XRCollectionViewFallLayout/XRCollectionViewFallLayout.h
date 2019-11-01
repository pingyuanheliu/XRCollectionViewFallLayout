//
//  XRCollectionViewFallLayout.h
//  XRCollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XRCollectionViewDelegateFallLayout <NSObject>
@optional
// section是否使用瀑布流布局
- (BOOL)xr_collectionView:(UICollectionView *)collectionView useFallInSection:(NSInteger)section;
// section瀑布流列数
- (NSInteger)xr_collectionView:(UICollectionView *)collectionView numberOfColumnInSection:(NSInteger)section;

@end

@interface XRCollectionViewFallLayout : UICollectionViewFlowLayout

// 瀑布流代理
@property (nonatomic, weak, nullable) id<XRCollectionViewDelegateFallLayout> fallDelegate;

@end

NS_ASSUME_NONNULL_END
