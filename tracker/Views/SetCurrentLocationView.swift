//
//  SetCurrentLocationView.swift
//  tracker
//
//  Created by TechLead on 11/22/19.
//  Copyright © 2019 TechLead. All rights reserved.
//

import MapKit
import SwiftUI

class UserViewConfig: ObservableObject {
    @Published var showRecommendPlaces = true
    @Published var inSearchView = false
}

struct SetCurrentLocationView: View {
    @Binding var newLocation: String

    @State var manager = CLLocationManager()
    @State var alert = false
    @State var nearByPlaces: [MKMapItem] = []

    @EnvironmentObject var userViewConfig: UserViewConfig

    var body: some View {
        ZStack(alignment: Alignment.top) {
            MapView(manager: $manager, alert: $alert, nearByPlaces: $nearByPlaces)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel !!!"))
                }.edgesIgnoringSafeArea(.vertical)

            SlideOverCard {
                VStack {
                    SearchBarView().environmentObject(PlaceFinder())

                    if !self.userViewConfig.inSearchView {
                        List(self.nearByPlaces, id: \.self) { result in
                            Text(result.name!)
                        }
                        .resignKeyboardOnDragGesture()
                    }
                    Spacer()
                }
            }.environmentObject(userViewConfig)
        }.edgesIgnoringSafeArea(.vertical)

//    //            RecordsListView(newLocation: self.$newLocation)
//    //                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//            }
    }
}

struct SetCurrentLocationView_Previews: PreviewProvider {
    @State static var newLocation = "Aruba"
    static var userViewConfig = UserViewConfig()
    static var previews: some View {
        SetCurrentLocationView(newLocation: $newLocation).environmentObject(userViewConfig)
    }
}
