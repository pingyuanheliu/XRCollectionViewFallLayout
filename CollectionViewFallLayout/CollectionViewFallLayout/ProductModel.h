//
//  ProductModel.h
//  CollectionViewFallLayout
//
//  Created by LL on 2019/11/1.
//  Copyright © 2019 LL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductModel : NSObject

@property (nonatomic, assign) BOOL tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *costPrice;
@property (nonatomic, copy) NSString *sales;

@end

NS_ASSUME_NONNULL_END
