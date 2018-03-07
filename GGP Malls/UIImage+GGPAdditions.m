//
//  UIImage+GGPAdditions.m
//  GGP Malls
//
//  Created by Christiaan Kuilman on 12/21/15.
//  Copyright © 2015 GGP. All rights reserved.
//

#import "UIImage+GGPAdditions.h"
#import "GGPPromotion.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kMoverEscalator = @"Escalator";
static NSString *const kMoverElevator = @"Elevator";
static NSString *const kMoverStairCase = @"Stair Case";

@implementation UIImage (GGPAdditions)

+ (UIImage *)ggp_imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)ggp_imageForJmapMoverType:(NSString *)moverType {
    if ([moverType isEqualToString:kMoverElevator]) {
        return [UIImage imageNamed:@"ggp_wayfinding_elevator"];
    } else if ([moverType isEqualToString:kMoverStairCase]) {
        return [UIImage imageNamed:@"ggp_wayfinding_stairs"];
    } else if ([moverType isEqualToString:kMoverEscalator]) {
        return [UIImage imageNamed:@"ggp_wayfinding_escalator"];
    } else {
        return nil;
    }
}

+ (UIImage *)ggp_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)ggp_fetchImageWithUrl:(NSURL *)url completion:(void(^)(UIImage *image))completion {
    AFHTTPRequestOperation *operation = [self ggp_imageRequestOperationForUrl:url];
    
    __weak typeof(operation) weakOperation = operation;
    operation.completionBlock = ^{
        if (completion) {
            completion(weakOperation.responseObject);
        }
    };
    
    [operation start];
}

+ (void)ggp_fetchImagesForPromotions:(NSArray<GGPPromotion *> *)promotions intoLookup:(NSMutableDictionary *)lookup completion:(void(^)())completion {
    NSArray *operations = [self ggp_imageOperationsForPromotions:promotions withLookup:lookup];
    
    NSArray *batchOperations = [AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:nil completionBlock:^(NSArray *operations) {
        if (completion) {
            completion();
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperations:batchOperations waitUntilFinished:NO];
}

+ (NSArray *)ggp_imageOperationsForPromotions:(NSArray<GGPPromotion *> *)promotions withLookup:(NSMutableDictionary *)lookup {
    NSMutableArray *operations = [NSMutableArray array];
    
    for (GGPPromotion *promotion in promotions) {
        AFHTTPRequestOperation *operation = [self ggp_imageRequestOperationForUrl:promotion.imageUrl];
        
        __weak typeof(operation) weakOperation = operation;
        operation.completionBlock = ^{
            if (weakOperation.responseObject) {
                [lookup setObject:weakOperation.responseObject forKey:@(promotion.promotionId)];
            } else {
                GGPLogWarn(@"Unable to fetch sale image for promotionId: %ld", (long)promotion.promotionId);
                [lookup setObject:[UIImage new] forKey:@(promotion.promotionId)];
            }
        };
        [operations addObject:operation];
    }
    return operations;
}

+ (AFHTTPRequestOperation *)ggp_imageRequestOperationForUrl:(NSURL *)imageUrl {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer new];
    
    return operation;
}

+ (UIImage *)ggp_drawImage:(UIImage *)fgImage inImage:(UIImage *)bgImage atPoint:(CGPoint)point {
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake(point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
