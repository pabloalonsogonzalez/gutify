//
//  ProfileView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct ProfileView: View {
    
    @ObservedObject var input: ProfileViewModel.Input
    @ObservedObject var output: ProfileViewModel.Output
    
    private let cancelBag = CancelBag()
    
    private let initTrigger = PassthroughSubject<Void, Never>()
    private let logoutTrigger = PassthroughSubject<Void, Never>()
    
    enum ViewState {
        case loading
        case loaded(profile: Profile)
    }
    
    var body: some View {
        BaseView(output: output) {
            switch output.viewState {
            case .loading:
                LoaderView()
            case .loaded(let profile):
                VStack {
                    List {
                        Section {
                            HStack {
                                CustomAsyncImage(url: profile.imageUrl, size: 64)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(profile.name)
                                        .font(.headline)
                                    Text("Followers \(profile.followers)")
                                        .font(.caption)
                                }
                            }
                        }
                        Section() {
                            Label(profile.email, systemImage: "envelope.fill")
                            Label(profile.product.rawValue, systemImage: "cloud.fill")
                        }
                        Section("About") {
                            Label("Go to Spotify", systemImage: "cloud.fill")
                                .foregroundStyle(Color("GreenColor"))
                        }
                        Section("About me") {
                            Label("Pablo Alonso González", systemImage: "person.crop.circle.fill")
                        }
                        Section() {
                            Label("Logout", systemImage: "person.slash.fill")
                                .listItemTint(.red)
                                .onTapGesture {
                                    logoutTrigger.send()
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            output.addNavigations
        }
        .navigationTitle("ProfileTitle")
    }
    
    init(viewModel: ProfileViewModel) {
        let input = ProfileViewModel.Input(initTrigger: initTrigger.asDriver(),
                                           logoutTrigger: logoutTrigger.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
        initTrigger.send()
    }
}

#Preview {
    DefaultProfileAssembler.resolve()
}
