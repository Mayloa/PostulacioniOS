//
//  DescripcionCell.swift
//  Postulacion
//
//  Created by Mayte López Aguilar on 08/01/21.
//

import UIKit
/**
 Clase que contiene los elementos de la celda donde se muestra el detalle del show.
 */
class DescripcionCell: UITableViewCell {

    
    @IBOutlet weak var Clave: UILabel!
    @IBOutlet weak var Descripcion: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
