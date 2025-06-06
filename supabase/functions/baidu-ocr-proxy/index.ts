import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const BAIDU_API_KEY = Deno.env.get('BAIDU_API_KEY')
const BAIDU_SECRET_KEY = Deno.env.get('BAIDU_SECRET_KEY')
const BAIDU_TOKEN_URL = 'https://aip.baidubce.com/oauth/2.0/token'
const BAIDU_OCR_URL = 'https://aip.baidubce.com/rest/2.0/ocr/v1'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-bundle-id',
  'Access-Control-Allow-Methods': 'POST, OPTIONS'
}

interface OCRRequest {
  imageData: string
  useAccurate: boolean
  needTranslation: boolean
  targetLanguage: string
}

declare global {
  interface DenoNamespace {
    env: {
      get(key: string): string | undefined
    }
  }
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    if (!BAIDU_API_KEY || !BAIDU_SECRET_KEY) {
      throw new Error('BAIDU_API_KEY or BAIDU_SECRET_KEY environment variable is not set')
    }

    // Verify the request is from our iOS app
    const bundleId = req.headers.get('x-bundle-id')
    if (bundleId !== 'com.rantao.ChinaGo') {
      return new Response(
        JSON.stringify({ error: 'Unauthorized request' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get request body
    const { imageData, useAccurate, needTranslation = false, targetLanguage = 'ENG' } = await req.json() as OCRRequest
    if (!imageData) {
      throw new Error('Missing image data')
    }

    // Get access token
    const tokenResponse = await fetch(
      `${BAIDU_TOKEN_URL}?grant_type=client_credentials&client_id=${BAIDU_API_KEY}&client_secret=${BAIDU_SECRET_KEY}`,
      { method: 'POST' }
    )
    
    if (!tokenResponse.ok) {
      throw new Error(`Failed to get Baidu access token: ${tokenResponse.status}`)
    }
    
    const tokenData = await tokenResponse.json()
    const accessToken = tokenData.access_token
    
    if (!accessToken) {
      throw new Error('Failed to obtain Baidu access token')
    }

    // 使用包含位置信息的接口 - 将 'basic' 改为带位置信息的接口
    const endpoint = useAccurate ? 'accurate' : 'general'
    const ocrUrl = `${BAIDU_OCR_URL}/${endpoint}?access_token=${accessToken}`

    // Make OCR request with translation parameters
    const ocrResponse = await fetch(ocrUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: new URLSearchParams({
        image: imageData
      }).toString()
    })

    const ocrData = await ocrResponse.json()

    return new Response(
      JSON.stringify(ocrData),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Baidu OCR Proxy Error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
}) 