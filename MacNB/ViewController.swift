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
        // sampleIMG.imageScaling = .scaleAxesIndependently
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var sampleIMG: NSImageView!
    
    // Bouton Atkinson, convertit l'image couleur
    // en image composée de pixels soit noir, soit blanc
    // mais avec un tramage Atkinson
    @IBAction func AtkinsonButton(_ sender: NSButton) {
        sampleIMG.image = applyFilter(to: sampleIMG.image!, withAtkinsonDithering: true)
        savePNG(image: sampleIMG.image!)
    }
    
    // Bouton Choisir Buzz
    @IBAction func buzzButton(_ sender: NSButton) {
        sampleIMG.image = NSImage(named: "buz")
    }
    
    // Bouton N&B, chaque pixel de couleur
    // devient soit noir, soir blanc
    @IBAction func onlyNB(_ sender: NSButton) {
        print("Uniquement des pixels blanc ou noir")
        sampleIMG.image = nbFilter(to: sampleIMG.image!)
    }
    
    // Bouton Convertir en N&B
    @IBAction func testBTN(_ sender: NSButton) {
        print("Bouton TEST")
        sampleIMG.image = applyFilter(to: sampleIMG.image!)
    }
    
    //  Bouton Choisir une image
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
                sampleIMG.imageScaling = .scaleProportionallyUpOrDown
                
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func savePNG(image: NSImage) -> Bool {
        let myURL: URL = URL(fileURLWithPath: "export.png")
            let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
            let pngData = imageRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
            return (try!(pngData?.write(to: myURL)) != nil)
        }
    
    
}

