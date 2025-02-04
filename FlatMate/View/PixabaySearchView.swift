//
//  PixabaySearchView.swift
//  FlatMate
//
//  Created by Ivan on 2025-02-04.
//

import SwiftUI
import Combine

class PixabaySearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var images: [PixabayImage] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service = PixabayService()
    
    init() {
      
    }
    
    // Called when user presses “Search” or modifies `searchTerm`
    func search(_ term: String) {
        guard !term.isEmpty else {
            images = []
            return
        }
        isLoading = true
        
        service.fetchImages(query: term)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure(let error):
                    print("Error fetching Pixabay: \(error.localizedDescription)")
                    self.images = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] hits in
                self?.images = hits
            }
            .store(in: &cancellables)
    }
}

struct PixabaySearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = PixabaySearchViewModel()
    
    var onImageSelected: ((PixabayImage) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    TextField("Search images...", text: $vm.searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            vm.search(vm.searchTerm)
                        }
                    Button("Search") {
                        vm.search(vm.searchTerm)
                    }
                }
                .padding()
                
                // Loading indicator
                if vm.isLoading {
                    ProgressView("Loading...")
                }
                
                // Grid of images
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)]) {
                        ForEach(vm.images) { pixabayImage in
                            // A simple AsyncImage for the preview
                            if let previewURL = pixabayImage.previewURL,
                               let url = URL(string: previewURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFill()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipped()
                                .onTapGesture {
                                    onImageSelected?(pixabayImage)
                                    dismiss()
                                }
                            } else {
                                // If no previewURL, just a placeholder
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .onTapGesture {
                                        onImageSelected?(pixabayImage)
                                        dismiss()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Pixabay Images")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
