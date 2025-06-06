import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'

const DEEPSEEK_API_KEY = Deno.env.get('DEEPSEEK_API_KEY')
const DEEPSEEK_API_URL = 'https://api.deepseek.com/chat/completions'

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    if (!DEEPSEEK_API_KEY) {
      throw new Error('DEEPSEEK_API_KEY environment variable is not set')
    }

    // Verify the request is from our iOS app
    const bundleId = req.headers.get('x-bundle-id')
    if (bundleId !== 'com.rantao.ChinaGo') {
      return new Response(
        JSON.stringify({ error: 'Unauthorized request' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Parse the request body to check if streaming is requested
    const requestBody = await req.text()
    const requestData = JSON.parse(requestBody)
    const isStreaming = requestData.stream === true

    // Forward the request to DeepSeek API
    const response = await fetch(DEEPSEEK_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: requestBody
    })

    if (isStreaming) {
      // Handle streaming response
      console.log('🌊 Handling streaming response')
      
      // Set up streaming headers
      const streamHeaders = {
        ...corsHeaders,
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      }

      // Create a readable stream
      const readable = new ReadableStream({
        start(controller) {
          const reader = response.body?.getReader()
          if (!reader) {
            controller.close()
            return
          }

          const pump = async () => {
            try {
              while (true) {
                const { done, value } = await reader.read()
                if (done) {
                  controller.close()
                  break
                }
                
                // Forward the chunk directly
                controller.enqueue(value)
              }
            } catch (error) {
              console.error('Streaming error:', error)
              controller.error(error)
            }
          }

          pump()
        }
      })

      return new Response(readable, { headers: streamHeaders })
    } else {
      // Handle non-streaming response (original behavior)
      const data = await response.json()
      
      return new Response(
        JSON.stringify(data),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

  } catch (error) {
    console.error('Error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})