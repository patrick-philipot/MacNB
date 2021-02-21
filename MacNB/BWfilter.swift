//
//  BWfilter.swift
//  MacNB
//
//  Created by patrick philipot on 17/02/2021.
//


import Cocoa

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
    
    let redCoefficient: Double = 0.2126
    let greenCoefficient: Double = 0.7152
    let blueCoefficient: Double = 0.0722
    
    let start = DispatchTime.now() // <<<<<<<<<< Start time

    
    for y in 0..<height {
        for x in 0..<width {
            let index = y * width + x
            var pixel = pixels[index]
            
            // 𝑦=0.3𝑅+0.6𝐺+0.1𝐵
            var avg = Double(Int(pixel.red)) * redCoefficient
            avg = avg + Double(Int(pixel.blue)) * blueCoefficient
            avg = avg + Double(Int(pixel.green)) * greenCoefficient
            let pixelColor = UInt8(avg)
            pixel.red = pixelColor
            pixel.blue = pixelColor
            pixel.green = pixelColor
            pixels[index] = pixel
            
        }
    }
    
    // Atkinson
    
    struct Matrix {
      let row: Int
      let column: Int
    }
    
    let AtkinsonMatrix = [
      Matrix(row: 0, column: 1),
      Matrix(row: 0, column: 2),
      Matrix(row: 1, column: -1),
      Matrix(row: 1, column: 0),
      Matrix(row: 1, column: 1),
      Matrix(row: 2, column: 0)
    ]
    
    for y in 0..<height {
        for x in 0..<width {
            let index = y * width + x
            var pixel = pixels[index]
            
            // lire la valeur de gris
            let gray = pixel.red
            
            // quantification
            let newValue = gray < 128 ? 0 : 255
            
            //affectation
            pixel.red = UInt8(newValue)
            pixel.blue = UInt8(newValue)
            pixel.green = UInt8(newValue)
            
            // error
            let err : Int = Int(gray) - newValue
            
            // 1/8ème de l'erreur à répartir sur les pixels voisins
            let errDiv8 = Int8( err / 8)
            
            for neighbor in AtkinsonMatrix {
              let row = y + neighbor.row
              let column = x + neighbor.column
              // return row * width + column
                var neighborPixel = try? pixels[row * width + column]
                let newGray : Int = Int(neighborPixel?.red ?? 0) + Int(errDiv8)
                neighborPixel?.red = newGray > 255 ? 255 : UInt8(newGray)
                neighborPixel?.blue = newGray > 255 ? 255 : UInt8(newGray)
                neighborPixel?.green = newGray > 255 ? 255 : UInt8(newGray)
                // UInt8(_component + apportionedError > 255 ? 255 : _component + apportionedError)
              
            }
            
            
            


            
        }
    }
    
    
   
    let end = DispatchTime.now()   // <<<<<<<<<<   end time
    
    print("Durée de la conversion en milliseconde(s) ", (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000)
    
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

