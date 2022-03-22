//
//  EntrarViewController.swift
//  Whatsapp Oficial
//
//  Created by João Carlos Paiva on 15/03/22.
//  Copyright © 2022 João Carlos Paiva. All rights reserved.
//

import UIKit
import Firebase

class EntrarViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    var database: DatabaseReference!
    
    //criando um identificador único
    var valorAleatorio = NSUUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //função que ao ser chamada, só precisará preencher o título, a mensagem e o título da ação
    func getAlert (title: String, message: String, titleAction: String) {
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmar = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alerta.addAction(confirmar)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func continuar(_ sender: Any) {
        if let emailR = self.email.text {
            if emailR != "" {
                self.database = Database.database().reference()
                //criando e salvando no database um nó com o valor aleatório criado e associando-o ao email recuperado
                let dadosUser = self.database.child(self.valorAleatorio)
                let dados = ["email": emailR]
                dadosUser.setValue(dados)
                self.performSegue(withIdentifier: "continuar", sender: nil)
            }else {
                self.getAlert(title: "Ocorreu um erro", message: "Digite um E-mail válido para continuar o login, manin", titleAction: "Tentar novamente (:")
            }
        }
    }
    
    //enviando o valor aleatório para uma variável criada na Entrar2ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continuar" {
            let acesso = segue.destination as! Entrar3ViewController
            acesso.uid = self.valorAleatorio
        }
    }
    
    
    
    
}
