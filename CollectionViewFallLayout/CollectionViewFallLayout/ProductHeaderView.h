//
//  ProductHeaderView.h
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/4.
//  Copyright © 2019 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProductHeaderViewDelegate <NSObject>

@optional

- (void)didSelectedHeaderItem:(id)item;

@end

@interface ProductHeaderView : UICollectionReusableView

@property (nonatomic, weak, nullable) id <ProductHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
