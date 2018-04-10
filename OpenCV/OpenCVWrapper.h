//
//  OpenCV-Wrapper.h
//  OpenCV
//
//  Created by Nam Vu on 4/5/18.
//  Copyright © 2018 Grooo International Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

- (void) showHey;
- (UIImage*) thresholding: (UIImage*)image;
- (UIImage*) blackAndWhite: (UIImage*)image;
- (UIImage*) edgeDetection: (UIImage*)image;

@end
