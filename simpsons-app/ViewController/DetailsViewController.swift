//
//  DetailsViewController.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

class DetailsViewController: UIViewController {
   
    var character: RelatedTopic? {
        didSet {
          configureView()
        }
      }
    
    @IBOutlet weak var cheracterDetail: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func configureView() {
      loadViewIfNeeded()
        let titlenDescription = character?.text?.split(separator: "-")
        
        if let parts = titlenDescription {
            if parts.count > 0 {
                let title = parts[0]
                self.characterName.text = String(title)
            }
            
            if parts.count > 1 {
                let description = parts[1]
                self.cheracterDetail.text = String(description)
            }
        }

        if let posterPath = character?.icon?.url, !posterPath.isEmpty {
            movieImage.downloaded(from: posterPath)
        } else {
            self.movieImage.image = #imageLiteral(resourceName: "placeholder")
        }
    }
}

extension DetailsViewController: ListViewControllerDelegate {
  func characterSelected(_ selectedCharacter: RelatedTopic) {
    character = selectedCharacter
  }
}

