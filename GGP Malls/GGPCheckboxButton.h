//
//  GGPCheckboxButton.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 8/31/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPCheckboxButton : UIButton

@property (nonatomic, copy) void (^tapHandler)();

@end
