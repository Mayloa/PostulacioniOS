//
//  ViewController.swift
//  PostulacioniOS
//
//  Created by Mayte López Aguilar on 15/01/21.
//

import UIKit

@available(iOS 13.0, *)
class PeliculasViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageCache = NSCache<NSString, AnyObject>() // collecion utilizada para almacenar la lista de imagenes de de cada pelicula y asi evitar que se carguen cada que la vista se desplaza.
    
    
    var baseURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=634b49e294bd1ff87914e7b9d014daed"
    var datosApi : DatosPeliculas!
    
    var peliculas : [Result] = []
    
    var datosPelicula  : DetallePelicula!
    
    private let refreshControl = UIRefreshControl()
    
    var label: UILabel! // etiqueta utilizada para mostrar un mensaje en la vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Se establece la celda a utilizar y se le reasigna un identificador a la misma
        let nib = UINib(nibName: "ContenedorPeliculas", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        
        self.configurarFlowLayout()
        self.configurarRefreshControl()
        self.consumirWebService()
        
        
        
        // se establece el tamaño y en donde se mostrará el label que muestra el mensaje cuando ocurre algun error
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
        
    }
    
    /**
     Funcion donde se establecen las proiedades del flowLayout de la collectionView
     */
    func configurarFlowLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:(width-10)  / 2, height: 350)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        self.collectionView!.collectionViewLayout = layout
    }
    /**
     Metodo utilizado para estalecer el refresh control a la collectionView
     */
    func configurarRefreshControl(){
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            self.collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    /**
     Metodo utilizado para ejecutar el pull to refresh
     */
    @objc func refreshData(_ sender: Any) {
        self.consumirWebService()
        self.refreshControl.endRefreshing()
    }
    
    
    /**
     Funcion utilizada para consumir la api desde internet.
     * En caso de ocurrir un error, muestra un mensa informativo
     *Si la peticion se ejecuta correctamente, se castean los datos a un arreglo temporal, posteriormente se almacenan en core data y se consultan los datos previamenten almacenados.
     */
    func consumirWebService(){
        peliculas = []
        imageCache = NSCache<NSString, AnyObject>()
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: self.baseURL) as URL?
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    self.datosApi = try decoder.decode(DatosPeliculas.self, from: data)
                    if let resultados = self.datosApi.results{
                        self.peliculas = resultados
                        
                    }else{
                        self.peliculas = []
                    }
                    
                    if self.peliculas.count == 0{
                        self.mostrarMsjError(mensaje: "No hay películas para mostrar")
                    }else{
                        DispatchQueue.main.async {
                            self.label.isHidden = true
                            
                        }
                    }
                    
                } catch {
                    self.mostrarMsjError(mensaje: "Error al serializar la información")
                }
                DispatchQueue.main.async { // se recarga la vista para que se visualice la informacion
                    self.collectionView.reloadData()
                }
            }else{
                self.mostrarMsjError(mensaje: "Error al obtener datos")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }).resume()
        
        
    }
    /**
     Metodo que contiene las propiedades y el mensaje de error que se muestra en la vista en caso de ocurrir algun error.
     */
    func mostrarMsjError(mensaje: String){
        DispatchQueue.main.async {
            self.label.isHidden = false
            self.label.text = mensaje
            self.label.textColor = UIColor.darkGray
            self.label.font = UIFont(name: "Futura-Medium", size: 38.0)
            self.label.numberOfLines = 0
            self.label.textAlignment = .center
            self.collectionView.backgroundView = self.label
        }
    }
    
    
    /**
     En este metodo, pasamos la informacion de la pelicula que se mostrará en la otra pantalla.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MostrarDetalle"{
            let destinationViewController = segue.destination as! DetallePeliculaViewController
            destinationViewController.datosPelicula = self.datosPelicula
        }
    }
    
    
    /*
     Metodo utilizado para consumir la información de la pelicula que se muestra en la otra vista.
     */
    func obtenerDatosPelicula(id: Int, sender : IndexPath){
        let  url = "https://api.themoviedb.org/3/movie/\(id)?api_key=634b49e294bd1ff87914e7b9d014daed"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    self.datosPelicula = try decoder.decode(DetallePelicula.self, from: data)
                    
                } catch {
                    DispatchQueue.main.async {
                        self.mostrarAlertError(title: "Error", message: "No se pudieron serializar los datos de la película")
                    }
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "MostrarDetalle", sender: sender)
                }
            }else{
                DispatchQueue.main.async {
                    self.mostrarAlertError(title: "Información", message: "No se encontraron datos de la película")
                }
            }
            
        }).resume()
        
    }
    
    /**
     Metodo utilizado para configurar el alert de error que se  muestra cuando no se puede obtener el detalle de la pelicula seleccionada.
     */
    func mostrarAlertError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}


//MARK: Extension UICollectionViewDataSource

@available(iOS 13.0, *)
extension PeliculasViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.peliculas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
            ContenedorPeliculasCell
        
        let datosPelicula : Result!
        datosPelicula = self.peliculas[indexPath.row]
        let url = "https://image.tmdb.org/t/p/w500/\(datosPelicula.poster_path!)"
        
        cell.imagen.layer.cornerRadius = 10
        cell.imagen.clipsToBounds = true
        
        cell.imagen.loadImageUsingCache(withUrl: url, imagenCache: imageCache)
        cell.titulo.text = datosPelicula.title
        cell.fecha.text = datosPelicula.release_date
        cell.valoracion.text = "\(datosPelicula.vote_average!)"
        
        return cell
    }
    
    
    
}

//MARK: Extension UICollectionViewDelegate

@available(iOS 13.0, *)
extension PeliculasViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let datosPelicula : Result!
        datosPelicula = self.peliculas[indexPath.row]
        self.obtenerDatosPelicula(id: datosPelicula.id!, sender: indexPath)
    }
}
