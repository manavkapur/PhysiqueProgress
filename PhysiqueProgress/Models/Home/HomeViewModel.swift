//
//  HomeViewModel.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 03/01/26.
//

final class HomeViewModel {
    
    enum Destination {
        case camera
        case history
        case subscription
        case logout
        
    }
    
    var onNavigate: ((Destination) -> Void)?
    
    func didSelectCamera() {
        onNavigate?(.camera)
    }
    
    func didSelectHistory() {
        onNavigate?(.history)
    }
    
    func didSelectSubscription() {
        onNavigate?(.subscription)
    }
    
    func didSelectLogout() {
        onNavigate?(.logout)
    }
}
