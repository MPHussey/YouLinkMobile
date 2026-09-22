//
//  CenterMenuViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-12.
//\

import Foundation
import SwiftUI

class CenterMenuViewModel:ObservableObject{
    @Published var menuData: MenuData = [:]
    
    @Published var expandedSections: Set<String> = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let homeService = HomeService.shared
    
    //get the menu links from the backend, no local fallback
    func getApplicationMenu(){
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        //this endpoint is a GET, so no body is sent
        homeService.getApplicationMenu{[weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result{
                case .success(let menu):
                    self?.menuData = menu
                case .failure(let error):
                    self?.menuData = [:]
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    // Toggle section
    func toggle(sectionKey: String) {
        if expandedSections.contains(sectionKey) {
            expandedSections.remove(sectionKey)
        } else {
            expandedSections.insert(sectionKey)
        }
    }
    
    func isExpanded(sectionKey: String) -> Bool {
        expandedSections.contains(sectionKey)
    }
}
