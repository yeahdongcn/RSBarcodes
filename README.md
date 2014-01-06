RSBarcodes
==========

RSBarcodes allows you to scan 1D and 2D barcodes using metadata scanning capabilities introduced with iOS7 and generate the same set of barcode images for displaying and sharing.

Current status
------------

###Barcode scanner:
    Multiple corners and border rectangles display view -- WIP
    Manually changing focus point -- WIP

###Barcode generators:
    "org.gs1.UPC-E", -- Done
    "org.iso.Code39", -- Done
    "org.iso.Code39Mod43", -- Done
    Full ASCII Code 39, -- Done
    "org.gs1.EAN-13", -- WIP by ZhangXi
    "org.gs1.EAN-8", -- WIP by ZhangXi
    "com.intermec.Code93", -- Done
    "org.iso.Code128", -- Done
    "org.iso.PDF417", -- Done
    "org.iso.QRCode", -- Done
    "org.iso.Aztec" -- Done
    
    Code display view -- Done
    
Installation
------------

Usage
------------

###Barcode scanner:

Place a ‘UIViewController’ in storyboard and set ‘RSScannerViewController’ based class as its custom class. If you want to use the corners view (for barcode corners and borders displaying), you can put a ‘UIView’ onto the view controller’s view and set ‘RSCornersView’ as its custom class then link the ‘highlightView’ to it, make sure the view’s size is as large as the view controller’s view.

In ‘RSScannerViewController’ based class implements your own handler.

    - (id)initWithCoder:(NSCoder *)aDecoder
    {
        self = [super initWithCoder:aDecoder];
        if (self) {
            __weak typeof(self) weakSelf = self;
            self.handler = ^(NSArray *codeObjects) {
            };
        }
        return self;
    }

###Barcode generators:

Import ‘RSCodeGen.h’ into your source file and using ‘CodeGen’ to generate barcode image. RSBarcodes provides 2 ways.

    @protocol RSCodeGenerator <NSObject>

    - (UIImage *)genCodeWithMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)machineReadableCodeObject;

    - (UIImage *)genCodeWithContents:(NSString *)contents machineReadableCodeObjectType:(NSString *)type;

    @end

Here are examples, the generated image could be used along with ‘RSCodeView’ or ‘UIImageView’.

    [CodeGen genCodeWithContents:<#(NSString *)#> machineReadableCodeObjectType:<#(NSString *)#>] // Types are coming from AVMetadataObject.h and RSCodeGen.h

or

    [CodeGen genCodeWithMachineReadableCodeObject:<#(AVMetadataMachineReadableCodeObject *)#>]

License
------------

    The MIT License (MIT)

    Copyright (c) 2012-2014 P.D.Q.

------------  
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/yeahdongcn/rsbarcodes/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

