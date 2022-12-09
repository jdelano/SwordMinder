//
//  GameView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct GameView: View {
    @Binding var currentApp: Apps
    
    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    WordSearchAppIconView {
                        withAnimation {
                            currentApp = .wordSearchApp
                        }
                    }
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                }
                GridRow {
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                    JustMemorizeAppIconView {
                        withAnimation {
                            currentApp = .justMemorizeApp
                        }
                    }
                }
                GridRow {
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                }
                GridRow {
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                }
                GridRow {
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                }
                GridRow {
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                    SampleAppIconView {
                        withAnimation {
                            currentApp = .sampleApp
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(currentApp: .constant(.swordMinder))
    }
}
