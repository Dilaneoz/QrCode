//
//  ViewController.swift
//  deneme
//
//  Created by Dilan Öztürk on 6.06.2023.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    

    @IBOutlet weak var button: UIButton!
    
    var scannerAvailable: Bool {
        
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    @IBAction func startScanningPressed(_ sender: Any) {
        
        guard scannerAvailable == true else {
            
            print("error: scanner is not available for usage")
            return
        }
        
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.text(), .barcode()], isHighlightingEnabled: true)
        
        dataScanner.delegate = self
        present(dataScanner, animated: true) {
            
            try? dataScanner.startScanning()
        }
    }
}

extension ViewController: DataScannerViewControllerDelegate {
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem){
        
        switch item {
        case .text(let text):
            print("text: \(text.transcript)")
            UIPasteboard.general.string = text.transcript
        case .barcode(let code):
            guard let urlString = code.payloadStringValue else {return}
            guard let url = URL(string: urlString) else {return}
            UIApplication.shared.open(url)
        default:
            print("unexpected item")
        }
    }
}
