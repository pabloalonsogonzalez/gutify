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
    
    @Environment(\.openURL) private var openURL
    
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
                                    Text("ProfileFollowers \(profile.followers)")
                                        .font(.caption)
                                }
                            }
                        }
                        Section() {
                            Label(profile.email, systemImage: "envelope.fill")
                            Label(profile.product.name, systemImage: "cloud.fill")
                        }
                        Section("AboutHeader") {
                            TappableCell(title: String(localized: "GoToSpotifyItem"),
                                         foregroundColor: Color("GreenColor"),
                                         systemImage: "cloud.fill") {
                                guard let spotifyUriUrl = URL(string: GutifyConstants.spotifyURI) else { return }
                                openURL(spotifyUriUrl) {
                                    if !$0, let spotifyWebURL = URL(string: GutifyConstants.spotifyURL) {
                                        openURL(spotifyWebURL)
                                    }
                                }
                            }
                        }
                        Section("AboutMeHeader") {
                            TappableCell(title: String(localized: "AuthorNameItem"),
                                         foregroundColor: Color("GreenColor"),
                                         systemImage: "person.crop.circle.fill") {
                                guard let linkedinUrl = URL(string: GutifyConstants.linkedinUrl) else { return }
                                openURL(linkedinUrl)
                            }
                        }
                        Section() {
                            TappableCell(title: String(localized: "LogoutItem"),
                                         systemImage: "person.slash.fill") {
                                output.alertMessage = AlertMessage(title: "ProfileLogoutConfirmationDialogTitle",
                                                                   message: String(localized: "ProfileLogoutConfirmationDialogMessage"),
                                                                   actionText: "AlertMessageOkButton",
                                                                   action: {
                                    logoutTrigger.send()
                                }, secondActionText: "AlertMessageCancelButton")
                            }
                                         .listItemTint(.red)
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

struct TappableCell: View {
    var title: String
    var foregroundColor: Color?
    var systemImage: String
    var tapGesture: () -> ()
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .if(foregroundColor != nil, transform: {
                    $0.foregroundStyle(foregroundColor ?? .black)
                })
            Spacer()
        }
        // make whole item tappable
        .contentShape(Rectangle())
        .onTapGesture(perform: tapGesture)
    }
}

#Preview {
    DefaultProfileAssembler.resolve()
}
