//
//  ViewController.swift
//  MacNB
//
//  Created by patrick philipot on 15/02/2021.
//

import Cocoa
import Accelerate

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var sampleIMG: NSImageView!
    
    
    
    
    
    
    
    
    
    @IBAction func AtkinsonButton(_ sender: NSButton) {
        print("kvImageConvert_DitherAtkinson")
//        let sourceImage = NSImage(named: "buz")!
//
//        var imageRect = CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height)
//        guard let cgImage = sourceImage.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return  }
//
//        // 1: Create a format that describes the source image.
//        var cmykSourceImageFormat = vImage_CGImageFormat(
//            bitsPerComponent: 8,
//            bitsPerPixel: 32,
//            colorSpace: Unmanaged.passRetained(CGColorSpaceCreateDeviceCMYK()),
//            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
//            version: 0,
//            decode: nil,
//            renderingIntent: .defaultIntent)
//
//        // 2: Create a format that describes the destination image.
//        var rgbDestinationImageFormat = vImage_CGImageFormat(
//            bitsPerComponent: 8,
//            bitsPerPixel: 32,
//            colorSpace: nil,
//            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
//            version: 0,
//            decode: nil,
//            renderingIntent: .defaultIntent)
//
//        // 3: Create a converter based on the source and destination formats.
//        let cmykToRgbUnmanagedConverter = vImageConverter_CreateWithCGImageFormat(
//            &cmykSourceImageFormat,
//            &rgbDestinationImageFormat,
//            nil,
//            vImage_Flags(kvImageConvert_DitherAtkinson),
//            nil)
//
//
//        guard let cmykToRgbConverter = cmykToRgbUnmanagedConverter?.takeRetainedValue() else {
//            return
//        }
//
//        // 4: Verify the number of source and destination buffers.
//        assert(vImageConverter_GetNumberOfSourceBuffers(cmykToRgbConverter) == 1,
//               "Number of source buffers should be 1.")
//        assert(vImageConverter_GetNumberOfDestinationBuffers(cmykToRgbConverter) == 1,
//               "Number of destination buffers should be 1.")
//
//        // 5: Create and initialize the destination buffer.
//        // Assumes `cmykSourceBuffer` exists and contains 16-bit-per-channel CMYK image data.
////        var rgbDestinationBuffer = vImage_Buffer()
////        vImageBuffer_Init(&rgbDestinationBuffer,
////                          cgImage.height,
////                          cgImage.width,
////                          rgbDestinationImageFormat.bitsPerPixel,
////                          vImage_Flags(kvImageNoFlags))
//
//        let sourceBuffer = try? vImage_Buffer(cgImage: cgImage )
//        var rgbDestinationBuffer = try? vImage_Buffer(cgImage: cgImage)
//
//        // 6: Call convert-any-to-any.
//        vImageConvert_AnyToAny(
//            cmykToRgbConverter,
//            sourceBuffer,
//            rgbDestinationBuffer,
//            nil,
//            vImage_Flags(kvImagePrintDiagnosticsToConsole))
//
//
//
//
//
//
//        guard
//            let cgImage = sourceImage?.cgImage,
//            let sourceImageFormat = vImage_CGImageFormat(cgImage: cgImage as! CGImage),
//            let rgbDestinationImageFormat = vImage_CGImageFormat(
//                bitsPerComponent: 8,
//                bitsPerPixel: 32,
//                colorSpace: CGColorSpaceCreateDeviceRGB(),
//                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
//                renderingIntent: .defaultIntent)
//        else {
//                    print("Unable to initialize cgImage or colorSpace.")
//                    return
//        }
//
//        guard
//            let sourceBuffer = try? vImage_Buffer(cgImage: cgImage as! CGImage),
//            var rgbDestinationBuffer = try? vImage_Buffer(width: Int(sourceBuffer.width),
//                                                          height: Int(sourceBuffer.height),
//                                                          bitsPerPixel: rgbDestinationImageFormat.bitsPerPixel) else {
//                                                            fatalError("Error initializing source and destination buffers.")
//        }
//
//        do {
//            let toRgbConverter = try vImageConverter.make(sourceFormat: sourceImageFormat,
//                                                          destinationFormat: rgbDestinationImageFormat)
//
//            try toRgbConverter.convert(source: sourceBuffer,
//                                       destination: &rgbDestinationBuffer)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//
//        vImageConvert_Planar8toPlanar1(sourceBuffer,&rgbDestinationBuffer,nil,
//
//        do {
//            sourceBuffer.free()
//            rgbDestinationBuffer.free()
//        }
//
//
//        // vImageConvert_Planar8toPlanar1()
//
//
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func buzzButton(_ sender: NSButton) {
        sampleIMG.image = NSImage(named: "buz")
    }
    
    
    @IBAction func testBTN(_ sender: NSButton) {
        print("Bouton TEST")
        sampleIMG.image = applyFilter(to: sampleIMG.image!)

    }
    
    @IBAction func selectImage(_ sender: NSButton) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose an image | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.allowedFileTypes        = ["png", "jpg", "jpeg", "gif"];

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path
                
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/tiger.jpeg
                print(path)
                sampleIMG.image = NSImage(byReferencingFile: path)
                
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    
}

