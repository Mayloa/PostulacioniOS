//
//  ExtensionUIImageView.swift

//
//  Created by Mayte López Aguilar on 08/01/21.
//  Copyright © 2019 Ennovasoft. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    /**
     Función que permite descargar una imagen por url
     */
    func cargarURL(url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {//scaleAspectFit
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    
                DispatchQueue.main.async() { () -> Void in
                   self.image = UIImage(named: "Default")!
                }
                return
            }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    
    
  /**
  * Funcion   que permitew la descarga de gran  imagenes a traves de url y las guarda en caché para evitar su descarga nuevamente en elementos con celdas reutilizables como lo son  las  tableView, que para este ejercicio se ocupó.
     * En caso de que no se pueda descargar la imagen, se retorna una por default.
 */
    func loadImageUsingCache(withUrl urlString : String, imagenCache: NSCache<NSString, AnyObject>) {
        let url = URL(string: urlString)
        self.image = nil
        if let cachedImage = imagenCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
           
           return
        }
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
          DispatchQueue.main.async {
           if error != nil {
                print(error!)
                let imgDefault = UIImage(named: "Default")!
                imagenCache.setObject(imgDefault, forKey: urlString as NSString)
                self.image = imgDefault
                return
            }


                if let image = UIImage(data: data!) {
                    imagenCache.setObject(image, forKey: urlString as NSString)
                    self.image = image

                }else{
                     let imgDefault = UIImage(named: "Default")!
                      imagenCache.setObject(imgDefault, forKey: urlString as NSString)
                    self.image = imgDefault
                }
            }
        }).resume()
    }
}

