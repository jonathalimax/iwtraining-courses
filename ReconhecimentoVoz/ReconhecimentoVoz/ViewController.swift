//
//  ViewController.swift
//  ReconhecimentoVoz
//
//  Created by Aluno03 on 01/03/17.
//  Copyright © 2017 jonathalima. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var txtConteudo: UITextView!
    @IBOutlet weak var btnAcao: UIButton!
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "pt-BR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAcao.isEnabled = false
        btnAcao.setTitle("Começar", for: .normal)
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isEnabled = false
            
            switch authStatus {
            case .authorized:
                isEnabled = true
                print("Acesso autorizado")
            case .denied:
                isEnabled = false
                print("Acesso negado pelo usuário")
            case .restricted:
                isEnabled = false
                print("Acesso negado pelo sistema")
            case .notDetermined:
                isEnabled = false
                print("Erro desconhecido")
            }
            
            OperationQueue.main.addOperation {
                self.btnAcao.isEnabled = isEnabled
            }
        }
        
    }

    // Ação dos botões
    @IBAction func acaoReconhecimento(_ sender: Any) {
        if audioEngine.isRunning {
            btnAcao.setTitle("Começar", for: .normal)
        } else {
            comecarGravacao()
            btnAcao.setTitle("Parar", for: .normal)
        }
    }
    
    func comecarGravacao() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
        } catch let error {
            print("Propriedades do audioSession não configuradas. Erro - \(error.localizedDescription)")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        if audioEngine.inputNode == nil {
            fatalError("Audio engine sem inputNode")
        }
        
        if recognitionRequest == nil {
            fatalError("Não foi possível criar o objeto SFSpeechAudioBufferRecognitionRequest")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.txtConteudo.text = result?.bestTranscription.formattedString
                isFinal = result!.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode?.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.btnAcao.isEnabled = true
            }
        })
        
        let recordinFormat = audioEngine.inputNode?.outputFormat(forBus: 0)
        audioEngine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordinFormat) { (buffer, when) in
            
            self.recognitionRequest?.append(buffer)
            
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch let error {
            fatalError("audioEngine não iniciado. Erro: \(error.localizedDescription)")
        }
        txtConteudo.text = "Já pode falar boy!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            btnAcao.isEnabled = true
        } else {
            btnAcao.isEnabled = false
        }
    }
}

