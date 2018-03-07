//
//  GGPFormFieldDelegate.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 5/9/16.
//  Copyright © 2016 GGP. All rights reserved.
//

@class GGPFormField;

@protocol GGPFormFieldDelegate <NSObject>

- (void)clearButtonTappedForFormField:(GGPFormField *)formField;

@end
