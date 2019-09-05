//
//  CustomAnnotationView.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 04/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import MapKit

/**
 Creates a custom class for MKAnnotaionView
 
 After initialization, it utilizes the RequestHelper function to download the image from the web which will be later used as its image.
 */
class CustomAnnotationView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let customAnnotation = self.annotation as? CustomAnnotation else { return }
        
        let requestHelper = RequestHelper()
        requestHelper.downloadAnnotationImage(fromURL: customAnnotation.imageUrl) { (data) in
            DispatchQueue.main.async {
                guard let data = data, let image = UIImage(data: data) else { return }
                self.image = image
            }
        }
    }
}
