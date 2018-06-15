//
//  ViewController.swift
//  NewTTT
//
//  Created by Vemilab on 8/3/17.
//  Copyright © 2017 Vemilab. All rights reserved.


import UIKit
import UIKit.UIGestureRecognizerSubclass
import AVFoundation

//vars for partition
var bounds = UIScreen.main.bounds
var width = bounds.size.width
var height = bounds.size.height
var line1X = width/3
var line2X = line1X*2
var Line1Y = height/3
var Line2Y = Line1Y*2

//vars for touchTracking
var touchX :CGFloat = 0.0
var touchY : CGFloat = 0.0
var counter = 0
var timer = Timer()
var touchCounter = 1
var timeCounter = 1

//values for grids and speech
var emptyUtter = AVSpeechUtterance(string: "")
var gridUtter = AVSpeechUtterance(string: "")

//grid1
var g1x1 : CGFloat = 0.0
var g1x2 : CGFloat = line1X - 10
var g1y1 : CGFloat = 0.0
var g1y2 : CGFloat = Line1Y - 10
var g1Name = AVSpeechUtterance(string: "TopLeft")
//grid2
var g2x1 : CGFloat = line1X + 10
var g2x2 : CGFloat = line2X - 10
var g2y1 : CGFloat = 0.0
var g2y2 : CGFloat = Line1Y - 10
var g2Name = AVSpeechUtterance(string: "TopCenter")
//grid3
var g3x1 : CGFloat = line2X - 10
var g3x2 : CGFloat = width
var g3y1 : CGFloat = 0.0
var g3y2 : CGFloat = Line1Y - 10
var g3Name = AVSpeechUtterance(string: "TopRight")
//grid4
var g4x1 : CGFloat = 0.0
var g4x2 : CGFloat = line1X - 10
var g4y1 : CGFloat = Line1Y + 10
var g4y2 : CGFloat = 434.0
var g4Name = AVSpeechUtterance(string: "CenterLeft")
//grid5
var g5x1 : CGFloat = line1X + 10
var g5x2 : CGFloat = line2X - 10
var g5y1 : CGFloat = Line1Y + 10
var g5y2 : CGFloat = Line2Y - 10
var g5Name = AVSpeechUtterance(string: "Center")
//grid6
var g6x1 : CGFloat = line2X - 10
var g6x2 : CGFloat = width
var g6y1 : CGFloat = Line1Y + 10
var g6y2 : CGFloat = Line2Y - 10
var g6Name = AVSpeechUtterance(string: "CenterRight")
//grid7 test
var g7x1 : CGFloat = 0.0
var g7x2 : CGFloat = line1X - 10
var g7y1 : CGFloat = Line2Y + 10
var g7y2 : CGFloat = height
var g7Name = AVSpeechUtterance(string: "BottomLeft")
//grid8
var g8x1 : CGFloat = line1X + 10
var g8x2 : CGFloat = line2X - 10
var g8y1 : CGFloat = Line2Y + 10
var g8y2 : CGFloat = height
var g8Name = AVSpeechUtterance(string: "BottomCenter")
//grid9
var g9x1 : CGFloat = line2X - 10
var g9x2 : CGFloat = width
var g9y1 : CGFloat = Line2Y + 10
var g9y2 : CGFloat = height
var g9Name = AVSpeechUtterance(string: "BottomRight")

let speak = AVSpeechSynthesizer()

//speech control
var speakSituation = 0

//boolean for double tap and game
var winner : Character = " "
var doubleTap = false
var noughtsTurn = false
var playersTurn = "O"
var gridOwner = ""
var alreadyOccupied = ""
var countTurns = 0
var isGameOver = false
var board:[[Character]] = [["q","q","q"],["q","q","q"],["q","q","q"]]
var selectedGrid = ""
var grid1 = false, grid2 = false, grid3 = false, grid4 = false, grid5 = false, grid6 = false, grid7 = false, grid8 = false, grid9 = false
var player = ""
var speakPlayer = AVSpeechUtterance(string: "")


class ViewController: UIViewController {

    @IBOutlet weak var Bg: UIImageView!
    
    //the image of the X or O
    var xImg : UIImage = UIImage(named:"X")!
    var oImg : UIImage = UIImage(named: "O")!
    
    //these are the UIImageViews that will hold the X or O
    //the 'G' stands for grids
    
