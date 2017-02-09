//
//  ViewController.swift
//  PersistenciaBasica
//
//  Created by Aluno05 on 08/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txTelefone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func gravarAction (_ sender: Any) {
        
        var aluno = [String:String]()
        aluno["codigo"] = txtCodigo.text
        aluno["nome"] = txtNome.text
        aluno["email"] = txtEmail.text
        aluno["telefone"] = txTelefone.text
        
        let gravou = (aluno as NSDictionary).write(toFile: self.caminho(), atomically: true)
        
        if gravou {
            print("Sucesso")
            self.limparAction(self)
            alerta()
        } else {
            print("Falhou")
        }
    }
    
    @IBAction func carregarAction (_ sender: Any) {
        
        if FileManager.default.fileExists(atPath: self.caminho()) {
            
            let aluno = NSDictionary(contentsOfFile: self.caminho()) as! Dictionary<String, String>
            
            txtCodigo.text = aluno["codigo"]
            txtNome.text = aluno["nome"]
            txtEmail.text = aluno["email"]
            txTelefone.text = aluno["telefone"]
            
        } else {
            print("Arquivo não encontrado")
        }
        
    }
    
    @IBAction func limparAction (_ sender: Any) {
        txtCodigo.text = ""
        txtNome.text = ""
        txtEmail.text = ""
        txTelefone.text = ""
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func caminho() -> String {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documentPath + "/dados.txt"
    }
    
    func alerta() {
        
        let alerta = UIAlertController(title: "Sucesso!", message: "Os dados foram salvos!", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alerta, animated: true, completion: nil)
        
    }
}

