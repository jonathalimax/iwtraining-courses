//
//  ViewController.swift
//  Serialization
//
//  Created by Aluno05 on 08/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    var aluno: Aluno?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func limpar(_ sender:Any) {
        txtCodigo.text = ""
        txtNome.text = ""
        txtEmail.text = ""
        txtTelefone.text = ""
    }
    
    @IBAction func carregar(_ sender:Any) {
        
        if FileManager.default.fileExists(atPath: caminho()) {
            
            let dados = try? Data(contentsOf: URL(fileURLWithPath: self.caminho()))
            let desarquivador = NSKeyedUnarchiver(forReadingWith: dados!)
            let aluno = desarquivador.decodeObject(forKey: "chave") as! Aluno
            
            txtCodigo.text = aluno.codigo
            txtNome.text = aluno.nome
            txtEmail.text = aluno.email
            txtTelefone.text = aluno.telefone

        } else {
            print("Arquivo não existe")
        }
        
    }
    
    @IBAction func gravar(_ sender:Any) {
        
        aluno = Aluno()
        aluno?.codigo = txtCodigo.text
        aluno?.nome = txtNome.text
        aluno?.email = txtEmail.text
        aluno?.telefone = txtTelefone.text
        
        let dados = NSMutableData()
        
        let arquivador = NSKeyedArchiver(forWritingWith: dados)
        arquivador.encode(aluno, forKey: "chave")
        arquivador.finishEncoding()
        
        let sucesso = dados.write(toFile: caminho(), atomically: true)
        
        if sucesso {
            alertaSucesso()
            limpar(self)
        } else {
            print("Impossível armazenar")
        }
    
    }
    
    func caminho() -> String {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documentPath + "/dados.txt"
    }

    func alertaSucesso() {
        let alerta = UIAlertController(title: "Sucesso", message: "Salvo com sucesso!", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
}

