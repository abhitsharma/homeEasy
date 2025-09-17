//
//  SearchViewControler.swift
//  HomeEassy
//
//  Created by Macbook on 14/09/23.
//

import UIKit
import Speech
let KSearchTableViewCell = "SearchTableViewCell"
let KSearchHeaderView = "SearchHeaderView"
class SearchViewControler: BaseVC, SFSpeechRecognizerDelegate ,UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var speechButton = UIButton(type: .custom)
    var arrSearchHistory: [String]!
    var arrTrendingSearch: [String]!
    let audioEngine = AVAudioEngine()
        let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
        let request = SFSpeechAudioBufferRecognitionRequest()
        var recognitionTask: SFSpeechRecognitionTask?
        var isRecording = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchbar()
        requestSpeechAuthorization()
        speechButton.isSelected = false
        addSpeechButtonToNavigationBar()
        tableView.register(UINib(nibName: KSearchTableViewCell, bundle: nil), forCellReuseIdentifier: KSearchTableViewCell)
        tableView.registerNibName(KSearchHeaderView, forCellHeaderFooter: KSearchHeaderView)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error setting up AVAudioSession:", error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle("", inMiddle: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func setSearchbar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search products"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setBackgroundImage(UIImage(named: "unhide"), for: .normal, barMetrics: .compact)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor: UIColor(named: "CustomBlack")!], for: .normal)
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.font = UIFont(name: NiveauGrotesk.regular.rawValue, size: 12)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.inputView?.addSubview(speechButton)
        definesPresentationContext = true
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechButton.isEnabled = true
                case .denied:
                    self.speechButton.isEnabled = false
                  //  self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.speechButton.isEnabled = false
                   // self..text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.speechButton.isEnabled = false
                    //self.detectedTextLabel.text = "Speech recognition not yet authorized"
                @unknown default:
                    return
                }
            }
        }
    }

    func addSpeechButtonToNavigationBar() {
        //let speechButton = UIButton(type: .system)
        speechButton.tintColor = UIColor(named: "CustomBlack")
        speechButton.setImage(UIImage(systemName: "mic"), for: .normal)
        speechButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        speechButton.setTitleColor(UIColor(named: "CustomBlack"), for: .normal)
        speechButton.setTitleColor(UIColor.red, for: .selected)
        let speechBarButtonItem = UIBarButtonItem(customView: speechButton)
        navigationItem.rightBarButtonItem = speechBarButtonItem
        searchController.searchBar.inputView?.addSubview(speechButton)
        navigationItem.searchController?.inputView?.addSubview(speechButton)
    }
    
    

    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechButton.isEnabled = true
        } else {
            speechButton.isEnabled = false
        }
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        
        if isRecording == true {
           cancelRecording()
            //speechToText.stopTranscribing()
            isRecording = false
            speechButton.tintColor =  UIColor(named: "CustomBlack")
        } else {
            self.recordAndRecognizeSpeech()
            //speechToText.resetTranscript()
           // speechToText.startTranscribing()
            searchController.isActive = true
            //searchController.searchBar.searchTextField. = false
            isRecording = true
            speechButton.tintColor = UIColor.red
        }
    }
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
//MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
        
                self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: { [self] in
            if  recognitionTask != nil{
                isRecording = false
                cancelRecording()
            }
        })
        
    }
    
    
    deinit{
        if  recognitionTask != nil{
            isRecording = false

            cancelRecording()
        }
    }
    func checkForColorsSaid(resultString: String) {
//        guard let color = Color(rawValue: resultString) else { return }
//        colorView.backgroundColor = color.create
        self.searchController.searchBar.searchTextField.text = resultString
        self.searchFunction(with: resultString,searchController.searchBar)
    }
    func searchFunction(with searchText: String,_ searchBar: UISearchBar) {
        searchController.searchBar.text = searchText
        if  recognitionTask != nil{
            isRecording = false
            cancelRecording()
        }
        let sortDescriptors = [NSSortDescriptor(key: "lastupdateDate", ascending: false)]
        let predicate=NSPredicate(format: "istrnding == %d", false)
            persistentStorage.Shared.insertSearchQuery(searchQuery: searchBar.text!)
            if let searchText = searchBar.text, !searchText.isEmpty {
                let vc = StoryBoardHelper.controller(.category, type: productsVC.self)
                vc?.fetchType = 2
                vc?.searchQuery = searchText
                vc!.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc!, animated: false)
            }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
           if let searchText = searchBar.text, !searchText.isEmpty {
               searchFunction(with: searchText, searchBar)
           }
       }
}


//extension SearchViewControler :UISearchBarDelegate{
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//    let sortDescriptors = [NSSortDescriptor(key: "lastupdateDate", ascending: false)]
//    let predicate=NSPredicate(format: "istrnding == %d", false)
//        persistentStorage.Shared.insertSearchQuery(searchQuery: searchBar.text!)
//        
//        if let searchText = searchBar.text, !searchText.isEmpty {
//            let vc = StoryBoardHelper.controller(.category, type: productsVC.self)
//            vc?.fetchType = 2
//            vc?.searchQuery = searchText
//            vc!.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(vc!, animated: false)
//        }
//    }
//}

extension SearchViewControler :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: KSearchTableViewCell) as! SearchTableViewCell
            cell.fetchHisory()
            cell.delegate = self
            self.arrSearchHistory = cell.arrSearchHistory 
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            if let cell = tableView.dequeueReusableCell(withIdentifier: KSearchTableViewCell) as? SearchTableViewCell {
            
            }

        return 100 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KSearchHeaderView) as! SearchHeaderView
            header.lblHeader.text = "Previous searches"
            header.btnClaer.isHidden = false
            header.btnClaer.isEnabled = true
            header.delegate = self
            return header
    }
    
    func totalCellHeight(arr:[String]) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: KSearchTableViewCell) as? SearchTableViewCell
        if arr.count <= 1 {
            return 25
        }
        var cellCount: String = ""
        for item in arr{
            cellCount.append(contentsOf: item)
        }
        var totalstring = (cellCount as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        var cellHeight: CGFloat = 25
        let viewWidth = cell!.collectionView.frame.size.width
        if totalstring.width > viewWidth/2
        {
            cellHeight += 25
            totalstring.width -= (viewWidth/2)
        }
        return cellHeight
    }

}

extension SearchViewControler:UpdateSearchHistory,SearchHisoryDelegate{
    func updateSearch() {
        tableView.reloadData()
    }
    
    func searchPrevious(search: String) {
        let vc = StoryBoardHelper.controller(.category, type: productsVC.self)
        vc?.fetchType = 2
        vc?.searchQuery = search
        navigationController?.pushViewController(vc!, animated: false)
    }
}
