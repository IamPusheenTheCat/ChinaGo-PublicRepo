//
//  TravelPhotographyArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct TravelPhotographyArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.orange, .orange.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Photography Guide")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        ArticleSection(
                            title: "📸 Photography Hotspots in China",
                            content: """
                            China has numerous world-class photography destinations, each with unique photographic charm.

                            **Natural Landscapes:**
                            • Zhangjiajie: Strange peaks and rocks, clouds and mist
                            • Jiuzhaigou: Colorful lakes, waterfall clusters
                            • Guilin Landscape: Karst terrain, picturesque scenery
                            • Huangshan: Unique pines and strange rocks, sea of clouds and sunrise
                            • Daocheng Yading: Plateau scenery, snow mountains and grasslands

                            **Ancient Architecture:**
                            • Forbidden City: Red walls and yellow tiles, imperial architecture
                            • Great Wall: Winding for thousands of miles, magnificent and spectacular
                            • Temple of Heaven: Circular buildings, symmetrical aesthetics
                            • Suzhou Gardens: Jiangnan water towns, exquisite and elegant
                            • Potala Palace: Snowy plateau, sacred and solemn

                            **Modern Cities:**
                            • Shanghai Bund: Skyscrapers, Huangpu River night view
                            • Shenzhen Qianhai: Modern architectural complex
                            • Chongqing Hongyadong: Mountain city night view, rich layers
                            • Guangzhou Canton Tower: Iconic architecture
                            """
                        )
                        
                        ImagePlaceholder(title: "Photography Hotspots in China")
                        
                        ArticleSection(
                            title: "📱 Photography Tips to Share",
                            content: """
                            Master basic photography techniques to capture perfect memories of your China journey.

                            **Composition Techniques:**
                            • Rule of thirds: Place the subject at the intersection of the grid
                            • Symmetrical composition: Look for symmetrical elements like architectural reflections
                            • Leading lines: Use roads, rivers, etc. to guide the eye
                            • Foreground, middle, and background: Create layers and depth

                            **Light Usage:**
                            • Golden hour: 1 hour before and after sunrise/sunset
                            • Blue hour: 20-30 minutes after sunset
                            • Side lighting: Highlight three-dimensionality and texture
                            • Avoid noon direct sunlight: Harsh light affects results

                            **Portrait Photography:**
                            • Background selection: Simple and uncluttered
                            • Catchlight: Ensure eyes have sparkle
                            • Natural poses: Avoid stiff poses
                            • Burst mode: Capture natural expressions

                            **💡 Practical Tips:**
                            • Use your phone's HDR mode
                            • Use night mode for nighttime scenes
                            • Portrait mode for blur effects
                            • Panorama mode for wide scenes
                            """
                        )

                        ImagePlaceholder(title: "Photography Tips to Share")
                        
                        ArticleSection(
                            title: "📍 Popular Check-in Spots",
                            content: """
                            Explore China's most popular check-in locations and capture viral social media photos.

                            **Beijing Hotspots:**
                            • Forbidden City Corner Tower: Classic red walls with snow
                            • Shichahai: Hutong atmosphere, old Beijing charm
                            • 798 Art District: Industrial style combined with art
                            • Yonghe Temple: Tibetan Buddhist architecture

                            **Shanghai Hotspots:**
                            • The Bund: International architecture exhibition
                            • Tianzifang: Shikumen lane culture
                            • Xintiandi: Shanghai style culture meets modernity
                            • Yu Garden: Classical gardens, Chinese architecture

                            **Characteristic Towns:**
                            • Wuzhen: Jiangnan water town, small bridges and flowing water
                            • Lijiang Old Town: Naxi culture, ancient architecture
                            • Fenghuang Ancient Town: Stilted buildings, Miao ethnic customs
                            • Pingyao Ancient City: Ming and Qing ancient buildings, bank culture

                            **Modern Landmarks:**
                            • Canton Tower: Waist-shaped night view
                            • Chengdu IFS: Panda sculpture
                            • Xi'an Giant Wild Goose Pagoda: Ancient capital new appearance
                            • Hangzhou West Lake: Broken Bridge with snow, Leifeng Pagoda at sunset
                            """
                        )
                        
                        ImagePlaceholder(title: "Popular Check-in Spots")
                        
                        ArticleSection(
                            title: "⚠️ Photography Precautions",
                            content: """
                            Understand photography regulations and taboos to be a civilized photographer.

                            **Photography Restricted Areas:**
                            • Military facilities: Strictly prohibited
                            • Museum artifacts: Some exhibits prohibit photography
                            • Religious sites: Respect religious regulations
                            • Government buildings: Sensitive areas prohibited
                            • Subway security: Safety considerations

                            **Portrait Photography Etiquette:**
                            • Get consent: Permission needed to photograph others
                            • Respect privacy: Avoid candid shots
                            • Children photography: Must get parental consent
                            • Ethnic costumes: Respect local culture

                            **Cultural Relics Regulations:**
                            • No flash: Protect artifacts
                            • Keep distance: Don't touch artifacts
                            • Follow instructions: Visit according to designated routes
                            • Silent shooting: Avoid disturbing others

                            **⚠️ Legal Reminders:**
                            • Don't spread illegal content
                            • Respect portrait rights and copyrights
                            • Commercial photography requires permits
                            • Protect personal privacy information
                            """
                        )

                        ImagePlaceholder(title: "Photography Precautions")
                        
                        ArticleSection(
                            title: "🎨 Post-processing Suggestions",
                            content: """
                            Learn basic post-processing to make your photos more outstanding.

                            **Mobile Photo Editing Apps:**
                            • VSCO: Film texture filters
                            • Snapseed: Google product, comprehensive features
                            • Meitu: Professional portrait beautification
                            • Lightroom Mobile: Professional color grading
                            • Butter Camera: Text addition and layout

                            **Basic Adjustments:**
                            • Exposure adjustment: Make photos moderately bright and dark
                            • Contrast: Enhance photo layers
                            • Saturation: Make colors more vivid
                            • Sharpening: Improve photo clarity
                            • Cropping: Improve composition ratio

                            **Style Color Grading:**
                            • Chinese classical: Warm tones, reduced saturation
                            • Modern urban: Increased contrast, cool tones
                            • Natural landscapes: Enhance greens and blues
                            • Portrait photos: Soft light, warm tones

                            **🌟 Creative Techniques:**
                            • Add Chinese fonts to enhance cultural feel
                            • Create nine-grid collages to showcase itinerary
                            • Use double exposure for artistic effects
                            • Black and white processing to highlight architectural lines
                            """
                        )

                        ImagePlaceholder(title: "Post-processing Suggestions")
                        
                        ArticleSection(
                            title: "🏮 Chinese Photography Culture",
                            content: """
                            Understand China's unique photography culture and aesthetic concepts to enhance photography taste.

                            **Traditional Aesthetics:**
                            • Impressionistic style: Focus on spirit over form
                            • Blank space art: Leave imagination space in the frame
                            • Symmetrical beauty: Reflect Chinese architectural features
                            • Mood creation: Express emotions through environment

                            **Color Culture:**
                            • Chinese red: Symbol of celebration and auspiciousness
                            • Imperial yellow: Representative of nobility and authority
                            • Blue and white: Elegant and profound beauty
                            • Jade green: Embodiment of vitality and harmony

                            **Composition Aesthetics:**
                            • Golden ratio: Proportions that conform to Chinese aesthetics
                            • Virtual and real combination: Balance between real scenes and blank space
                            • Progressive layers: Sense of layers in foreground, middle, and background
                            • Dynamic and static harmony: Harmony between movement and stillness

                            **Seasonal Features:**
                            • Spring: Cherry blossoms, rapeseed flowers, Jiangnan spring rain
                            • Summer: Lotus flowers, bamboo forests, cool mountains and waters
                            • Autumn: Red leaves, ginkgo, harvest scenes
                            • Winter: Snow scenes, plum blossoms, ink painting mood

                            **🎨 Aesthetic Suggestions:**
                            • Learn composition from traditional Chinese painting
                            • Feel the aesthetic mood in poetry
                            • Understand the spatial aesthetics of Chinese gardens
                            • Experience the color matching of traditional festivals
                            """
                        )
                        
                        ImagePlaceholder(title: "Chinese Photography Culture")
                        
                        ArticleSection(
                            title: "📷 Equipment and Gear Recommendations",
                            content: """
                            Choose appropriate photography equipment to enhance photography effects.

                            **Mobile Photography:**
                            • **iPhone Series**: Good color reproduction, easy operation
                            • **Huawei P/Mate Series**: Excellent night photography
                            • **Xiaomi Series**: High cost-performance, comprehensive features
                            • **OPPO/vivo**: Excellent portrait photography

                            **Camera Selection:**
                            • **Entry-level DSLR**: Canon EOS, Nikon D series
                            • **Mirrorless cameras**: Sony A series, Fuji X series
                            • **Compact cameras**: Ricoh GR, Fuji X100 series
                            • **Action cameras**: GoPro, DJI Action series

                            **Essential Accessories:**
                            • **Tripod**: Stable shooting, essential for long exposure
                            • **Power bank**: Ensure sufficient device battery
                            • **Memory cards**: High-speed cards for burst shooting and video
                            • **Cleaning supplies**: Lens paper, cleaning solution

                            **Special Environment Equipment:**
                            • **Rain cover**: Protect equipment when shooting in rain
                            • **UV filter**: Protect lens, reduce ultraviolet rays
                            • **Polarizing filter**: Eliminate reflections, enhance colors
                            • **Neutral density filter**: Long exposure for flowing water shots

                            **💡 Equipment Suggestions:**
                            • Choose equipment weight based on travel method
                            • Backup batteries and memory cards are important
                            • Understand basic equipment operation
                            • Consider equipment insurance and protection
                            """
                        )
                        
                        ImagePlaceholder(title: "Equipment and Gear Recommendations")
                        
                        ArticleSection(
                            title: "🌟 Photography Creation Techniques",
                            content: """
                            Improve photography creation skills and capture more artistic works.

                            **Creative Composition:**
                            • **Frame composition**: Use doors, windows, arches as foreground
                            • **Reflection composition**: Use water surfaces, mirror reflections
                            • **Silhouette shooting**: Backlit figure outlines
                            • **Texture quality**: Highlight material texture beauty

                            **Color Usage:**
                            • **Monochrome**: Create unified visual effects
                            • **Complementary colors**: Strong contrast of red-green, blue-orange
                            • **Gradient colors**: Natural gradients in sky and water
                            • **Selective color**: Local color in black and white photos

                            **Light and Shadow Expression:**
                            • **Shadow casting**: Use shadows to add layers
                            • **Light penetration**: Light through leaves and buildings
                            • **Rim lighting**: Light outlining the subject's edges
                            • **Dramatic lighting**: Strong light and dark contrasts

                            **Dynamic Expression:**
                            • **Slow shutter**: Dynamic effects of flowing water and clouds
                            • **Panning technique**: Highlight moving subjects
                            • **Freeze moment**: Capture exciting moments
                            • **Continuous action**: Multiple photos showing process

                            **🎭 Creative Suggestions:**
                            • Observe beautiful moments in life more
                            • Try different shooting angles
                            • Develop unique photography style
                            • Communicate and learn with other photographers
                            """
                        )
                        
                        ImagePlaceholder(title: "Photography Creation Techniques")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Travel Photography Guide")
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
    TravelPhotographyArticleView()
} 