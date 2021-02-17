//
//  ViewController.swift
//  MacNB
//
//  Created by patrick philipot on 15/02/2021.
//

import Cocoa

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
    
    func applyFilter(to image: NSImage) -> NSImage? {
        print("ApplyFilter")
        
        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return nil }
        
        // Redraw image for correct pixel format
        var colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        var bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        guard let imageContext = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                var pixel = pixels[index]
                
                // 𝑦=0.3𝑅+0.6𝐺+0.1𝐵
                var avg = Double(Int(pixel.red)) * 0.3
                avg = avg + Double(Int(pixel.blue)) * 0.1
                avg = avg + Double(Int(pixel.green)) * 0.6
                let pixelColor = UInt8(avg)
                pixel.red = pixelColor
                pixel.blue = pixelColor
                pixel.green = pixelColor
                pixels[index] = pixel
            }
        }
        
        colorSpace = CGColorSpaceCreateDeviceRGB()
        bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        bytesPerRow = width * 4
        
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return nil }
        
        guard let newCGImage = context.makeImage() else { return nil }
        
        return NSImage(cgImage: newCGImage, size: NSSize.zero)
        // return nil
    }
    
    public struct Pixel {
        public var value: UInt32
        
        public var red: UInt8 {
            get {
                return UInt8(value & 0xFF)
            } set {
                value = UInt32(newValue) | (value & 0xFFFFFF00)
            }
        }
        
        public var green: UInt8 {
            get {
                return UInt8((value >> 8) & 0xFF)
            } set {
                value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
            }
        }
        
        public var blue: UInt8 {
            get {
                return UInt8((value >> 16) & 0xFF)
            } set {
                value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
            }
        }
        
        public var alpha: UInt8 {
            get {
                return UInt8((value >> 24) & 0xFF)
            } set {
                value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
            }
        }
    }

    
}

