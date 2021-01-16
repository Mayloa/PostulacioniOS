//
//  DetalleShowViewController.swift
//  Postulacion
//
//  Created by Mayte López Aguilar on 15/01/21.
//

import UIKit

/**
 Clase utilizada para mostrar la información de la pelicula seleccionada
 */
@available(iOS 13.0, *)
class DetallePeliculaViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var datosPelicula  : DetallePelicula!
    
    var idPelicula: String!
   
    var urlPelicula = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //se establece el titulo de la navigation
        self.title = ""
        
       
        //Se carga la imagen de la pelicula
        let url = NSURL(string: ("https://image.tmdb.org/t/p/w500/\(datosPelicula.poster_path!)"))
        self.imagen.cargarURL(url: url! as URL)
        
        //Se registra la celda utilizada en la tabla para mostrar la información de la pelicula y se le asigna un identificador
        let nib = UINib(nibName: "Descripciones", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "celda")
        
        
        // Aplicar color de fondo a la tabla
        self.tableView.backgroundColor = UIColor(red: 214.0/255.0, green: 253.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        //Para desaparecer todo lo que esta después de la última celda
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Cambiar el color del seprador de las celdas
        self.tableView.separatorColor = UIColor (red: 25.0/255.0, green: 205.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        
    }
 
 
}
//MARK: Extensiones UITableView DataSource
@available(iOS 13.0, *)
extension DetallePeliculaViewController : UITableViewDataSource{
    /**
     Se establecieron 5 celdas para la tabla las cuales contendrán la información a mostrar de la pelicula seleccionada
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /**
     Aquí definimos la información que va a mostrar cada celda de la tabla
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! DescripcionCell
        
        cell.backgroundColor = UIColor.clear
        switch indexPath.row {
        case 0:
            cell.Clave.text = "Título:"
            cell.Descripcion.text =  datosPelicula.title
        case 1:
            cell.Clave.text = "Duración:"
            cell.Descripcion.text =  "\(datosPelicula.runtime!) min."
        case 2:
            cell.Clave.text = "Clasificación:"
            cell.Descripcion.text =  "\(datosPelicula.vote_average!)"
        case 3:
            cell.Clave.text = "Género:"
            
            var cad = ""
            for genero in datosPelicula.genres!{
                cad = cad + genero.name! + ", "
            }
           
            cad.removeLast(2)
            
            cell.Descripcion.text = cad
        
        default:
            cell.Clave.text = "Descripción:"
            cell.Descripcion.text = datosPelicula.overview
            break
        }
        
        return cell
    }
    
    
}
