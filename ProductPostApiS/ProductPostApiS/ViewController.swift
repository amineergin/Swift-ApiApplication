//
//  ViewController.swift
//  ProductPostApiS
//
//  Created by Intala Lab on 25.03.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!

    
    @IBAction func postProduct(_ sender: UITextField) {
        
        let inputFields: [(name: String, value: String)] = [
                    ("Brand", brandTextField.text ?? ""),
                    ("Color", colorTextField.text ?? ""),
                    ("Model", modelTextField.text ?? ""),
                    ("Price", priceTextField.text ?? ""),
                    ("Size", sizeTextField.text ?? "")
                ]


                for field in inputFields {
                    guard !field.value.isEmpty else {
                        showError(message: "\(field.name) field cannot be empty")
                        return
                    }
                }
        //Bu for döngüsünde kullanıcının her textField alanını doldurup doldurmadığını kontrol ettik.

                let shoeData: [String: Any] = [
                    "ShoeBrand": inputFields[0].value,
                    "ShoeColor": inputFields[1].value,
                    "ShoeModel": inputFields[2].value,
                    "ShoePrice": Double(inputFields[3].value) ?? 0.0,
                    "ShoeSize": Int(inputFields[4].value) ?? 0
                ]
        //Burda (shoeData kısmında) kullanıcının girdiği verilerden bir dictionary oluşturduk.

                do {
                    // Dictionary'yi JSON verisine dönüştürüyoruz.
                    let jsonData = try JSONSerialization.data(withJSONObject: shoeData)
                    
                    //Burda post isteğinde bulunuyoruz.
                    var request = URLRequest(url: URL(string: "https://shoesapi.intalalab.net/api/Shoe")!)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData

                    // URLSession kullanarak POST isteği gönderiyoruz.
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error: \(error)")
                            self.showError(message: "An error occurred while posting the product")
                            return
                        }
                        print("Product successfully posted!")
                    }.resume()
                } catch {
                    print("Error serializing shoe data:", error)
                    showError(message: "An error occurred while posting the product")
                }
            }

            func showError(message: String) {
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
        }
}

