//
//  ViewController.swift
//  ProjetoCoreData
//
//  Created by Aluno05 on 09/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var txtNome:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtTelefone:UITextField!
    @IBOutlet weak var tblAluno:UITableView!
    var alunos:[Alunos]!
    var indexRow: Int?
    var filtro: String?
    
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
            
            let aluno = alunos[indexRow!]
            aluno.nome = txtNome.text
            aluno.email = txtEmail.text
            aluno.telefone = txtTelefone.text
            
            self.atualizarAlunoNoBanco()
            
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
        
        if filtro != nil {
            request.predicate = NSPredicate(format: "nome contains[c] %@", filtro!)
        }
        
        do {
            alunos = try getContext().fetch(request) as! [Alunos]
            
            tblAluno.reloadData()
            
            filtro = nil
            
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
        cell?.accessoryType = .detailButton
        
        if alunos[indexPath.row].foto != nil {
            cell?.imageView?.image = UIImage(data: alunos[indexPath.row].foto!)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("\(alunos[indexPath.row].telefone)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexRow = indexPath.row
        
        let alert = UIAlertController(title: "Fotografia", message: "Escolha uma opção", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler: { (UIAlertAction) in
            
            self.camera()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Editar Cadastro", style: .default, handler: { (UIAlertAction) in
            
            self.txtNome.text = self.alunos[self.indexRow!].nome
            self.txtEmail.text = self.alunos[self.indexRow!].email
            self.txtTelefone.text = self.alunos[self.indexRow!].telefone
            
        }))
        
        present(alert, animated: true, completion: nil)
        
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
    
    // UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        
        if searchText != "" {
            filtro = searchText
            carregarAlunos()
        } else {
            carregarAlunos()
        }
        
    }
    
    // funcs
    
    func camera() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageOriginal = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageEditada = info[UIImagePickerControllerEditedImage] as? UIImage
        
        let foto: UIImage
        
        if imageEditada == nil {
            foto = imageOriginal
            print("Imagem Original")
        } else {
            foto = imageEditada!
            print("Image Editada")
        }
        
        // UPDATE NO BANCO
        
        alunos[indexRow!].foto = UIImageJPEGRepresentation(foto, 1.0)
        
        self.atualizarAlunoNoBanco()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func atualizarAlunoNoBanco() {
        
        do {
            try self.getContext().save()
            self.carregarAlunos()
            self.indexRow = nil
        } catch let err {
            print("\(err.localizedDescription)")
        }
        
    }
}

