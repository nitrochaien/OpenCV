//
//  OpenCV-Wrapper.m
//  OpenCV
//
//  Created by Nam Vu on 4/5/18.
//  Copyright © 2018 Grooo International Inc. All rights reserved.
//

//This has to be implemented before Foundation to prevent conflicts which leads to build errors
#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import <CoreGraphics/CoreGraphics.h>

using namespace std;
using namespace cv;

@implementation OpenCVWrapper

- (void) showHey {
    cout << "Hey" << endl;
}

- (Mat) cvMatFromUIImage: (UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC4);
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (UIImage*) UIImageFromCVMat: (Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    //Creating CGImage from Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    //Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (UIImage*) thresholding: (UIImage*)image {
    int thresholdValue = 0;
    int const maxBinaryValue = 2147483647;
    Mat srcGray = [self cvMatFromUIImage:image];
    Mat dst = srcGray;
    cvtColor(srcGray, dst, COLOR_RGB2GRAY);
    Mat cannyOutput;
    vector<vector<cv::Point>> contours;
    vector<Vec4i> hierarchy;
    RNG rng(12345);
    
    threshold(dst, dst, thresholdValue, maxBinaryValue, THRESH_OTSU);
    
    return [self UIImageFromCVMat:dst];
}

- (UIImage*) blackAndWhite: (UIImage*)image {
    Mat srcGray = [self cvMatFromUIImage:image];
    Mat dst = srcGray;
    cvtColor(srcGray, dst, COLOR_RGB2GRAY);
    
    return [self UIImageFromCVMat:dst];
}

- (UIImage*) edgeDetection: (UIImage*)image {
    int thresholdValue = 0;
    int const maxBinaryValue = 2147483647;
    Mat srcGray = [self cvMatFromUIImage:image];
    Mat dst = srcGray;
    cvtColor(srcGray, dst, COLOR_RGB2GRAY);
    Mat cannyOutput;
    vector<vector<cv::Point>> contours;
    vector<Vec4i> hierarchy;
    RNG rng(12345);
    
    threshold(dst, dst, thresholdValue, maxBinaryValue, THRESH_OTSU);
    
    Mat contourImage(dst.size(), CV_8UC3, Scalar(0, 0, 0));
    Scalar colors[3];
    colors[0] = Scalar(255, 0, 0);
    colors[1] = Scalar(0, 255, 0);
    colors[2] = Scalar(0, 0, 255);
    
    for (int index = 0; index < contours.size(); index++) {
        drawContours(contourImage, contours, index, colors[index % 3]);
    }
    
    return [self UIImageFromCVMat:dst];
}

@end
