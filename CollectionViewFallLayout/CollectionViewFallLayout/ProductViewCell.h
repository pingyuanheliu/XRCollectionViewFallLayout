//
//  ProductViewCell.h
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductViewCell : UICollectionViewCell

/**
 更新数据
 
 @param model 数据模型
 */
- (void)updateData:(ProductModel *)model;

@end

NS_ASSUME_NONNULL_END
