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
    
    
    
}

