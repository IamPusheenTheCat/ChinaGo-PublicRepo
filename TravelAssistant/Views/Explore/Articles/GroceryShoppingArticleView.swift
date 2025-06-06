//
//  GroceryShoppingArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct GroceryShoppingArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Grocery Shopping")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Fresh Food Shopping Basics: Fresh Life
                        ArticleSection(title: "Fresh Food Shopping: Enjoy Fresh and Healthy Living", content: """
                        **Why Choose Fresh Food Shopping?**
                        China's fresh food market is well-developed, from traditional markets to modern supermarkets and online delivery, offering abundant choices! Fresh, affordable, and diverse, letting you experience authentic Chinese food culture.
                        
                        **Shopping Advantages**
                        • **High Freshness**: Same-day purchase, quality guaranteed 🌿
                        • **Affordable Prices**: Much cheaper than restaurants, great value 💰
                        • **Rich Selection**: Seasonal produce, local specialties 🍎
                        • **Cultural Experience**: Understanding Chinese daily dietary habits 👥
                        
                        **Shopping Venues**
                        • **Traditional Markets**: Most authentic, lowest prices 🏪
                        • **Large Supermarkets**: Good environment, stable quality 🏬
                        • **Fresh Food Markets**: Specialized, comprehensive selection 🥬
                        • **Online Platforms**: Home delivery, convenient and fast 📱
                        
                        **Suitable For**
                        • **Long-term Residents**: Foreigners working or studying in China 🏠
                        • **Home Cooks**: Travelers who enjoy cooking 👨‍🍳
                        • **Health-conscious**: People focused on nutritional balance 🥗
                        • **Budget-minded**: Economical choice 💡
                        
                        💡 **Beginner's Tip:** Start with supermarkets, then try traditional markets for a more authentic experience!
                        """)
                        
                        ImagePlaceholder(title: "Chinese Fresh Markets")
                        
                        // Purchase Channels: Each Has Its Features
                        ArticleSection(title: "Shopping Channels: Choose the Most Suitable Method", content: """
                        **Online Platforms (Most Convenient)**
                        • **Hema Fresh**: Alibaba's brand, 30-min delivery, high quality 📦
                        • **JD Home**: 1-hour delivery, rich supermarket products 🚚
                        • **Meituan Grocery**: Order in morning, afternoon delivery, affordable 🥬
                        • **Dmall**: Wumart online version, covers northern regions 🛒
                        
                        **Large Supermarkets (Quality Assured)**
                        • **Walmart**: International chain, familiar to foreigners 🌍
                        • **Carrefour**: French brand, wide variety 🇫🇷
                        • **CR Vanguard**: Local chain, dense network 🏪
                        • **Yonghui**: Fresh food specialist, reasonable prices 🐟
                        
                        **Fresh Food Specialty Stores**
                        • **Hema Stores**: New retail model, experiential shopping 🦞
                        • **7FRESH**: JD's offline stores, high-tech feel 💻
                        • **Suning Fresh**: Smart shopping experience 🤖
                        • **Yipin Fresh**: Community fresh food, convenient and affordable 🏘️
                        
                        **Traditional Markets**
                        • **Farmers' Markets**: Cheapest, most comprehensive 🌽
                        • **Morning/Night Markets**: Special operating hours, good deals 🌅
                        • **Community Markets**: Nearby shopping, neighborhood interaction 👥
                        • **Wholesale Markets**: Bulk purchases, suitable for group buying 📦
                        
                        **Convenience Stores**
                        • **7-11**: Japanese-style convenience, standardized products 🏪
                        • **FamilyMart**: Taiwanese brand, good ready-to-eat food 🍱
                        • **Lawson**: Japanese brand, excellent desserts 🍰
                        • **Local Convenience Stores**: Cheaper prices, wide coverage 💰
                        
                        🎯 **Selection Strategy:** Online platforms save time, supermarkets for quality, markets for savings, convenience stores for emergencies!
                        """)
                        
                        ImagePlaceholder(title: "Fresh Food Shopping Channels")
                        
                        // Shopping Process: Easy to Master
                        ArticleSection(title: "Shopping Process: From Selection to Receipt", content: """
                        **Online Shopping Process**
                        • **Download APP**: Choose reliable fresh food platform APP 📱
                        • **Register/Login**: Fill in phone number and delivery address 📝
                        • **Browse & Select**: View products by category, compare prices 👀
                        • **Add to Cart**: Choose appropriate specifications and quantities 🛒
                        • **Select Delivery**: Confirm delivery time and address 🚚
                        • **Online Payment**: WeChat, Alipay, or bank card 💳
                        • **Wait for Delivery**: Wait for delivery at agreed time ⏰
                        
                        **Physical Store Shopping Process**
                        • **Choose Time**: Avoid peak hours, choose fresh restocking times 🕐
                        • **Prepare Tools**: Eco bags, change, mobile phone 🛍️
                        • **Compare Shops**: Check several stores, compare prices and quality 👁️
                        • **Careful Selection**: Check freshness, avoid damaged goods 🔍
                        • **Weigh & Pay**: Self-service or ask staff for help ⚖️
                        • **Mobile Payment**: Prefer mobile payment methods 📱
                        • **Keep Receipt**: For possible returns 🧾
                        
                        **Market Shopping Tips**
                        • **Early/Late**: Morning for freshest, evening for best prices 🌅
                        • **Compare Three**: Compare similar items at different vendors 🔄
                        • **Bargaining**: Friendly bargaining, build good relationships 💬
                        • **Cash Ready**: Markets mostly use cash transactions 💰
                        • **Build Relations**: Become regular customer for better deals 🤝
                        
                        **Quality Assessment**
                        • **Vegetables**: Fresh leaves, no wilting or yellowing 🥬
                        • **Fruits**: Full color, no damage or rot 🍎
                        • **Meat**: Normal color, no odd smell 🥩
                        • **Seafood**: Bright eyes, red gills 🐟
                        
                        💪 **Shopping Tips:** Watch how locals select items, learn from them!
                        """)
                        
                        ImagePlaceholder(title: "Fresh Food Shopping Process")
                        
                        // Foreigner's Guide: Cultural Differences
                        ArticleSection(title: "Foreigner's Guide: Adapting to Chinese Shopping Habits", content: """
                        **Understanding Cultural Differences**
                        • **Bargaining Culture**: Bargaining okay in markets, fixed prices in supermarkets 💰
                        • **Cash Usage**: Traditional markets still use lots of cash 💵
                        • **Plastic Bags**: Bring eco-bags, reduce plastic use 🛍️
                        • **Seasonality**: Chinese value seasonal ingredients, prices vary greatly 🌱
                        
                        **Common Ingredients**
                        • **Chinese Vegetables**: Chinese cabbage, radish, eggplant, tofu 🥬
                        • **Seasonings**: Light soy sauce, dark soy sauce, cooking wine, Sichuan pepper 🧄
                        • **Noodles**: Noodles, dumpling wrappers, bun flour 🍜
                        • **Soy Products**: Tofu, tofu skin, dried tofu, soy milk 🥛
                        
                        **Measurement Units**
                        • **Weight Units**: Kilogram(kg), gram(g), jin(500g) ⚖️
                        • **Count Units**: Piece, item, strip, bunch, bundle 🔢
                        • **Price Display**: Yuan/jin, Yuan/kg, price per piece 💰
                        • **Special Measures**: Bunch (vegetables), strip (fish), piece (chicken) 📏
                        
                        **Payment Methods**
                        • **WeChat Pay**: Most common, scan QR code 📱
                        • **Alipay**: Equally convenient, with promotions 💙
                        • **Bank Cards**: Accepted at large supermarkets 💳
                        • **Cash**: Keep some cash for emergencies 💰
                        
                        **Language Communication**
                        • **Basic Vocabulary**: How much, cheaper please, is it fresh 🗣️
                        • **Translation Apps**: Prepare translation software 📱
                        • **Point & Buy**: Use gestures if can't speak 👉
                        • **Learn Numbers**: Master Chinese number expressions 🔢
                        
                        ⚠️ **Important Notes:** Respect local customs, stay patient, friendly communication is key!
                        """)
                        
                        ImagePlaceholder(title: "Foreigner's Shopping Guide")
                        
                        // Food Selection: Nutritional Balance
                        ArticleSection(title: "Food Selection: Balanced Nutrition for Healthy Living", content: """
                        **Vegetable Selection**
                        • **Leafy Greens**: Spinach, bok choy, Chinese cabbage, celery 🥬
                        • **Root Vegetables**: Potatoes, carrots, white radish, sweet potatoes 🥕
                        • **Gourds**: Winter melon, pumpkin, cucumber, tomatoes 🍅
                        • **Mushrooms**: Shiitake, enoki, king oyster, black fungus 🍄
                        
                        **Protein Sources**
                        • **Pork**: Belly, lean meat, ribs, trotters 🐷
                        • **Beef**: Brisket, shank, steak, sliced beef 🐄
                        • **Chicken**: Whole chicken, legs, breast, wings 🐔
                        • **Fish & Seafood**: Hairtail, carp, shrimp, crab 🐟
                        
                        **Staple Foods**
                        • **Rice**: White rice, millet, glutinous rice, black rice 🍚
                        • **Noodles**: Noodles, buns, dumplings, steamed buns 🍜
                        • **Grains**: Oats, red beans, mung beans, job's tears 🌾
                        • **Tubers**: Sweet potato, purple potato, yam, taro 🍠
                        
                        **Seasonings & Side Dishes**
                        • **Basic Seasonings**: Salt, sugar, vinegar, light & dark soy sauce 🧂
                        • **Aromatics**: Green onion, ginger, garlic, Sichuan pepper, star anise 🧄
                        • **Sauces**: Doubanjiang, sweet bean sauce, oyster sauce, sesame paste 🍯
                        • **Oils**: Peanut oil, rapeseed oil, olive oil, sesame oil 🫒
                        
                        **Seasonal Recommendations**
                        • **Spring**: Bamboo shoots, chives, shepherd's purse, spring onions 🌱
                        • **Summer**: Watermelon, cucumber, eggplant, long beans ☀️
                        • **Autumn**: Radish, Chinese cabbage, pumpkin, persimmons 🍂
                        • **Winter**: Napa cabbage, radish, winter melon, potatoes ❄️
                        
                        🌟 **Pairing Suggestions:** Balance meat and vegetables, maintain nutrition, eat seasonal produce for best health!
                        """)
                        
                        ImagePlaceholder(title: "Food Nutrition Pairing")
                        
                        // Storage: Extend Freshness
                        ArticleSection(title: "Storage: Keep Ingredients Fresh", content: """
                        **Refrigerated Storage**
                        • **Vegetable Preservation**: Separate in bags, avoid crushing 🥬
                        • **Meat Storage**: Portion and freeze, avoid repeated thawing 🥩
                        • **Seafood Handling**: Clean thoroughly, drain before storing 🐟
                        • **Egg Storage**: Blunt end up, avoid shaking 🥚
                        
                        **Room Temperature Storage**
                        • **Root Vegetables**: Store potatoes, onions, garlic in cool place 🧅
                        • **Fruit Storage**: Ripe fruit in fridge, unripe at room temperature 🍎
                        • **Dry Goods**: Seal well, prevent moisture and insects 🌾
                        • **Seasoning Storage**: Keep away from light, sealed, date marked 🧂
                        
                        **Freshness Tips**
                        • **Vegetable Moisture**: Wrap leafy greens in damp paper towels 💧
                        • **Fruit Ripening**: Place with bananas to speed ripening 🍌
                        • **Prevent Oxidation**: Lemon juice on cut apples 🍋
                        • **Remove Odors**: Place activated charcoal or tea leaves in fridge 🌿
                        
                        **Food Safety**
                        • **Separate Raw/Cooked**: Use different cutting boards and knives 🔪
                        • **Prompt Cleaning**: Clean immediately after purchase 🚿
                        • **Check Expiry**: Mark purchase date, use in order 📅
                        • **Monitor Changes**: Discard if spoiled 👀
                        
                        **Storage Tools**
                        • **Storage Containers**: Good sealing, categorized storage 📦
                        • **Storage Bags**: Clear labels, easy to check 🛍️
                        • **Vacuum Bags**: Extended storage time 💨
                        • **Fridge Organization**: Proper use of refrigerator/freezer space ❄️
                        
                        💡 **Storage Secret:** Buy what you can eat, freshness is key, organize storage systematically!
                        """)
                        
                        ImagePlaceholder(title: "Food Storage")
                        
                        // Cultural Experience: Life Wisdom
                        ArticleSection(title: "Cultural Experience: Chinese Life Wisdom", content: """
                        **Market Culture**
                        • **Personal Touch**: Vendors and customers like friends 👥
                        • **Bargaining**: Not just saving money, but social interaction 💬
                        • **Neighborhood Relations**: Building community through shopping 🏘️
                        • **Life Rhythm**: Experience Chinese daily life pace ⏰
                        
                        **Food Philosophy**
                        • **Seasonal Eating**: Follow nature, eat seasonal ingredients 🌱
                        • **Food as Medicine**: Food is medicine, nourishing body 💊
                        • **Nutritional Balance**: Balance meat/vegetables, hot/cold, colors 🌈
                        • **Frugal Virtue**: No waste, clean plate campaign ♻️
                        
                        **Regional Differences**
                        • **North-South**: South refined, North hearty 🗺️
                        • **Taste Preferences**: South sweet, North salty, East sour, West spicy 👅
                        • **Ingredient Features**: Coastal seafood, inland river fish 🌊
                        • **Cooking Methods**: Stir-fry, steam, boil, stew each unique 👨‍🍳
                        
                        **Modern Changes**
                        • **Online Shopping**: Young people prefer fresh food delivery 📱
                        • **Quality Awareness**: More focus on food safety and nutrition ✅
                        • **Convenience Pursuit**: Growing demand for semi-prepared, cleaned vegetables ⚡
                        • **International Integration**: Imported ingredients increasingly common 🌍
                        
                        **Social Significance**
                        • **Job Creation**: Provides employment opportunities 💼
                        • **Urban Vitality**: Markets represent city's living atmosphere 🔥
                        • **Cultural Heritage**: Maintaining traditional food culture 📿
                        • **Community Building**: Promoting neighborhood harmony 🤝
                        
                        **Shopping Philosophy**
                        • **Buy Appropriately**: Buy what you can eat, avoid waste ⚖️
                        • **Diverse Selection**: Balanced nutrition, eat variety 🍽️
                        • **Seasonal Awareness**: Eat seasonally, follow nature 🌿
                        • **Quality Priority**: Better to buy less but buy good quality ⭐
                        
                        🎊 **Deep Experience:** Start with grocery shopping and cooking to experience real Chinese life!
                        """)
                        
                        ImagePlaceholder(title: "Fresh Food Shopping Cultural Experience")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Fresh Food Shopping Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GroceryShoppingArticleView()
} 