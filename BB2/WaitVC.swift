import UIKit

class WaitLevelVC: UIViewController {
    
    var secondsPassed:Int = 0
    var waitLevelVM:WaitVM = WaitVM()
    var timerView:UIView = UIView()
    var timer:Timer = Timer()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var numLights:Int {
        return waitLevelVM.puzzles.count
    }
    var buttonSepDis:CGFloat {
        return view.frame.height/CGFloat(numLights + 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.Menu.bg
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        layoutLights()
        setupTimerView()
        disableScreenSleep()
    }

    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        stopTimer()
        allowScreenSleep()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("Fired")
        print(UIDevice.current.orientation)
    }
    
    func deviceOrientationDidChange() {
        if UIDevice.current.orientation == .faceDown {
            startTimer()
        } else {
            stopTimer()
            zeroTimerFrame()
        }
    }
    
    func layoutLights() {
        for (index,lightVM) in waitLevelVM.lightData.enumerated() {
            let light = LightButton(lightVM: lightVM)
            let buttonHeight = buttonSepDis * CGFloat(index + 1)
            light.center = CGPoint(
                x: view.frame.width/2,
                y: buttonHeight
            )
            view.addSubview(light)
        }
    }
}

//MARK: - Timer
extension WaitLevelVC {
    
    func setupTimerView() {
        timerView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 0)
        timerView.backgroundColor = Colors.Wait.bg
        timerView.layer.zPosition = -1
        view.addSubview(timerView)
    }
    
    func zeroTimerFrame() {
        let timerFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 0)
        UIView.animate(withDuration: 1) {
            self.timerView.frame = timerFrame
        }
    }
    
    func startTimer() {
        if timer.isValid {
            stopTimer()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stopTimer() {
        timer.invalidate()
        secondsPassed = 0
    }
    
    func timerFired() {
        //update seconds and check for success
        secondsPassed += 1
        
        for puzzle in waitLevelVM.puzzles {
            puzzle.checkForSuccess(value: secondsPassed)
        }
        
        //update increment size shown after each timer firing
        var increment:CGFloat = 0

        switch timerView.frame.height {
        case 0..<buttonSepDis*2:
            increment = buttonSepDis*2/60
        case buttonSepDis*2..<buttonSepDis*3:
            increment = buttonSepDis/(60*60)
        case buttonSepDis*3..<buttonSepDis*4:
            increment = buttonSepDis/(60*60*24)
        case buttonSepDis*4...buttonSepDis*5:
            increment = buttonSepDis/60
        default:
            increment = 0
            stopTimer()
        }
        
        //update the timer view with the new increment size
        self.timerView.frame = CGRect(
            x: 0,
            y: self.timerView.frame.origin.y - increment,
            width: self.timerView.frame.width,
            height: self.timerView.frame.height + increment
        )
    }
}

//MARK: Screen Idle
extension WaitLevelVC {
    fileprivate func allowScreenSleep() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    fileprivate func disableScreenSleep() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
