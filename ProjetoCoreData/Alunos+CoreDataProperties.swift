//
//  Alunos+CoreDataProperties.swift
//  ProjetoCoreData
//
//  Created by Aluno05 on 09/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import Foundation
import CoreData


extension Alunos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alunos> {
        return NSFetchRequest<Alunos>(entityName: "Alunos");
    }

    @NSManaged public var email: String?
    @NSManaged public var nome: String?
    @NSManaged public var telefone: String?
    @NSManaged public var foto: Data?

}
