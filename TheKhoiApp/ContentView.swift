//
//  ContentView.swift
//  TheKhoiApp
//
//  Created by Anjo on 11/6/25.
//

import SwiftUI

// MARK: - Main Entry Point
struct ContentView: View {
    @State private var isOnboardingComplete = false
    
    var body: some View {
        if isOnboardingComplete {
            RootView()
        } else {
            OnboardingView(isOnboardingComplete: $isOnboardingComplete)
        }
    }
}

// MARK: - Theme & Colors
struct KHOIColors {
    static let background = Color(hex: "F5F1ED")
    static let white = Color(hex: "FFFFFF")
    static let cream = Color(hex: "F9F7F4")
    static let softBrown = Color(hex: "A89080")
    static let accentBrown = Color(hex: "8B7355")
    static let darkText = Color(hex: "2C2420")
    static let mutedText = Color(hex: "8A827C")
    static let cardBackground = Color.white
    static let divider = Color(hex: "E8E3DD")
    static let chipBackground = Color(hex: "EDE8E3")
    static let selectedChip = accentBrown
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct KHOITheme {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title = Font.system(size: 28, weight: .semibold, design: .default)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 15, weight: .regular, design: .default)
    static let callout = Font.system(size: 14, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .medium, design: .default)
    
    static let spacing_xs: CGFloat = 4
    static let spacing_sm: CGFloat = 8
    static let spacing_md: CGFloat = 12
    static let spacing_lg: CGFloat = 16
    static let spacing_xl: CGFloat = 24
    static let spacing_xxl: CGFloat = 32
    
    static let cornerRadius_sm: CGFloat = 8
    static let cornerRadius_md: CGFloat = 12
    static let cornerRadius_lg: CGFloat = 16
    static let cornerRadius_pill: CGFloat = 100
}

// MARK: - Models
struct InspoPost: Identifiable {
    let id: UUID
    let imageHeight: CGFloat
    let imageURL: URL?
    let artistName: String
    let artistHandle: String
    let tag: String
    
    init(
        id: UUID = UUID(),
        imageHeight: CGFloat,
        imageURL: URL? = nil,
        artistName: String,
        artistHandle: String,
        tag: String
    ) {
        self.id = id
        self.imageHeight = imageHeight
        self.imageURL = imageURL
        self.artistName = artistName
        self.artistHandle = artistHandle
        self.tag = tag
    }
}

extension InspoPost {
    static let samples: [InspoPost] = [
        InspoPost(imageHeight: 280, artistName: "Jasmine Lee", artistHandle: "@mua_jas", tag: "Soft glam"),
        InspoPost(imageHeight: 320, artistName: "Maya Chen", artistHandle: "@mayabeauty", tag: "Bridal"),
        InspoPost(imageHeight: 240, artistName: "Sofia Martinez", artistHandle: "@sofiaglam", tag: "Full beat"),
        InspoPost(imageHeight: 300, artistName: "Aisha Williams", artistHandle: "@aisha_mua", tag: "Natural"),
        InspoPost(imageHeight: 260, artistName: "Emma Thompson", artistHandle: "@emmaartistry", tag: "Editorial"),
        InspoPost(imageHeight: 340, artistName: "Priya Patel", artistHandle: "@priya_beauty", tag: "Glam"),
        InspoPost(imageHeight: 220, artistName: "Luna Rodriguez", artistHandle: "@luna_makeup", tag: "Dewy skin"),
        InspoPost(imageHeight: 290, artistName: "Zara Kim", artistHandle: "@zara_mua", tag: "Bold lips"),
        InspoPost(imageHeight: 310, artistName: "Chloe Davis", artistHandle: "@chloebeauty", tag: "Soft glam"),
        InspoPost(imageHeight: 270, artistName: "Nadia Ali", artistHandle: "@nadia_artistry", tag: "Bridal"),
    ]
}

enum ServiceCategory: String, CaseIterable {
    case all = "All"
    case makeup = "Makeup"
    case hair = "Hair"
    case nails = "Nails"
    case lashes = "Lashes"
    case skin = "Skin"
}

// MARK: - Components
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(KHOITheme.callout)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : KHOIColors.darkText)
                .padding(.horizontal, KHOITheme.spacing_lg)
                .padding(.vertical, KHOITheme.spacing_sm)
                .background(
                    Capsule()
                        .fill(isSelected ? KHOIColors.selectedChip : KHOIColors.chipBackground)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : KHOIColors.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct InspoCard: View {
    let post: InspoPost
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: KHOITheme.spacing_sm) {
                // Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: width, height: post.imageHeight)
                    .overlay(
                        AsyncImage(url: post.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ZStack {
                                Color.gray.opacity(0.1)
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: KHOITheme.cornerRadius_md))
                
                // Artist info
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.artistHandle)
                        .font(KHOITheme.callout)
                        .fontWeight(.medium)
                        .foregroundColor(KHOIColors.darkText)
                    
                    Text(post.tag)
                        .font(KHOITheme.caption)
                        .foregroundColor(KHOIColors.mutedText)
                }
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
    }
}

