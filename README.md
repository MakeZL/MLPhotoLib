# MLPhotoLib
A New PhotoLib, Compatible with iOS7+, Simple, lightweight 

Being Continual updates.. You are welcome to use.

# Sketch
<img src="https://github.com/MakeZL/MLPhotoLib/blob/master/DemoSketch/Demo1.png" width="320"><br/>
<img src="https://github.com/MakeZL/MLPhotoLib/blob/master/DemoSketch/Demo2.png" width="320">

# Use
    // UIViewController.m
    MLImagePickerViewController *pickerVC = [MLImagePickerViewController pickerViewController];
    // Limit Count
    pickerVC.maxCount = 3;
    // Recoder
    pickerVC.selectAssetsURL = self.selectUrls;
    WeakSelf
    [pickerVC displayForVC:self
          completionHandle:^(BOOL success,
                             NSArray<NSURL *> *assetUrls,
                             NSArray<UIImage *> *thumbImages,
                             NSArray<UIImage *> *originalImages,
                             NSError *error) {
              if (success) {
                NSLog(@" Success! ----- ");

                weakSelf.selectUrls = assetUrls;
                weakSelf.selectThumbImages = thumbImages;
                weakSelf.selectOriginalImages = originalImages;
                [weakSelf.collectionView reloadData];

                NSLog(@" assetUrls -- :%@", assetUrls);
                NSLog(@" thumbImages -- :%@", thumbImages);
                NSLog(@" originalImages -- :%@", originalImages);
            }
        }];

# Contact
@weibo : [我的微博](http://weibo.com/makezl/)

# License

MLPhotoLib is published under MIT License

    Copyright (c) 2016 MakeZL (@MakeZL)

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
    Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.