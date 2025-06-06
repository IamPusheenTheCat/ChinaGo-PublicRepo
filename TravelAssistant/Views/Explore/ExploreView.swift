//
//  ExploreView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedItem: GuideItem?
    @State private var showingArticle = false
    @State private var showingSettings = false
    @State private var featuredArticle: GuideItem = GuideItem(
        icon: "tram.fill",
        title: "High-speed Rail",
        color: .blue,
        category: .transportation
    )
    
    @FocusState private var isSearchFocused: Bool
    
    // Search results computed property
    private var searchResults: [GuideItem] {
        if searchText.isEmpty {
            return []
        }
        
        let allItems = GuideCategory.allCategories.flatMap { $0.items }
        return allItems.filter { item in
            item.title.localizedCaseInsensitiveContains(searchText) ||
            getCategoryName(for: item.category).localizedCaseInsensitiveContains(searchText) ||
            getSearchKeywords(for: item).contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // Filtered categories
    private var filteredCategories: [GuideCategory] {
        if searchText.isEmpty {
            return GuideCategory.allCategories
        }
        
        return GuideCategory.allCategories.compactMap { category in
            let filteredItems = category.items.filter { item in
                searchResults.contains { $0.id == item.id }
            }
            
            if !filteredItems.isEmpty {
                return GuideCategory(
                    title: category.title,
                    icon: category.icon,
                    items: filteredItems,
                    description: category.description
                )
            }
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header title with settings button
                HStack {
                    Text("Explore China")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for questions or services", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isSearchFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isSearchFocused = false
                                }
                            }
                        }
                        .onChange(of: searchText) { _, newValue in
                            // Real-time feedback can be added here
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Search results or default content
                if !searchText.isEmpty {
                    // Display search results
                    SearchResultsSection(searchText: searchText, results: searchResults, onItemTap: { item in
                        selectedItem = item
                        featuredArticle = item // Update featured article
                    })
                } else {
                    // Featured article content preview
                    FeaturedArticleSection(article: featuredArticle, onReadMore: { item in
                        selectedItem = item
                    })
                    
                    // Categories section
                    ForEach(filteredCategories) { category in
                        CategorySection(category: category, onItemTap: { item in
                            selectedItem = item
                        })
                    }
                }
            }
            .padding(.vertical)
        }
        .sheet(item: $selectedItem) { item in
            getArticleView(for: item)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    @ViewBuilder
    private func getArticleView(for item: GuideItem) -> some View {
        switch item.title {
        // Transportation
        case "High-speed Rail":
            HighSpeedRailArticleView()
        case "Subway":
            SubwayArticleView()
        case "Bus Transport":
            BusTransportArticleView()
        case "Ride-hailing":
            RideHailingArticleView()
        case "Shared Bikes":
            SharedBikeArticleView()
        case "Parking Guide":
            ParkingGuideView()
            
        // Payment
        case "WeChat Pay":
            WeChatPayArticleView()
        case "Alipay":
            AlipayArticleView()
        case "Bank Cards":
            BankCardArticleView()
        case "QR Code Payment":
            QRCodePaymentArticleView()
            
        // Food & Dining
        case "Food Delivery":
            FoodDeliveryArticleView()
        case "Restaurant Booking":
            RestaurantBookingArticleView()
        case "Bubble Tea Culture":
            BubbleTeaCultureArticleView()
        case "Grocery Shopping":
            GroceryShoppingArticleView()
            
        // Accommodation
        case "Hotel Booking":
            HotelBookingArticleView()
        case "Homestay/Airbnb":
            AirbnbArticleView()
        case "Youth Hostel":
            HostelArticleView()
        case "Long-term Rental":
            LongTermRentalArticleView()
            
        // Services
        case "Banking Services":
            BankingServiceArticleView()
        case "Telecom Services":
            TelecomServiceArticleView()
        case "Shopping Guide":
            ShoppingGuideArticleView()
        case "Medical Services":
            MedicalServiceArticleView()
            
        // Entertainment
        case "Ticket Booking":
            TicketBookingArticleView()
        case "Entertainment Venues":
            EntertainmentVenuesArticleView()
        case "Cultural Sites":
            CulturalSitesArticleView()
        case "Travel Photography":
            TravelPhotographyArticleView()
            
        default:
            // This should never be reached now since all items are covered
            GenericArticleView(item: item)
        }
    }
    
    private func getMatchedKeyword(for item: GuideItem, searchText: String) -> String? {
        let keywords = getSearchKeywords(for: item)
        return keywords.first { keyword in
            keyword.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func getSearchKeywords(for item: GuideItem) -> [String] {
        switch item.title {
        case "bus":
            return [
                // Basic terms
                "bus", "public transport", "bus stop", "bus card", "transit",
                // English terms
                "Bus", "Public Transport", "Bus Stop", "Bus Card", "Transit",
                // Related terms
                "bus", "coach", "stop", "route", "line", "boarding", "alighting", "coin",
                "card", "scan", "monthly pass", "day pass", "student pass", "senior pass", "discount",
                "seat", "handrail", "door", "announcement", "terminal", "starting point",
                "night bus", "overnight", "first bus", "last bus", "departure", "interval"
            ]
        case "high-speed rail":
            return [
                // Basic terms
                "high-speed rail", "train", "CRH", "EMU", "ticket", "12306", "railway",
                // English terms
                "High-speed Rail", "Train", "Railway", "Ticket", "HSR", "Bullet Train",
                // Related terms
                "high-speed", "rail", "train", "service", "seat", "first class", "second class", "business class",
                "real-name", "purchase", "verification", "waiting", "check-in", "platform", "carriage", "riding",
                "spring festival", "holiday", "booking", "refund", "change", "delay", "on-time",
                // Specific routes
                "Beijing-Shanghai", "Beijing-Guangzhou", "Beijing-Tianjin", "Shanghai-Kunming", "Harbin-Dalian", "Lanzhou-Xinjiang", "Chengdu-Chongqing"
            ]
        case "subway":
            return [
                // Basic terms
                "subway", "metro", "underground", "transit card", "transfer", "metro",
                // English terms
                "Subway", "Underground", "Metropolitan", "Metro Card", "Transit",
                // Related terms
                "underground", "rail", "station", "line", "transfer station", "first/last train", "peak", "off-peak",
                "security check", "entry", "exit", "card swipe", "scan", "gate", "elevator", "escalator",
                "carriage", "seat", "priority seat", "accessibility", "emergency stop"
            ]
        case "taxi/ride-hailing":
            return [
                // Basic terms
                "taxi", "DiDi", "cab", "ride-hailing", "car service", "call car", "carpool",
                // English terms
                "Taxi", "Cab", "Ride-hailing", "Uber", "Lyft", "Driver",
                // Platform brands
                "DiDi", "AutoNavi", "Meituan", "Cao Cao", "T3", "Shouqi", "Hello",
                // Related terms
                "driver", "passenger", "start", "destination", "route", "navigation", "pricing", "distance",
                "duration", "peak", "surge", "coupon", "red packet", "voucher", "membership",
                "safety", "recording", "location", "share trip", "emergency contact", "insurance",
                "express", "premium", "luxury", "carpool", "hitchhike", "designated driver"
            ]
        case "shared bikes":
            return [
                // Basic terms
                "bike", "bicycle", "Mobike", "Hello", "cycling", "scan", "shared",
                // English terms
                "Bike Sharing", "Bicycle", "Shared Bike", "QR Code", "Cycling",
                // Platform brands
                "Mobike", "Hello", "Qingju", "Meituan Bike", "Youon",
                "Bluegogo", "ofo", "hellobike",
                // Related terms
                "ride", "park", "lock", "unlock", "scan", "QR code", "App",
                "deposit", "recharge", "balance", "pricing", "hourly", "per trip", "monthly pass", "annual pass",
                "parking", "standard", "irregular parking", "maintenance", "fault", "report", "credit",
                "eco-friendly", "health", "exercise", "short distance", "last mile"
            ]
        case "wechat pay":
            return [
                // Basic terms
                "WeChat", "scan payment", "mobile payment", "digital payment", "Tencent",
                // English terms
                "WeChat Pay", "Mobile Payment", "QR Payment", "Tencent", "Digital Wallet",
                // Related terms
                "QR code", "scan", "payment code", "collection code", "transfer", "red packet", "balance",
                "bank card", "binding", "real-name", "verification", "password", "fingerprint", "face ID", "voice print",
                "merchant", "small business", "personal code", "merchant code", "rate", "withdrawal", "deposit",
                "limit", "security", "risk control", "freeze", "unfreeze", "customer service", "complaint",
                "mini program", "official account", "utility payment", "phone bill", "utilities", "gas bill"
            ]
        case "alipay":
            return [
                // Basic terms
                "Alipay", "Alibaba", "Ant", "Huabei", "Yu'ebao", "scan", "payment",
                // English terms
                "Ant Financial", "Alibaba", "Digital Payment", "E-wallet", "QR Pay",
                // Product features
                "Huabei", "Jiebei", "Yu'ebao", "Yulibao", "Zhaocaibao", "MYbank",
                "Zhima Credit", "Zhima Score", "Credit Free Deposit", "Pay Later",
                // Related terms
                "scan", "payment", "collection", "transfer", "red packet", "five blessings", "ant forest",
                "ant farm", "sports", "steps", "charity", "donation", "investment", "fund",
                "insurance", "medical", "travel", "life services", "bills", "recharge", "credit card repayment",
                "Taobao", "Tmall", "1688", "Xianyu", "Ele.me", "Koubei", "AutoNavi"
            ]
        case "bank cards":
            return [
                // Basic terms
                "debit card", "credit card", "bank", "ATM", "swipe", "finance",
                // English terms
                "Bank Card", "Debit Card", "Credit Card", "ATM", "Banking", "Finance",
                // Bank names
                "ICBC", "CCB", "ABC", "BOC", "BoCom", "Postal Savings",
                "CMB", "CITIC", "CEB", "HXB", "CMBC", "SPDB",
                "CIB", "PAB", "CGB", "HFB", "CBHB", "CZB",
                // Related terms
                "account opening", "account closing", "activation", "loss report", "replacement", "password", "PIN", "CVV",
                "expiry date", "limit", "overdraft", "repayment", "installment", "minimum payment", "full payment",
                "interest", "annual fee", "service charge", "withdrawal", "transfer", "remittance", "investment",
                "fixed deposit", "current deposit", "deposit", "loan", "mortgage", "car loan", "consumer loan"
            ]
        case "qr code payment":
            return [
                // Basic terms
                "QR code", "scan", "code payment", "mobile payment",
                // English terms
                "QR Code", "Barcode", "Scan to Pay", "Mobile Payment", "Contactless",
                // Related terms
                "scan", "recognize", "aim", "focus", "payment code", "collection code", "dynamic code",
                "static code", "personal code", "merchant code", "password-free", "small amount", "limit", "security",
                "anti-counterfeiting", "encryption", "validity", "expired", "refresh", "regenerate",
                "camera", "flash", "album", "save", "share", "print",
                "merchant", "customer", "cashier", "checkout", "change", "receipt", "invoice"
            ]
        case "food delivery":
            return [
                // Basic terms
                "food delivery", "takeout", "Meituan", "Ele.me", "delivery", "order", "express",
                // English terms
                "Food Delivery", "Takeout", "Meituan", "Ele.me", "Delivery", "Order",
                // Platform brands
                "Meituan", "Ele.me", "Baidu Takeout", "JD.com", "Hebox", "Dingdong",
                "Every Fresh", "Pops", "Yonghui", "Dafen", "Walmart",
                // Related terms
                "ordering", "menu", "restaurant", "merchant", "rating", "review", "taste",
                "delivery fee", "minimum order", "discount", "coupon", "red packet", "membership", "super membership",
                "delivery rider", "rider", "arrival", "on time", "delay", "pickup", "contact",
                "Chinese food", "Western food", "Japanese food", "Korean food", "Thai food", "Indian food", "Halal",
                "fast food", "main course", "night snack", "afternoon tea", "dessert", "beverage", "fruit",
                "packing", "tableware", "eco-friendly", "hygiene", "safety", "insulation", "cold chain"
            ]
        case "restaurant booking":
            return [
                // Basic terms
                "restaurant booking", "reservation", "Dianping", "restaurant", "food", "queue", "waiting",
                // English terms
                "Restaurant Reservation", "Booking", "Dianping", "Queue", "Dining",
                // Platform brands
                "Dianping", "Meituan", "Koubei", "OpenTable", "Yelp", "Baidu Nongmi",
                "Taobao Food", "JD.com", "Suning", "Tmall",
                // Related terms
                "booking", "private room", "dining hall", "window", "corner", "quiet", "busy", "gathering",
                "birthday", "date", "business", "family", "friends", "colleague", "celebration", "holiday",
                "cuisine", "Sichuan cuisine", "Cantonese cuisine", "Hunan cuisine", "Shandong cuisine", "Su cuisine", "Zhejiang cuisine", "Fujian cuisine", "Hu cuisine",
                "hot pot", "barbecue", "seafood", "buffet", "tea house", "coffee shop", "bar", "KTV",
                "rating", "review", "recommendation", "special", "signboard", "average", "environment", "service",
                "discount", "group purchase", "voucher", "discount", "membership", "points", "cashback"
            ]
        case "bubble tea":
            return [
                // Basic terms
                "bubble tea", "tea drink", "Xi Tea", "Naixue", "Yidian Dian", "Pearl", "Tea Culture",
                // English terms
                "Bubble Tea", "Milk Tea", "Boba", "Tea Culture", "Beverage", "Drink",
                // Brand names
                "Xi Tea", "Naixue Tea", "Yidian Dian", "CoCo", "Tea Colorful", "Mihua Ice",
                "Gu Ming", "Shuyi Burned Grass", "Tea Hundred", "7 Points Sweet", "Luojang", "Gong Tea",
                "Happy Lemon", "Big Cass", "50 Lan", "Qingxin Fuquan", "Tea Tai", "Sunrise Tea Tai",
                // Related terms
                "Pearl", "Boba", "Coconut", "Tapioca", "Pudding", "Red Bean", "Peanut", "Taro",
                "Sweetness", "Ice", "Normal Sweet", "Half Sugar", "Micro Sugar", "No Sugar", "Normal Ice", "Less Ice", "No Ice", "Hot Drink",
                "Tea Base", "Green Tea", "Black Tea", "Oolong Tea", "Mellower", "Pu'er", "Iron Buddha",
                "Fresh Milk", "Milk Foam", "Cheese", "Milk Foam", "Milk Shake", "Fruit Tea", "Lemon Tea", "Fruit Tea",
                "ordering", "queue", "limit purchase", "flash sale", "new product", "seasonal limit", "net red", "check-in"
            ]
        case "grocery shopping":
            return [
                // Basic terms
                "grocery shopping", "vegetables", "fruits", "fresh food", "supermarket", "market", "Hebox",
                // English terms
                "Fresh Food", "Grocery", "Vegetables", "Fruits", "Supermarket", "Market",
                // Platform brands
                "Hebox", "Dingdong", "Every Fresh", "JD Fresh", "Suning Fresh", "Yonghui",
                "Dafen", "Wumart", "Jiale", "Wu", "Huarun", "Century Union",
                "Pops", "Qian Dama", "Yiping Fresh", "Fresh Legend", "Guoquan",
                // Related terms
                "fresh", "organic", "green", "pesticide-free", "origin", "origin", "import", "domestic",
                "vegetables", "fruits", "meat", "seafood", "egg", "milk", "bean", "condiment",
                "frozen", "refrigerated", "normal temperature", "shelf life", "production date", "storage", "freshness",
                "delivery", "self-pickup", "home", "store", "warehouse", "cold chain", "insulation", "packaging",
                "selection", "quality", "weight", "pricing", "weighing", "discount", "promotion", "special price",
                "membership", "points", "coupon", "full reduction", "buy one and give one", "limited time flash sale"
            ]
        case "hotel booking":
            return [
                // Basic terms
                "hotel booking", "hotel", "guest house", "booking", "check-in", "Xiecheng", "booking",
                // English terms
                "Hotel", "Accommodation", "Booking", "Reservation", "Check-in", "Check-out",
                // Platform brands
                "Xiecheng", "Qunaer", "Feizhu", "Meituan Hotel", "Tongcheng Yilong", "Mafo", "Tuniu",
                "Booking.com", "Agoda", "Hotels.com", "Expedia", "Yilong", "Zhouer",
                // Hotel types
                "Five-star", "Four-star", "Three-star", "Economic", "Luxury", "Deluxe", "Business", "Holiday",
                "Chain", "International", "Local", "Nationality", "Theme", "Design", "Selection", "Zhenxuan",
                // Brand hotels
                "Rujia", "Hanting", "7 Days", "Greenhao Tai", "Jinjiang Star", "Hua Zhu", "Shouli Ruojia",
                "Marriott", "Hilton", "Intercontinental", "Hyatt", "Aga", "Wyndham", "Selection",
                // Related terms
                "check-in", "check-out", "booking", "cancellation", "change", "extension", "early check-out",
                "room type", "standard room", "double bed room", "suite", "family room", "non-smoking room",
                "breakfast", "breakfast included", "breakfast not included", "self-service breakfast", "WiFi", "parking", "gym", "swimming pool",
                "price", "room fee", "tax fee", "service fee", "deposit", "prepaid", "pay on arrival", "free cancellation"
            ]
        case "homestay/Airbnb":
            return [
                // Basic terms
                "homestay", "short rent", "Airbnb", "Tuya", "Xiao Zhu", "accommodation", "landlord",
                // English terms
                "Homestay", "Vacation Rental", "Short-term Rental", "Host", "Guest",
                // Platform brands
                "Airbnb", "Tuya", "Xiao Zhu Short Rent", "Munao Short Rent", "Zhen Guo Homestay", "Meituan Homestay",
                "Qunaer Homestay", "Xiecheng Homestay", "Ant Homestay", "Zhu Bai Homestay", "Da Yu Self-driving Tour",
                // Related terms
                "landlord", "guest", "entire", "independent", "sharing", "sharing", "bed", "sofa guest",
                "apartment", "villa", "loft", "duplex", "single-storey", "attic", "basement", "garden",
                "kitchen", "living room", "bedroom", "bathroom", "balcony", "terrace", "yard", "parking space",
                "furniture", "appliances", "WiFi", "air conditioner", "heating", "washing machine", "refrigerator", "microwave",
                "check-in", "check-out", "self", "password lock", "key", "door lock", "cleaning", "maintenance",
                "review", "rating", "property", "description", "photos", "location", "traffic", "surroundings",
                "price", "cleaning fee", "service fee", "deposit", "booking", "cancellation", "refund"
            ]
        case "youth hostel":
            return [
                // Basic terms
                "youth hostel", "YHA", "hostel", "backpacker", "bed", "student", "economic accommodation",
                // English terms
                "Youth Hostel", "Backpacker", "Dormitory", "Bunk Bed", "Budget", "Traveler",
                // Related terms
                "multi-person room", "male dormitory", "female dormitory", "mixed dormitory", "upper and lower bunk", "curtain", "storage cabinet",
                "public", "sharing", "washroom", "bathroom", "kitchen", "living room", "dining room", "terrace",
                "social", "socializing", "chatting", "game", "activity", "gathering", "BBQ", "night movie",
                "international", "backpacker", "poor travel", "self-driving travel", "free travel", "Gap Year", "student",
                "cheap", "economic", "affordable", "cost-effectiveness", "budget", "saving",
                "safety", "female-specific", "door lock", "monitoring", "safe deposit", "luggage storage",
                "location", "city center", "traffic convenience", "subway station", "attraction", "business district", "night market"
            ]
        case "long-term rental":
            return [
                // Basic terms
                "renting", "apartment", "Ziruo", "Eggshell", "long rent", "rent", "renting",
                // English terms
                "Long-term Rental", "Apartment", "Rent", "Lease", "Landlord", "Tenant",
                // Platform brands
                "Ziruo", "Eggshell Apartment", "Qingke", "Mo Fang Apartment", "Po Apartment", "Guan Apartment", "Lehu",
                "Wo Qu", "Hongpu", "Chengjia", "YOU+", "V-shaped land", "New Apartment", "Lang Shi Apartment",
                // Related terms
                "entire rent", "sharing", "sharing", "partition", "main room", "secondary room", "living room", "balcony",
                "one-bedroom", "two-bedroom", "three-bedroom", "loft", "duplex", "jump", "flat", "top",
                "decoration", "fine decoration", "simple decoration", "rough decoration", "furniture", "appliances", "full equipment", "empty room",
                "one-pay-three", "two-pay-one", "deposit", "agency fee", "service fee", "management fee",
                "water", "network fee", "property fee", "heating fee", "gas fee", "garbage fee", "parking fee",
                "contract", "rent period", "extension", "termination", "breach", "deposit refund", "landlord", "roommate",
                "location", "location", "traffic", "subway", "bus", "school", "hospital", "mall"
            ]
        case "banking services":
            return [
                // Basic terms
                "bank", "account opening", "deposit", "loan", "investment", "financial services",
                // English terms
                "Banking", "Account", "Deposit", "Loan", "Investment", "Financial Services",
                // Bank types
                "State-owned Bank", "Joint-stock Bank", "City Commercial Bank", "Rural Commercial Bank", "Village Bank", "Foreign Bank",
                "Policy Bank", "Development Bank", "Import and Export Bank", "Agricultural Development Bank",
                // Service items
                "account opening", "account closing", "deposit", "withdrawal", "transfer", "remittance", "investment", "fund",
                "insurance", "trust", "bond", "stock", "foreign exchange", "gold", "silver", "crude oil",
                "mortgage", "car loan", "consumer loan", "business loan", "renovation loan", "education loan", "credit loan",
                "credit card", "debit card", "savings card", "prepaid card", "corporate card", "co-branded card",
                // Related terms
                "online banking", "mobile banking", "ATM", "counter", "lobby", "VIP", "VIP", "private banking",
                "interest", "income", "risk", "guaranteed", "non-guaranteed", "structured", "net value",
                "fixed deposit", "current deposit", "notification", "whole deposit and withdrawal", "zero deposit and withdrawal"
            ]
        case "mobile services":
            return [
                // Basic terms
                "mobile", "SIM card", "data", "plan", "mobile", "union", "telecom",
                // English terms
                "Mobile", "SIM Card", "Data", "Plan", "Telecom", "Network", "4G", "5G",
                // Operator
                "China Mobile", "China Union", "China Telecom", "China Broadcast", "Mobile", "Union", "Telecom", "Broadcast",
                // Business type
                "prepaid", "postpaid", "contract phone", "naked phone", "recharge", "payment", "shutdown", "reactivation",
                // Plan content
                "call", "SMS", "data", "voice", "internet", "domestic", "international", "roaming",
                "unlimited data", "directional data", "general data", "provincial", "local", "long distance",
                "free call", "family number", "family network", "group network", "enterprise network",
                // Related terms
                "signal", "coverage", "base station", "network speed", "delay", "disconnection", "disconnection", "speed limit",
                "real-name", "ID card", "face recognition", "counter", "customer service", "10086", "10010", "10000"
            ]
        case "shopping guide":
            return [
                // Basic terms
                "shopping", "mall", "Taobao", "JD", "e-commerce", "buy things", "consumption",
                // English terms
                "Shopping", "Mall", "E-commerce", "Online Shopping", "Retail", "Purchase",
                // E-commerce platforms
                "Taobao", "Tmall", "JD", "Pinduoduo", "Suning", "Guomei", "Weipinhui", "Dangdang",
                "1688", "Xianyu", "Zhuanzhuan", "Xiaohongshu", "Douyin", "Kuaishou", "Weidian", "Youzan",
                // Shopping places
                "mall", "supermarket", "convenience store", "special store", "outlet", "tax-free shop", "wholesale market",
                "pedestrian street", "commercial street", "shopping center", "department store", "super market", "warehouse store",
                // Related terms
                "price comparison", "discount", "discount", "discount", "promotion", "special price", "clearance", "flash sale",
                "full reduction", "buy one and give one", "second half price", "member price", "points", "cashback",
                "coupon", "voucher", "red packet", "allowance", "shopping card", "gift card", "pickup ticket",
                "genuine", "fake", "counterfeit", "high imitation", "A-grade", "inspection", "identification", "authenticity",
                "return", "exchange", "seven-day no reason", "quality problem", "unhappy", "after-sales", "rights protection",
                "logistics", "express", "delivery", "self-pickup", "free shipping", "shipping fee", "pay on arrival", "price guarantee"
            ]
        case "medical services":
            return [
                // Basic terms
                "hospital", "seeing a doctor", "doctor", "registration", "medical insurance", "pharmacy", "health",
                // English terms
                "Hospital", "Doctor", "Medical", "Healthcare", "Insurance", "Pharmacy",
                // Hospital types
                "Three-star Hospital", "Two-star Hospital", "Specialty Hospital", "Comprehensive Hospital", "Private Hospital", "Public Hospital",
                "Community Hospital", "Clinic", "Health Center", "Emergency Center", "Physical Examination Center", "Rehabilitation Center",
                // Department
                "Internal Medicine", "Surgery", "Pediatrics", "Gynecology", "Orthopedics", "Ophthalmology", "ENT", "Oral",
                "Dermatology", "Neurology", "Psychology", "Mental Health", "Tumor", "Radiation", "ICU",
                // Related terms
                "registration", "queue", "call number", "visit", "diagnosis", "check", "test", "X-ray",
                "B-ultrasound", "CT", "MRI", "X-ray", "ECG", "blood routine", "urine routine", "liver function",
                "prescription", "drug", "traditional Chinese medicine", "western medicine", "infusion", "injection", "operation", "hospitalization",
                "medical card", "social security", "new rural integration", "reimbursement", "self-pay", "starting line", "ceiling line",
                "emergency", "outpatient", "expert number", "general number", "special needs", "international department", "VIP"
            ]
        case "cultural sites":
            return [
                // Basic terms
                "tourism", "attraction", "museum", "heritage", "culture", "history", "sightseeing",
                // English terms
                "Tourism", "Attraction", "Museum", "Heritage", "Culture", "History", "Sightseeing",
                // Attraction types
                "Gugong", "Great Wall", "Tiantan", "Yiheyuan", "Yuanmingyuan", "Shisanling", "Gongwangfu",
                "Tiananmen", "People's Great Hall", "National Museum", "Capital Museum", "Military Museum",
                "Natural Museum", "Technology Museum", "Art Museum", "Library", "Memorial Hall", "Exhibition Hall",
                // Related terms
                "ticket", "registration", "real-name", "ID card", "student ticket", "senior ticket", "free",
                "opening hours", "closure", "guide", "explanation", "voice guide", "rental", "deposit",
                "photograph", "video", "forbidden", "allowed", "flash", "tripod", "selfie stick",
                "cultural relics", "treasure", "national treasure", "level 1", "level 2", "level 3",
                "replica", "counterfeit", "exhibition", "special exhibition", "permanent exhibition", "temporary exhibition", "interactive exhibition",
                "cultural and creative products", "souvenir", "handmade", "gift", "book", "postcard", "refrigerator sticker"
            ]
        case "entertainment venues":
            return [
                // Basic terms
                "KTV", "entertainment", "game", "movie", "leisure", "night life", "leisure",
                // English terms
                "Entertainment", "KTV", "Karaoke", "Cinema", "Game", "Nightlife", "Recreation",
                // Entertainment types
                "KTV", "Karaoke", "Qiangui", "Haoleidi", "Meledidi", "Pure K", "Gathering",
                "Cinema", "Cinema", "Wanda", "CGV", "UME", "Bona", "Golden Eagle", "Dadi",
                "Internet Bar", "Internet Cafe", "Esports", "Game Hall", "Electric Playground", "Grab Doll", "Grab Doll",
                "Escape Room", "Murder Mystery", "Board Game", "Mahjong", "Poker", "Dou Di Zhu",
                // Related terms
                "package", "hall", "hour", "overnight", "day", "golden time", "discount", "group purchase",
                "membership", "recharge", "points", "exchange", "gift", "beverage", "snack", "fruit plate",
                "song", "accompany", "original", "cut song", "pause", "sound", "light", "atmosphere",
                "2D", "3D", "IMAX", "Dolby", "Laser", "Giant Screen", "VIP", "Couple Seat",
                "pre-sale", "first screening", "midnight screening", "early screening", "late screening", "golden screening", "student ticket"
            ]
        case "event tickets":
            return [
                // Basic terms
                "ticket", "event", "concert", "drama", "sports", "ticket", "Dama",
                // English terms
                "Tickets", "Concert", "Performance", "Theater", "Sports", "Show", "Event",
                // Ticket platform
                "Dama", "Mao Yan", "Yongle Ticket", "Motianlun", "Xi Shiqu", "Ju Cheng Network", "Piao Niu",
                "Tao Piao", "Ge Wala", "Shiguang Network", "Baidu Nongmi", "Weipiao", "Piao Wu",
                // Event types
                "Concert", "Music Concert", "Drama", "Music Drama", "Opera", "Dance Drama", "Comedy", "Sketch",
                "Sports Event", "Football", "Basketball", "Tennis", "Badminton", "Swimming", "Track and Field",
                "Exhibition", "Art Exhibition", "Painting Exhibition", "Photography Exhibition", "Technology Exhibition", "Car Exhibition", "House Exhibition", "Book Exhibition",
                // Related terms
                "ticket", "pre-sale", "ticket", "ticket", "remaining ticket", "sold out", "additional ticket", "additional",
                "seat", "VIP", "inner field", "outer field", "stand", "box", "front row", "back row",
                "real-name", "ID card", "face recognition", "electronic ticket", "paper ticket", "exchange", "check-in",
                "change", "transfer", "yellow cow", "ticket scalping", "ticket price", "premium", "discount"
            ]
        case "travel photography":
            return [
                // Basic terms
                "photograph", "photography", "check-in", "net red", "attraction", "travel photography", "camera",
                // English terms
                "Photography", "Photo", "Camera", "Selfie", "Instagram", "Social Media",
                // Shooting equipment
                "mobile", "camera", "single lens reflex", "micro single lens reflex", "lens", "wide angle", "telephoto", "fixed focus",
                "tripod", "selfie stick", "stabilizer", "cloud platform", "drone", "aerial photography", "GoPro",
                // Shooting techniques
                "composition", "light", "angle", "background", "foreground", "depth of field", "blur", "focus",
                "exposure", "ISO", "aperture", "shutter speed", "white balance", "HDR", "panorama", "time-lapse",
                "portrait", "landscape", "architecture", "street photography", "macro", "night", "sunrise", "sunset",
                // Related terms
                "net red spot", "check-in point", "ins style", "artistic style", "small fresh", "retro", "film",
                "filter", "retouching", "beauty", "slimming", "wrinkle removal", "color adjustment", "special effect",
                "friend circle", "microblog", "douyin", "xiaohongshu", "ins", "release", "share", "like",
                "travel photography", "portrait", "wedding photo", "graduation photo", "family photo", "couple photo", "sister photo"
            ]
        default:
            return [item.title]
        }
    }

    private func getPreviewArticle() -> GuideItem? {
        switch searchText.lowercased() {
        case "bus":
            return GuideCategory.allCategories[0].items[2]
        case "high-speed rail":
            return GuideCategory.allCategories[0].items[0]
        case "subway":
            return GuideCategory.allCategories[0].items[1]
        case "taxi", "ride-hailing":
            return GuideCategory.allCategories[0].items[3]
        case "shared bikes":
            return GuideCategory.allCategories[0].items[4]
        case "wechat pay":
            return GuideCategory.allCategories[1].items[0]
        case "alipay":
            return GuideCategory.allCategories[1].items[1]
        case "bank cards":
            return GuideCategory.allCategories[1].items[2]
        case "qr code payment":
            return GuideCategory.allCategories[1].items[3]
        case "food delivery":
            return GuideCategory.allCategories[2].items[0]
        case "restaurant booking":
            return GuideCategory.allCategories[2].items[1]
        case "bubble tea":
            return GuideCategory.allCategories[2].items[2]
        case "grocery shopping":
            return GuideCategory.allCategories[2].items[3]
        case "hotel booking":
            return GuideCategory.allCategories[3].items[0]
        case "homestay", "airbnb":
            return GuideCategory.allCategories[3].items[1]
        case "youth hostel":
            return GuideCategory.allCategories[3].items[2]
        case "long-term rental":
            return GuideCategory.allCategories[3].items[3]
        case "banking services":
            return GuideCategory.allCategories[4].items[0]
        case "mobile services":
            return GuideCategory.allCategories[4].items[1]
        case "shopping guide":
            return GuideCategory.allCategories[4].items[2]
        case "medical services":
            return GuideCategory.allCategories[4].items[3]
        case "cultural sites":
            return GuideCategory.allCategories[5].items[0]
        case "entertainment venues":
            return GuideCategory.allCategories[5].items[1]
        case "event tickets":
            return GuideCategory.allCategories[5].items[2]
        case "travel photography":
            return GuideCategory.allCategories[5].items[3]
        default:
            return nil
        }
    }

    // Add missing getCategoryName function
    private func getCategoryName(for category: GuideCategoryType) -> String {
        switch category {
        case .transportation:
            return "Transportation"
        case .payment:
            return "Payment"
        case .food:
            return "Food & Dining"
        case .accommodation:
            return "Accommodation"
        case .services:
            return "Services"
        case .entertainment:
            return "Entertainment"
        }
    }
}

// Search Results Section
struct SearchResultsSection: View {
    let searchText: String
    let results: [GuideItem]
    let onItemTap: (GuideItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                Text("Search Results")
                    .font(.headline)
                Spacer()
                Text("\(results.count) results")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if results.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No results found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Try adjusting your search terms")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(results) { item in
                        CategoryItemView(item: item) {
                            onItemTap(item)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Featured Article Section
struct FeaturedArticleSection: View {
    let article: GuideItem
    let onReadMore: (GuideItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Featured Guide")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [article.color, article.color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 160)
                        .cornerRadius(15)
                    
                    VStack(spacing: 8) {
                        Image(systemName: article.icon)
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Essential guide for China travel")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        onReadMore(article)
                    }) {
                        HStack {
                            Text("Read More")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// 分类部分视图 - 简洁风格
struct CategorySection: View {
    let category: GuideCategory
    let onItemTap: (GuideItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 分类标题 - 简洁风格
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(.primary)
                Text(category.title)
                    .font(.headline)
            }
            .padding(.horizontal)
            
            // 分类项网格
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(category.items) { item in
                    CategoryItemView(item: item) {
                        onItemTap(item)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// 分类项视图 - 简洁风格
struct CategoryItemView: View {
    let item: GuideItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(item.color)
                    .cornerRadius(8)
                
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 通用文章视图（为还没有专门文章的项目）
struct GenericArticleView: View {
    let item: GuideItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [item.color, item.color.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 200)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("\(item.title) Guide")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("📝 Content in Development")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("We are carefully preparing a detailed guide for \(item.title), including:")
                            .font(.body)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Detailed usage tutorials")
                            Text("• Practical operation tips")
                            Text("• Frequently asked questions")
                            Text("• Cultural background information")
                            Text("• Safety precautions")
                        }
                        .font(.body)
                        .padding(.leading)
                        
                        Text("Stay tuned! 🚀")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}