        @IBOutlet weak var G1: UIImageView!
        @IBOutlet weak var G2: UIImageView!
        @IBOutlet weak var G3: UIImageView!
        @IBOutlet weak var G4: UIImageView!
        @IBOutlet weak var G5: UIImageView!
        @IBOutlet weak var G6: UIImageView!
        @IBOutlet weak var G7: UIImageView!
        @IBOutlet weak var G8: UIImageView!
        @IBOutlet weak var G9: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //setup doubleTap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userSwiped))
        swipeRecognizer.numberOfTouchesRequired = 2
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)

        let swipeThreeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userThreeSwiped))
        swipeThreeRecognizer.numberOfTouchesRequired = 3
        swipeThreeRecognizer.direction = .up
        view.addGestureRecognizer(swipeThreeRecognizer)

        //try audio or start audio session
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            do{
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
            }
        }catch{
        }
        
        print (playersTurn)
        playersTurn = noughtsTurn ? "O" : "X"
        let player = "\(playersTurn)'s Turn"
        let speakPlayer = AVSpeechUtterance(string: player)
        speak.speak(speakPlayer)
        print (playersTurn)
        print (board)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func for vibration
    func vibratePhone() {
        if(counter>0){
            AudioServicesPlaySystemSound(1521) //taptic engine repeat
            counter = 0
            if(speak.isSpeaking){
                speak.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
        }
        
    }
    
    //Check if tpuch is on Line
    func checkIfOnLine(_ position:CGPoint) -> Bool{
        touchX = position.x
        touchY = position.y
        var test = false
        if(touchX>(line1X-10) && touchX<(line1X + 10)){
            test = true
        } else if (touchX>(line2X - 10) && touchX<(line2X + 10)){
            test = true
            doubleTap = false
        } else if (touchY>(Line1Y - 10) && touchY<(Line1Y + 10)){
            test = true
            doubleTap = false
        }else if (touchY>(Line2Y - 10) && touchY<(Line2Y + 10)){
            test = true
            doubleTap = false
        }
        
        return test
    }
    
    
    //timer func for triggering touch and vibration
    func timerAction() {
        timeCounter += 1
        //print ("timerInterval \(timeCounter)")
    }
    
    //Touch Events
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            let touchCount = touches.count
            for _ in touches{
                if (position.x != g1x1 && position.y != g1y1){
                   // touchCounter += 1
                   // print("Touch Count \(touchCounter) \(position)" )
                    //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                    //print("Timer Count \(timer) )" )
                }
                if (checkIfOnLine(position)){
                    counter = 1
                    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.vibratePhone), userInfo: nil, repeats: true)
                }
                
                if(isGameOver || countTurns > 7){
                    let gameOver = AVSpeechUtterance(string: "GameOver")
                    gameOver.rate = 0.6
                    speak.speak(gameOver)
                }
                else{
                    speakSituation = 1
                    if ((position.x>g1x1 && position.x<g1x2)&&(position.y > g1y1 && position.y < g1y2) && (touchCount==1)){
                        if(grid1){
                            selectedGrid = "TopLeft"
                            alreadyOccupied =  "\(board [0][0])  TopLeft"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "TopLeft"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g2x1 && position.x<g2x2)&&(position.y > g2y1 && position.y < g2y2) && (touchCount==1)){
                        
                        if(grid2){
                            selectedGrid = "TopCenter"
                            alreadyOccupied =  "\(board [0][1]) TopCenter"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "TopCenter"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g3x1 && position.x<g3x2)&&(position.y > g3y1 && position.y < g3y2) && (touchCount==1)){
                        if(grid3){
                            selectedGrid = "TopRight"
                            alreadyOccupied =  "\(board [0][2]) TopRight"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }                            }
                        else {
                            selectedGrid = "TopRight"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g4x1 && position.x<g4x2)&&(position.y > g4y1 && position.y < g4y2) && (touchCount==1)){
                        if(grid4){
                            selectedGrid = "CenterLeft"
                            alreadyOccupied =  "\(board [1][0]) CenterLeft"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "CenterLeft"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g5x1 && position.x<g5x2)&&(position.y > g5y1 && position.y < g5y2) && (touchCount==1)){
                        if(grid5){
                            selectedGrid = "Center"
                            alreadyOccupied =  "\(board [1][1]) Center"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "Center"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g6x1 && position.x<g6x2)&&(position.y > g6y1 && position.y < g6y2) && (touchCount==1)){
                        if(grid6){
                            selectedGrid = "CenterRight"
                            alreadyOccupied =  "\(board [1][2]) CenterRight"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "CenterRight"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g7x1 && position.x<g7x2)&&(position.y > g7y1 && position.y < g7y2) && (touchCount==1)){
                        if(grid7){
                            selectedGrid = "BottomLeft"
                            alreadyOccupied =  "\(board [2][0]) BottomLeft"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "BottomLeft"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g8x1 && position.x<g8x2)&&(position.y > g8y1 && position.y < g8y2) && (touchCount==1)){
                        if(grid8){
                            selectedGrid = "BottomCenter"
                            alreadyOccupied =  "\(board [2][1]) Bottom Center"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "BottomCenter"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    } else if ((position.x>g9x1 && position.x<g9x2)&&(position.y > g9y1 && position.y < g9y2) && (touchCount==1)){
                        if(grid9){
                            selectedGrid = "BottomRight"
                            alreadyOccupied =  "\(board [2][2]) BottomRight"
                            let occupant = alreadyOccupied.lowercased()
                            let speakOccupant = AVSpeechUtterance(string: occupant)
                            speakOccupant.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(speakOccupant)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        else {
                            selectedGrid = "BottomRight"
                            gridUtter = AVSpeechUtterance(string: selectedGrid)
                            gridUtter.rate = 0.6
                            if (!speak.isSpeaking){
                                speak.speak(gridUtter)
                            } else {
                                speak.continueSpeaking()
                            }
                        }
                        
                    }
                    
                    else {
                        if speak.isSpeaking{
                            speak.stopSpeaking(at: AVSpeechBoundary.immediate)
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>?, with event: UIEvent?) {
        timer.invalidate()
        touchCounter = 0
        if(speak.isPaused){
            speak.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        timer.invalidate()
        touchCounter = 0
        if (speakSituation < 2){
           //speak.stopSpeaking(at: AVSpeechBoundary.word)
        }
    }
    
    //Checkwin func
    func checkWin() -> Bool{
        print ("comes in CheckWin , winner = \(winner)")
        print (board)
        print (countTurns)
        if (checkWinner(board, size: 3, player: "X")) {
            winner = "X"
            isGameOver = true
            print(isGameOver)
        } else if (checkWinner(board, size: 3, player: "O")) {
            winner = "O"
            isGameOver = true
            print(isGameOver)
        }
        if( winner == " " ) {
                if(countTurns>8){
                    let tie = AVSpeechUtterance(string: "its a tie")
                    tie.rate = 0.6
                    speak.speak(tie)
                }
            return false // nobody won
        }
        else {
            return true;
        }
    }
    
    //Check winner
    func checkWinner(_ board: [[Character]] , size: Int, player: Character) -> Bool{
        // check each row
        
        // print ("comes in Check winner, and player is \(player)")
        //print ("board in Check winner \(board)")
        for x in 0 ..< size {
            var total = 0
            for y in 0 ..< size {
                if (board[x][y] == player) {
                    total+=1
                }
            }
            //print ("total for Col \(total)")
            if (total >= size) {
                return true // they win
            }
        }
        
        // check each Column
        for y in 0 ..< size {
            var total = 0
            for x in 0 ..< size {
                if (board[x][y] == player) {
                    total+=1
                }
            }
            //print ("total for row \(total)")
            if (total >= size) {
                return true // they win
            }
        }
        
        // forward diag
        var total = 0
        for x in 0 ..< size {
            for y in 0 ..< size  {
                if (x == y && board[x][y] == player) {
                    total+=1
                }
            }
        }
        print ("total for ForDiag \(total), and tapCount \(countTurns)")
        if (total >= size) {
            return true // they win
        }
        
        // backward diag
        total = 0
        for x in 0 ..< size  {
            for y in 0 ..< size {
                if (x + y == size - 1 && board[x][y] == player) {
                    total+=1
                }
            }
        }
        //print ("total for backDiag \(total)")
        if (total >= size) {
            return true // they win
        }
        
        return false // nobody won
    }
    
    //twofinger swipe - speak player's turn
    func userSwiped(recognizer: UISwipeGestureRecognizer){
        player = "\(playersTurn)'s Turn"
        speakPlayer = AVSpeechUtterance(string: player)
        if (speak.isSpeaking){
            speak.stopSpeaking(at: AVSpeechBoundary.immediate)
            speak.speak(speakPlayer)
        }
        else{
        speak.speak(speakPlayer)
        }

    }
    
    //three finger swipe - reset game
    func userThreeSwiped(recognizer: UISwipeGestureRecognizer){
        let speakReset = AVSpeechUtterance(string: "Game Resetted - New Game")
        if (speak.isSpeaking){
            speak.stopSpeaking(at: AVSpeechBoundary.immediate)
            speak.speak(speakReset)
        }
        else{
            speak.speak(speakReset)
        }
        timer.invalidate()
        countTurns = 0
        isGameOver = false
        board = [["q","q","q"],["q","q","q"],["q","q","q"]]
        selectedGrid = ""
        grid1 = false
        grid2 = false
        grid3 = false
        grid4 = false
        grid5 = false
        grid6 = false
        grid7 = false
        grid8 = false
        grid9 = false
        G1.image = nil
        G2.image = nil
        G3.image = nil
        G4.image = nil
        G5.image = nil
        G6.image = nil
        G7.image = nil
        G8.image = nil
        G9.image = nil
        playersTurn = noughtsTurn ? "O" : "X"
        player = "\(playersTurn)'s Turn"
        speakPlayer = AVSpeechUtterance(string: player)
        speak.speak(speakPlayer)
        
    }
    
    
// Double tap for Selection
    
    func doubleTapped(){
        speakSituation = 3
        if(isGameOver || countTurns > 7){
            let gameOver = AVSpeechUtterance(string: "GameOver")
            speak.speak(gameOver)
        } else{
            //Grid1
            if(selectedGrid == "TopLeft"){
                if(grid1){
                    gridOwner = "\(board[0][0])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                    
                } else {
                    grid1 = true
                    board [0][0] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G1.image = #imageLiteral(resourceName: "X")
                    } else{
                        G1.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                    
                }
            }
            //Grid2
            if(selectedGrid == "TopCenter"){
                if(grid2){
                    gridOwner = "\(board[0][1])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid2 = true
                    board [0][1] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G2.image = #imageLiteral(resourceName: "X")
                    } else{
                        G2.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            //Grid3
            if(selectedGrid == "TopRight"){
                if(grid3){
                    gridOwner = "\(board[0][2])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid3 = true
                    board [0][2] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G3.image = #imageLiteral(resourceName: "X")
                    } else{
                        G3.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid4
            if(selectedGrid == "CenterLeft"){
                if(grid4){
                    gridOwner = "\(board[1][0])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid4 = true
                    board [1][0] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G4.image = #imageLiteral(resourceName: "X")
                    } else{
                        G4.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid5
            if(selectedGrid == "Center"){
                if(grid5){
                    gridOwner = "\(board[1][1])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid5 = true
                    board [1][1] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G5.image = #imageLiteral(resourceName: "X")
                    } else{
                        G5.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid6
            if(selectedGrid == "CenterRight"){
                if(grid6){
                    gridOwner = "\(board[1][2])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid6 = true
                    board [1][2] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G6.image = #imageLiteral(resourceName: "X")
                    } else{
                        G6.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid7
            if(selectedGrid == "BottomLeft"){
                if(grid7){
                    gridOwner = "\(board[2][0])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid7 = true
                    board [2][0] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G7.image = #imageLiteral(resourceName: "X")
                    } else{
                        G7.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid8
            if(selectedGrid == "BottomCenter"){
                if(grid8){
                    gridOwner = "\(board[2][1])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid8 = true
                    board [2][1] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G8.image = #imageLiteral(resourceName: "X")
                    } else{
                        G8.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        speak.speak(speakPlayer)
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
            
            //Grid9
            if(selectedGrid == "BottomRight"){
                if(grid9){
                    gridOwner = "\(board[2][2])"
                    alreadyOccupied = "\(gridOwner) already selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: alreadyOccupied)
                    speak.speak(speakPlayer)
                } else {
                    grid9 = true
                    board [2][2] = noughtsTurn ? "O" : "X"
                    player = "\(playersTurn) selected \(selectedGrid)"
                    speakPlayer = AVSpeechUtterance(string: player)
                    speak.speak(speakPlayer)
                    
                    if(playersTurn == "X"){
                        G9.image = #imageLiteral(resourceName: "X")
                    } else{
                        G9.image = #imageLiteral(resourceName: "O")
                    }
                    
                    if(checkWin()){
                        let win = AVSpeechUtterance(string: "\(winner) is the Winner")
                        speak.speak(win)
                    } else if (countTurns<=7){
                        //Change Player
                        noughtsTurn = !noughtsTurn
                        playersTurn = noughtsTurn ? "O" : "X"
                        player = "\(playersTurn)'s Turn"
                        speakPlayer = AVSpeechUtterance(string: player)
                        if !speak.isSpeaking{
                            speak.speak(speakPlayer)
                        }
                        countTurns += 1
                    } else{
                        let tie = AVSpeechUtterance(string: "its a tie")
                        speak.speak(tie)
                    }
                }
            }
        }
    }

    
    


}

