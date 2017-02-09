//
//  ViewController.swift
//  Configuracoes
//
//  Created by Aluno05 on 08/02/17.
//  Copyright © 2017 iwtraining. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults()
        print("\(defaults.string(forKey: "id_nome"))")
        print("\(defaults.integer(forKey: "id_idade"))")
        print("\(defaults.string(forKey: "id_email"))")
        print("\(defaults.string(forKey: "id_senha"))")
        print("\(defaults.bool(forKey: "id_solteiro"))")
        
    }

}

