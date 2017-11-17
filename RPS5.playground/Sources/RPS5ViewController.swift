import UIKit

//Files in Sources are in a separate module from the PlayGround page. So they must be public
/**
 View controller to run an RPS game in a playground.
 Adjust the containerWidth and everything else should try to work.
 */
public class RPS5ViewController: UIViewController {
    // OK to shift this value. But min of 400. probably.
    private let containerWidth = 400.0
    private lazy var containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: containerWidth, height: 3.0/2.0 * containerWidth))
    private lazy var buttonsLayoutRadius: CGFloat = (containerView.frame.width / 2.85)
    
    private lazy var numberOfOptions = Choice.count
    private let buttonDiameter: CGFloat = 70
    
    private let gameFieldView = UIView()
    private let circleView = ShapeView()
    
    private let labelsView = UIView()
    private let playersChoiceLabel = UILabel()
    private let computersChoiceLabel = UILabel()
    private let resultLabel = UILabel()
    
    private enum Choice: Int {
        case rock = 0, spock, paper, lizard, scissors
        
        // update this if you add more choices
        static var count: Int { return Choice.scissors.rawValue + 1 }
    }
    
    override public func loadView() {
        super.loadView()
        
        self.view = containerView
        
        
        // MARK: Setup the containers
        
        gameFieldView.backgroundColor = .darkGray
        containerView.addSubview(gameFieldView)
        gameFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameFieldView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 2/3),
            gameFieldView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            gameFieldView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gameFieldView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
        
        let circleRadius = buttonsLayoutRadius + buttonDiameter / 2
        circleView.shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: -circleRadius, y: -circleRadius, width: 2*circleRadius, height: 2*circleRadius)).cgPath
        circleView.shapeLayer.fillColor = UIColor.black.cgColor
        gameFieldView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerXAnchor.constraint(equalTo: gameFieldView.centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: gameFieldView.centerYAnchor).isActive = true
        
        containerView.addSubview(labelsView)
        labelsView.backgroundColor = .white
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            labelsView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3),
            labelsView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            labelsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        
        
        // MARK: Set up the buttons
        
        makeButton(for: .rock)
        makeButton(for: .spock)
        makeButton(for: .paper)
        makeButton(for: .lizard)
        makeButton(for: .scissors)
        
        
        // MARK: Set up the labels
        
        let playersLabel = UILabel()
        playersLabel.text = "Player Choice: "
        labelsView.addSubview(playersLabel)
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playersLabel.topAnchor.constraint(equalTo: labelsView.topAnchor, constant: 8),
            playersLabel.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor, constant: 8)])
        
        playersChoiceLabel.text = "<click a button>"
        labelsView.addSubview(playersChoiceLabel)
        playersChoiceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playersChoiceLabel.topAnchor.constraint(equalTo: labelsView.topAnchor, constant: 8),
            playersChoiceLabel.leadingAnchor.constraint(equalTo: playersLabel.trailingAnchor, constant: 8)])
        
        let computerLabel = UILabel()
        computerLabel.text = "Computers Choice: "
        labelsView.addSubview(computerLabel)
        computerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            computerLabel.topAnchor.constraint(equalTo: playersLabel.bottomAnchor, constant: 8),
            computerLabel.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor, constant: 8)])
        
        computersChoiceLabel.text = "<it's waiting for you!>"
        labelsView.addSubview(computersChoiceLabel)
        computersChoiceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            computersChoiceLabel.topAnchor.constraint(equalTo: computerLabel.topAnchor),
            computersChoiceLabel.leadingAnchor.constraint(equalTo: computerLabel.trailingAnchor, constant: 8)])
        
        let winnersLabel = UILabel()
        winnersLabel.text = "Winner: "
        labelsView.addSubview(winnersLabel)
        winnersLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            winnersLabel.topAnchor.constraint(equalTo: computerLabel.bottomAnchor, constant: 8),
            winnersLabel.leadingAnchor.constraint(equalTo: labelsView.leadingAnchor, constant: 8)])
        
        resultLabel.text = "<Do you have the skill required to push a button?!>"
        resultLabel.numberOfLines = 2
        resultLabel.lineBreakMode = .byWordWrapping
        labelsView.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: winnersLabel.topAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: winnersLabel.trailingAnchor, constant: 8),
            resultLabel.trailingAnchor.constraint(equalTo: labelsView.trailingAnchor, constant: 8)])
    }
    
    private func makeButton(for choice: Choice) {
        let buttonLabel = "\(choice)"
        let index = choice.rawValue
        
        let button = UIButton(type: .roundedRect)
        button.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        button.layer.cornerRadius = buttonDiameter / 2
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle(buttonLabel, for: .normal)
        button.tag = index
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        gameFieldView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let radians = 2 * CGFloat.pi * CGFloat(index) / CGFloat(numberOfOptions) - CGFloat.pi / 2
        let xOffset = buttonsLayoutRadius * cos(radians)
        let yOffset = buttonsLayoutRadius * sin(radians)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: gameFieldView.centerXAnchor, constant: xOffset),
            button.centerYAnchor.constraint(equalTo: gameFieldView.centerYAnchor, constant: yOffset),
            button.widthAnchor.constraint(equalToConstant: buttonDiameter),
            button.heightAnchor.constraint(equalToConstant: buttonDiameter)])
    }
    
    
    // MARK: Handle button clicks
    
    // TODO: Break this up into testable parts
    @objc func action(sender: UIButton!) {
        guard let playersChoice = Choice(rawValue: sender.tag),
              let computersChoice = Choice(rawValue: Int(arc4random_uniform(5)) + 1)
            else { return }
        
        playersChoiceLabel.text = "\(playersChoice)".capitalized
        computersChoiceLabel.text = "\(computersChoice)".capitalized
        
        guard playersChoice != computersChoice else {
            resultLabel.text = "You Tied!\nDare to try again?"
            return
        }
        
        let remainder = (computersChoice.rawValue - playersChoice.rawValue) % numberOfOptions
        // Swift does a remainder function, not a true modulo.
        let fixedRemainder = remainder >= 0 ? remainder : remainder + numberOfOptions
        
        let mean = Int(ceil(Double(numberOfOptions) / 2))
        let playerDidWin = fixedRemainder >= mean
        
        let winnerAndLoser = playerDidWin ? (winner: playersChoice, loser: computersChoice) : (winner: computersChoice, loser: playersChoice)
        let verb = fetchVerb(for: winnerAndLoser)
        
        resultLabel.text = "You \(playerDidWin ? "Win" : "Lose")!\n\(String(describing: winnerAndLoser.winner).capitalized) \(verb) \(String(describing: winnerAndLoser.loser).capitalized)"
    }
    
    // TODO: Write tests
    private func fetchVerb(for winnerAndLoser: (winner: Choice, loser: Choice)) -> String {
        switch winnerAndLoser {
        case (.rock, .scissors), (.rock, .lizard): return "Crushes"
        case (.spock, .scissors): return "Smashes"
        case (.spock, .rock): return "Vaporizes"
        case (.paper, .rock): return "Covers"
        case (.paper, .spock): return "Disproves"
        case (.lizard, .spock): return "Poisons"
        case (.lizard, .paper): return "Eats"
        case (.scissors, .paper): return "Cuts"
        case (.scissors, .lizard): return "Decapitates"
        default: return "Beats" } // it shouldn't get here unless you add more options 
    }
    
    
    // MARK: Get the path to draw the circle
    
    private func createBezierPath() -> UIBezierPath {
        let path  = UIBezierPath(arcCenter: CGPoint(x: containerView.frame.width / 2, y: containerView.frame.height / 2),
                                 radius: buttonsLayoutRadius * 2,
                                 startAngle: CGFloat(.pi * -0.5),
                                 endAngle: CGFloat(.pi * 1.5),
                                 clockwise: true)
        return path
    }
}

