//
//  ViewController.swift
//  ios game
//
//  Created by Gering Dong on 1/25/19.
//  Copyright © 2019 Gering Dong. All rights reserved.
//

import UIKit

let BRICKS_HEIGHT = 5
let BRICKS_WIDTH = 6

class ViewController: UIViewController {
    
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var lblLives: UILabel!
    @IBOutlet weak var lblLive_counter: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblScore_counter: UILabel!
    
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var imgpaddle: UIImageView!
    
    @IBOutlet weak var savebtn: UIButton!
    @IBAction func Start(_ sender: Any) {
        startGame()
        savebtn.alpha = 0
        
    }
    
    var ballPos = CGPoint.zero
    var score: Int = 0
    var lives:Int = 3
    var ballMovement = CGPoint.zero
    var touchOffset: Float = 0.0
    var theTimer: Timer?
    var bricks = [[UIImageView]]()
    var brickTypes = [String](repeating: "", count: 4)
    
    func initializeTimer(){
        let interval: Float = 1.0 / 110.0
        
        theTimer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(gameLogic), userInfo: nil, repeats: true)
       // ballMovement = CGPoint(x: CGFloat(30+30), y: CGFloat( 40*40))
    }
    
    
    func initializeBricks(){
        // creates all bricks and places them at the appropriate location on the screen
        brickTypes[0] = "bricktype1"
        brickTypes[1] = "bricktype2"
        brickTypes[2] = "bricktype3"
        brickTypes[3] = "bricktype4"
        
        let screenOffset: Int = (Int(view.bounds.width) - 64 * BRICKS_WIDTH) / 2
        for x in 0..<BRICKS_WIDTH{
            var row = [UIImageView]()
            for y in 0..<BRICKS_HEIGHT{
                let image = UIImageView(image: UIImage(named: brickTypes[(x+y) % 4]))
                var newFrame: CGRect = image.frame
                print(image.frame.origin.x, " , ", image.frame.origin.y)
                newFrame.origin = CGPoint(x: CGFloat(x * 64 + screenOffset), y: CGFloat( y * 40 + 100))
                image.frame = newFrame
                row.append(image)
                view.addSubview(image)
            }
            bricks.append(row)
        }
    }
    
    
    func startGame(){
        // resets all settings, reloads bricks, starts the timer , IBAction
        //ball.center = CGPoint(x:150.0, y:300.0)
        ballMovement = CGPoint(x:2, y:2)
        initializeTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // tracks finger movement
        let touch = event!.allTouches?.first
        touchOffset = Float ((touch?.location(in: touch?.view).x)!)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // tracks finger movement
        
        let touch = event?.allTouches?.first
        let distanceMoved = Float(touch?.location(in: touch?.view).x ?? 0.0) - touchOffset
        var newX: Float = Float(imgpaddle.center.x) + distanceMoved
        if newX < 30{
            newX = 30
        }
        if newX > Float(view.bounds.width) - 30.0{
            newX = Float (view.bounds.width) - 30.0
        }
        imgpaddle.center = CGPoint(x:CGFloat(newX), y: imgpaddle.center.y)
        touchOffset += distanceMoved
        
    }
    
    
    @objc func gameLogic(){
        
        lblLive_counter.text = String(lives)
        lblScore_counter.text = String(score)
        self.ball.center.x = self.ball.center.x + ballMovement.x
        self.ball.center.y = self.ball.center.y + ballMovement.y
        
        // when the ball hits the x axis of the screen
        
        if self.ball.center.x >= self.view.frame.maxX{
            ballMovement.x = ballMovement.x * -1
        }
        
        if self.ball.center.x <= self.view.frame.minX{
            ballMovement.x = ballMovement.x * -1
        }
        
        if self.ball.center.y >= self.view.frame.minY{
            ballMovement.y = ballMovement.y * -1
        }
        
        if self.ball.center.y <= self.view.frame.maxY{
            ballMovement.y = ballMovement.y * -1
        }
        
        
        
        if self.ball.center.y >= self.imgpaddle.frame.minY && self.imgpaddle.frame.minX <= self.ball.frame.maxX && self.imgpaddle.frame.maxX >= self.ball.frame.minX{
            
            ballMovement.y = ballMovement.y * -1
            
        }
        
        for x in 0..<BRICKS_WIDTH{
            for y in 0..<BRICKS_HEIGHT{
                if bricks[x][y].alpha == 1{
                    if (bricks[x][y].frame.intersects(ball.frame)){
                        bricks[x][y].alpha = 0
                        if abs(bricks[x][y].frame.maxY - ball.frame.minY) < 3 {
                            ballMovement.y = ballMovement.y * -1
                        }
                        
                        if abs(bricks[x][y].frame.minY - ball.frame.maxY) < 3 {
                            ballMovement.y = ballMovement.y * -1
                            
                        }
                        
                        if abs(bricks[x][y].frame.maxX - ball.frame.minX) < 3{
                            ballMovement.x = ballMovement.x * -1
                        }
                        if abs(bricks[x][y].frame.minX - ball.frame.maxX) < 3 {
                            ballMovement.x = ballMovement.x * -1
                        }
                        score+=1
                    }
                }
            }
        }
        
//        if self.ball.center.y > self.imgpaddle.frame.maxY {
//            theTimer?.invalidate()
//            ballMovement = CGPoint(x:2, y:2)
//
//        }
        
        if (score == 30) {
            score = 30
            theTimer?.invalidate()
            gameStatus.text = "You won!"
            
        }
        
        if self.ball.center.y > self.imgpaddle.frame.maxY{
            theTimer?.invalidate()
            lives -= 1
            ball.center = self.ballPos
            savebtn.alpha = 1
            if (lives == 0){
                lives = 0
                gameStatus.text = " You're a Loser!"
                theTimer?.invalidate()
                savebtn.alpha = 0
            }
        }
    }
    
    

    override func viewDidLoad() {
        self.ballPos = self.ball.center
        initializeBricks()
        
        
    }

}
