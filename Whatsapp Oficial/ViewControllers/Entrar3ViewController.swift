//
//  Entrar3ViewController.swift
//  Whatsapp Oficial
//
//  Created by João Carlos Paiva on 17/03/22.
//  Copyright © 2022 João Carlos Paiva. All rights reserved.
//

import UIKit
import Firebase

class Entrar3ViewController: UIViewController {
    
    @IBOutlet weak var senha: UITextField!
    var uid = ""
    var emailRecuperado = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Database.database().reference()
        //acessando EXATAMENTE o nó recebido pela EntrarViewController
        let uidUser = database.child(self.uid)
        //recuperando os dados contidos no nó associado ao uid do usuário e os armazenando em dados
        uidUser.observe(DataEventType.childAdded) { (dados) in
            //recuperando o dado associado ao uid do usuário (o email)
            self.emailRecuperado = dados.value as! String
            print(self.emailRecuperado)
        }
    }
    
    //função que ao ser chamada, só precisará preencher o título, a mensagem e o título da ação
    func getAlert (title: String, message: String, titleAction: String) {
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmar = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alerta.addAction(confirmar)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func confirmar(_ sender: Any) {
        if let senhaRecuperada = self.senha.text {
            if senhaRecuperada != "" {
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: self.emailRecuperado, password: senhaRecuperada) { (usuario, erro) in
                    if erro == nil {
                        if usuario == nil {
                            print("erro ao fazer login (usuário igual a nil)")
                            self.getAlert(title: "Ocorreu um erro inesperado", message: "Não conseguimos checar as suas credenciais, bença", titleAction: "Tenta mais tarde ):")
                        }
                        else {
                            print("Sucesso ao fazer login com o usuário")
                            self.performSegue(withIdentifier: "segueLogin", sender: nil)
                        }
                    }else {//caso existam erros...
                        let erroRecuperado = erro! as NSError
                        if let codigoErro = erroRecuperado.code as? Int {
                            switch codigoErro {
                            case 17009:
                                self.getAlert(title: "A senha informada é inválida", message: "Digita uma senha válida, parça", titleAction: "Tentar novamente (:")
                            case 17008:
                                self.getAlert(title: "O E-mail informado é inválido", message: "Digita um E-mail válido, parça", titleAction: "Tentar novamente")
                            case 17011:
                                let alerta = UIAlertController(title: "O E-mail informado não é cadastrado no aplicativo", message: "Cadastre-se! É rapidin (:", preferredStyle: .alert)
                                let cadastrar = UIAlertAction(title: "Cadastrar", style: .default) { (cadastrar) in
                                    self.performSegue(withIdentifier: "voltarCadastro", sender: nil)
                                }
                                alerta.addAction(cadastrar)
                                self.present(alerta, animated: true, completion: nil)
                                
                            default:
                                print(erro!)
                            }
                        }
                    }
                }
            }else {
                self.getAlert(title: "Ocorreu um erro inesperado", message: "Digita uma senha válida aí, namoral", titleAction: "Tentar novamente (:")
            }
        }else {
            self.getAlert(title: "Ocorreu um erro inesperado", message: "Digita uma senha válida aí, namoral", titleAction: "Tentar novamente (:")
        }
    }
}
