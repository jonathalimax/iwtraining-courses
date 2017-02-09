//
//  Aluno.swift
//  Serialization
//
//  Created by Aluno05 on 08/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import Foundation

class Aluno: NSObject, NSCoding {
    
    var codigo: String!
    var nome: String!
    var email: String!
    var telefone: String!
    
    override init() {
        codigo = ""
        nome = ""
        email = ""
        telefone = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.codigo = aDecoder.decodeObject(forKey: "codigo") as! String
        self.nome = aDecoder.decodeObject(forKey: "nome") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.telefone = aDecoder.decodeObject(forKey: "telefone") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.codigo, forKey: "codigo")
        aCoder.encode(self.nome, forKey: "nome")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.telefone, forKey: "telefone")
    }
    
}
