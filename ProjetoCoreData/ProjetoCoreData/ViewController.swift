//
//  ViewController.swift
//  ProjetoCoreData
//
//  Created by Aluno05 on 09/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txtNome:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtTelefone:UITextField!
    @IBOutlet weak var tblAluno:UITableView!
    var alunos:[Alunos]!
    var indexRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAluno.delegate = self
        tblAluno.dataSource = self
        alunos = []
        
        self.carregarAlunos()
    }
    
    @IBAction func limpar(_ sender:Any) {
        limparCampos()
    }
    
    @IBAction func atualizar(_ sender:Any) {
        
        if indexRow != nil {
            
            let alunoSelecionado = alunos[indexRow!]
            alunoSelecionado.nome = txtNome.text
            alunoSelecionado.email = txtEmail.text
            alunoSelecionado.telefone = txtTelefone.text
            
            do {
                try self.getContext().save()
                self.carregarAlunos()
                self.indexRow = nil
            } catch let err {
                print("\(err.localizedDescription)")
            }
        }
    }
    
    @IBAction func salvar(_ sender:Any) {
        
        let aluno = NSEntityDescription.insertNewObject(forEntityName: "Alunos", into: self.getContext()) as! Alunos
        
        aluno.nome = txtNome.text
        aluno.email = txtEmail.text
        aluno.telefone = txtTelefone.text
        
        do {
            try getContext().save()
            self.limpar(self)
            self.carregarAlunos()
        } catch let err {
            print("\(err.localizedDescription)")
        }
        
    }
    
    func carregarAlunos() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Alunos")
        
        do {
            alunos = try getContext().fetch(request) as! [Alunos]
            
            tblAluno.reloadData()
            
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
    
    func excluirAluno(index: Int) {
        
        let aluno = alunos[index]
        self.getContext().delete(aluno)
        
        do {
            try self.getContext().save()
            self.carregarAlunos()
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getContext() -> NSManagedObjectContext {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        return context
    }
    
    func limparCampos() {
        txtNome.text = ""
        txtEmail.text = ""
        txtTelefone.text = ""
        indexRow = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "id")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
        }
        
        cell?.textLabel?.text = alunos[indexPath.row].nome
        cell?.detailTextLabel?.text = alunos[indexPath.row].email
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexRow = indexPath.row
        
        txtNome.text = alunos[indexRow!].nome
        txtEmail.text = alunos[indexRow!].email
        txtTelefone.text = alunos[indexRow!].telefone
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.excluirAluno(index: indexPath.row)
    }
    
    func alertaSucesso() {
        let alerta = UIAlertController(title: "Os dados foram armazenados!", message: "", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}

