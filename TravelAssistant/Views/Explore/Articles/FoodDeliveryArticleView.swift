//
//  FoodDeliveryArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct FoodDeliveryArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Food Delivery in China")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 痛点解决：平台选择
                        ArticleSection(title: "Platform Selection: Which One Suits You Best?", content: """
                        **Why is Food Delivery So Important?**
                        China has the world's most developed food delivery industry! 40 million orders daily, 30-minute delivery, cheaper than cooking at home.
                        
                        **Meituan (Recommended for Beginners)**
                        • **Widest Coverage**: Available in 99% of cities, most restaurants 🏪
                        • **Fastest Delivery**: Average 25-35 minutes, slightly longer during peak hours 🚀
                        • **Most Discounts**: New user coupons, bulk discounts, red packet rain 💰
                        • **Convenient Payment**: WeChat, Alipay, bank cards all supported 💳
                        
                        **Ele.me (Alibaba's Platform)**
                        • **Quality Assurance**: Star-rated merchants, more reliable quality ⭐
                        • **Member Benefits**: Exclusive discounts for 88VIP users 👑
                        • **Alipay Points**: Can use points to offset payment 💎
                        • **Contactless Delivery**: Safer during pandemic times 🛡️
                        
                        **Other Platforms**
                        • **JD Daojia**: Specialized in grocery and supermarket delivery 🛒
                        • **Hema Fresh**: 30-minute fresh food delivery 🐟
                        • **Pupu Market**: Featured platform in Fujian region 📍
                        
                        💡 **Beginner's Tip:** Start with Meituan for more choices, then try Ele.me to compare prices!
                        """)
                        
                        ImagePlaceholder(title: "外卖平台对比")
                        
                        // 下单流程：避免出错
                        ArticleSection(title: "下单攻略：从新手到高手", content: """
                        **注册准备**
                        • **手机号码**：中国手机号（必须，可找朋友代收验证码）📱
                        • **收货地址**：详细到门牌号、楼层、房间号 🏠
                        • **支付方式**：微信/支付宝最方便 💳
                        
                        **选择商家技巧**
                        • **看评分**：4.5分以上比较可靠 ⭐
                        • **看距离**：2公里内配送更快 📍
                        • **看销量**：月销1000+说明受欢迎 📊
                        • **看评价**：重点看差评内容，避开雷区 👀
                        
                        **点餐实用技巧**
                        • **看图片**：实物与图片差距大的要小心 📸
                        • **看配料**：确认是否有不喜欢的食材 🥬
                        • **选套餐**：比单点更划算 💰
                        • **加备注**：不要香菜、少盐、多辣等个人需求 📝
                        
                        **支付前检查**
                        • **确认地址**：是否正确详细 ✅
                        • **确认电话**：保持畅通 📞
                        • **使用优惠**：满减券、红包、积分 🎁
                        • **选择餐具**：环保考虑，按需选择 🥢
                        
                        ⚠️ **新手避坑：** 第一次用建议选择评分高、距离近的大品牌商家！
                        """)
                        
                        ImagePlaceholder(title: "外卖下单流程")
                        
                        // 美食推荐：必试菜品
                        ArticleSection(title: "必试美食：外国人最爱", content: """
                        **新手友好（不太辣）**
                        • **黄焖鸡米饭**：鸡肉软烂，汤汁拌饭超香 🍚
                        • **兰州拉面**：清汤牛肉面，暖胃又饱腹 🍜
                        • **蒸蛋羹**：嫩滑如豆腐，老少皆宜 🥚
                        • **白切鸡饭**：清淡鲜美的广东风味 🐔
                        
                        **进阶尝试（微辣）**
                        • **宫保鸡丁**：酸甜微辣，下饭神器 🍗
                        • **糖醋里脊**：酸甜可口，外国人最爱 🍖
                        • **麻婆豆腐**：经典川菜，麻辣鲜香 🌶️
                        • **红烧肉**：软糯香甜，中式经典 🥩
                        
                        **挑战级别（重口味）**
                        • **麻辣烫**：可自选配菜，体验中式小火锅 🍲
                        • **水煮鱼**：麻辣鲜香，川菜代表 🐟
                        • **口水鸡**：凉菜，麻辣爽口 🐓
                        • **四川冒菜**：一人食的火锅体验 🔥
                        
                        **小吃甜品**
                        • **煎饼果子**：北方特色早餐 🥞
                        • **肉夹馍**：中式汉堡 🥪
                        • **珍珠奶茶**：台式经典饮品 🧋
                        • **港式甜品**：双皮奶、芒果班戟 🍮
                        
                        🎯 **点餐建议：** 第一次建议点套餐，有荤有素营养均衡，价格也划算！
                        """)
                        
                        ImagePlaceholder(title: "外卖美食推荐")
                        
                        // 价格指南：花钱有数
                        ArticleSection(title: "价格攻略：吃得好又不贵", content: """
                        **价格区间参考**
                        
                        **经济实惠（15-25元）**
                        • **快餐盖浇饭**：12-18元，够一顿 🍱
                        • **面条类**：8-15元，管饱又暖胃 🍜
                        • **包子馒头**：5-10元，早餐首选 🥟
                        • **适合人群**：学生、预算有限 👥
                        
                        **中档享受（25-40元）**
                        • **精品套餐**：20-30元，荤素搭配 🍽️
                        • **特色菜系**：25-35元，体验地方风味 🌶️
                        • **奶茶甜品**：15-25元，下午茶时光 🧋
                        • **适合人群**：上班族日常 💼
                        
                        **高档体验（40元以上）**
                        • **品牌连锁**：35-50元，品质保证 🏪
                        • **日韩料理**：45-60元，异国风味 🍣
                        • **五星酒店外卖**：80-150元，奢华享受 👑
                        
                        **省钱秘籍**
                        • **新用户优惠**：首单立减10-30元 🎁
                        • **满减活动**：满30减5，满50减10等 💸
                        • **会员免配送费**：经常点的话很划算 📦
                        • **避开高峰期**：11:30-12:30，18:00-19:00价格稍贵 🕐
                        • **拼单技巧**：和朋友同事一起点，凑满减 👥
                        
                        💰 **省钱tip：** 关注平台红包雨时间，通常在饭点前半小时！
                        """)
                        
                        ImagePlaceholder(title: "外卖价格策略")
                        
                        // 配送文化：理解骑手
                        ArticleSection(title: "配送文化：尊重每一份辛苦", content: """
                        **配送时间了解**
                        • **正常时段**：25-35分钟 ⏰
                        • **高峰期**：45-60分钟（11:30-12:30，17:30-19:30）🕐
                        • **恶劣天气**：延长15-30分钟 🌧️
                        • **节假日**：延长20-40分钟 🎊
                        
                        **与骑手互动礼仪**
                        • **耐心等待**：理解交通状况，不频繁催促 🚫
                        • **保持联系**：接听电话，骑手找不到路时 📞
                        • **准确地址**：详细到楼栋、楼层、门牌号 🏢
                        • **及时取餐**：骑手到达后尽快下楼取餐 🏃
                        
                        **特殊情况处理**
                        • **送错地址**：联系客服，不要为难骑手 🚫
                        • **餐品有问题**：先确认是商家还是配送问题 🔍
                        • **天气恶劣**：考虑给小费表示感谢 💝
                        • **夜间配送**：开门灯，方便骑手找到 💡
                        
                        **小费文化**
                        • **雨雪天气**：1-5元表示感谢 ❄️
                        • **深夜配送**：2-5元辛苦费 🌙
                        • **高楼层无电梯**：1-3元爬楼费 🏗️
                        • **不是必须**：是一种感谢方式，看个人意愿 💖
                        
                        **为什么要这样？**
                        外卖骑手是城市中最辛苦的群体之一，理解和尊重让这个服务更可持续。
                        """)
                        
                        ImagePlaceholder(title: "外卖配送文化")
                        
                        // 安全与卫生：健康第一
                        ArticleSection(title: "安全卫生：吃得放心", content: """
                        **选择可靠商家**
                        • **证照齐全**：营业执照、食品经营许可证 📜
                        • **评分较高**：4.5分以上相对可靠 ⭐
                        • **销量稳定**：月销量1000+说明口碑好 📈
                        • **品牌连锁**：标准化管理更安全 🏪
                        
                        **外卖到达后检查**
                        • **包装完整**：封条无破损，包装密封良好 📦
                        • **温度适宜**：热菜要热，冷饮要冷 🌡️
                        • **外观正常**：颜色、气味、形状无异常 👀
                        • **数量核对**：对照订单检查菜品数量 📋
                        
                        **食品安全tips**
                        • **尽快食用**：外卖到达后1小时内食用最佳 ⏱️
                        • **注意保存**：吃不完的放冰箱，隔夜要加热 ❄️
                        • **特殊人群**：孕妇、老人、小孩选择温和口味 👶
                        • **过敏注意**：提前备注过敏食材 ⚠️
                        
                        **遇到问题怎么办**
                        • **食品有问题**：拍照保留证据，联系客服 📸
                        • **食物中毒**：立即就医，保留剩余食品 🏥
                        • **退款申请**：在APP内申请，说明具体问题 💸
                        • **投诉举报**：严重问题可投诉到食药监部门 📞
                        
                        🛡️ **安全原则：** 宁可多花点钱选择可靠商家，也不要为了便宜冒险！
                        """)
                        
                        ImagePlaceholder(title: "外卖安全指南")
                        
                        // 文化体验：深度了解
                        ArticleSection(title: "文化体验：感受中国生活", content: """
                        **外卖背后的中国生活**
                        
                        **社会价值**
                        • **就业机会**：为500万人提供工作机会 👥
                        • **时间节约**：解放厨房，让生活更高效 ⏰
                        • **多元选择**：让偏远地区也能享受各地美食 🌍
                        • **疫情保障**：特殊时期的生活保障线 🛡️
                        
                        **数字化生活体验**
                        • **一站式服务**：点餐、支付、配送全程数字化 📱
                        • **个性化推荐**：AI算法推荐符合口味的美食 🤖
                        • **实时追踪**：知道骑手在哪里，心里有数 📍
                        • **评价系统**：互相评价，共同维护服务质量 ⭐
                        
                        **地域文化差异**
                        • **口味偏好**：南甜北咸东辣西酸 🌶️
                        • **用餐时间**：南方晚于北方，西部晚于东部 🕐
                        • **节日特色**：春节、中秋等节日有特色食品 🎊
                        • **季节变化**：夏天凉菜多，冬天热汤受欢迎 ❄️
                        
                        **融入本地生活**
                        • **尝试本地特色**：每到一个城市试试当地名菜 🍜
                        • **学会评价**：客观评价帮助其他用户 📝
                        • **理解差异**：接受与家乡不同的口味 🌏
                        • **文化交流**：通过美食了解中国文化 🥢
                        
                        **环保责任**
                        • **减少餐具**：不需要的餐具选择"无需餐具" ♻️
                        • **打包盒回收**：清洗后可回收利用 📦
                        • **适量点餐**：避免浪费食物 🍽️
                        • **选择环保商家**：支持使用环保包装的商家 🌱
                        
                        🌟 **深度体验：** 外卖不只是吃饭，更是体验中国数字化生活的窗口！
                        """)
                        
                        ImagePlaceholder(title: "外卖文化体验")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Food Delivery Guide")
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
    FoodDeliveryArticleView()
}

// 文章段落组件