struct MasonryGrid<Content: View, T: Identifiable>: View {
    let items: [T]
    let columns: Int
    let spacing: CGFloat
    let content: (T, CGFloat) -> Content
    
    init(
        items: [T],
        columns: Int = 2,
        spacing: CGFloat = 12,
        @ViewBuilder content: @escaping (T, CGFloat) -> Content
    ) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let columnWidth = (geometry.size.width - (CGFloat(columns - 1) * spacing)) / CGFloat(columns)
            
            ScrollView {
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { columnIndex in
                        LazyVStack(spacing: spacing) {
                            ForEach(itemsForColumn(columnIndex)) { item in
                                content(item, columnWidth)
                            }
                        }
                    }
                }
                .padding(.horizontal, KHOITheme.spacing_lg)
                .padding(.vertical, KHOITheme.spacing_md)
            }
        }
    }
    
    private func itemsForColumn(_ columnIndex: Int) -> [T] {
        items.enumerated()
            .filter { $0.offset % columns == columnIndex }
            .map { $0.element }
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        ZStack {
            KHOIColors.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo and tagline
                VStack(spacing: KHOITheme.spacing_md) {
                    Text("KHOI")
                        .font(KHOITheme.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(KHOIColors.darkText)
                        .tracking(2)
                    
                    Text("where beauty finds you.")
                        .font(KHOITheme.body)
                        .foregroundColor(KHOIColors.mutedText)
                        .tracking(0.5)
                }
                .padding(.bottom, KHOITheme.spacing_xxl)
                
                // Auth buttons
                VStack(spacing: KHOITheme.spacing_md) {
                    Button {
                        isOnboardingComplete = true
                    } label: {
                        HStack(spacing: KHOITheme.spacing_md) {
                            Image(systemName: "apple.logo")
                                .font(.title3)
                            Text("Continue with Apple")
                                .font(KHOITheme.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, KHOITheme.spacing_lg)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: KHOITheme.cornerRadius_md))
                    }
                    
                    Button {
                        isOnboardingComplete = true
                    } label: {
                        HStack(spacing: KHOITheme.spacing_md) {
                            Image(systemName: "globe")
                                .font(.title3)
                            Text("Continue with Google")
                                .font(KHOITheme.headline)
                        }
                        .foregroundColor(KHOIColors.darkText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, KHOITheme.spacing_lg)
                        .background(KHOIColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: KHOITheme.cornerRadius_md)
                                .stroke(KHOIColors.divider, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: KHOITheme.cornerRadius_md))
                    }
                }
                .padding(.horizontal, KHOITheme.spacing_xl)
                
                // TOS text
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(KHOITheme.caption)
                    .foregroundColor(KHOIColors.mutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, KHOITheme.spacing_xl)
                    .padding(.top, KHOITheme.spacing_lg)
                    .padding(.bottom, KHOITheme.spacing_xxl)
                
                Spacer()
                
                //image
            }
        }
    }
}

// MARK: - Home View Model
@Observable
class HomeViewModel {
    var posts: [InspoPost] = InspoPost.samples
    var selectedCategory: ServiceCategory = .all
    
    var filteredPosts: [InspoPost] {
        if selectedCategory == .all {
            return posts
        }
        return posts
    }
    
    func selectCategory(_ category: ServiceCategory) {
        selectedCategory = category
    }
}

// MARK: - Home View
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                KHOIColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: KHOITheme.spacing_sm) {
                            ForEach(ServiceCategory.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.rawValue,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectCategory(category)
                                }
                            }
                        }
                        .padding(.horizontal, KHOITheme.spacing_lg)
                        .padding(.vertical, KHOITheme.spacing_md)
                    }
                    .background(KHOIColors.cream)
                    
                    // Masonry grid
                    MasonryGrid(
                        items: viewModel.filteredPosts,
                        columns: 2,
                        spacing: KHOITheme.spacing_md
                    ) { post, width in
                        InspoCard(post: post, width: width) {
                            // Handle card tap
                        }
                    }
                }
            }
            .navigationTitle("KHOI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Settings action
                    } label: {
                        Circle()
                            .fill(KHOIColors.chipBackground)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(KHOIColors.softBrown)
                            )
                    }
                }
            }
        }
    }
}

// MARK: - Browse View
struct BrowseView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                KHOIColors.background
                    .ignoresSafeArea()
                
                Text("Browse/Explore")
                    .font(KHOITheme.title2)
                    .foregroundColor(KHOIColors.mutedText)
            }
            .navigationTitle("Explore")
        }
    }
}

// MARK: - Chats View
struct ChatsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                KHOIColors.background
                    .ignoresSafeArea()
                
                Text("Chats")
                    .font(KHOITheme.title2)
                    .foregroundColor(KHOIColors.mutedText)
            }
            .navigationTitle("Messages")
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                KHOIColors.background
                    .ignoresSafeArea()
                
                Text("Profile & Appointments")
                    .font(KHOITheme.title2)
                    .foregroundColor(KHOIColors.mutedText)
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Root View (Tab Bar)
struct RootView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            BrowseView()
                .tabItem {
                    Label("Explore", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
            
            ChatsView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(KHOIColors.accentBrown)
    }
}

#Preview {
    ContentView()
}
