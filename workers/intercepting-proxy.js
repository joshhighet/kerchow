addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
    try {
        await logRequestToSplunk(request)
    } catch (error) {
        console.error('failed transparent prefetch:', error)
    }
    const response = await fetch(request)
    return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: response.headers
    })
}

async function logRequestToSplunk(request) {
    const splunkUrl = SPLUNK_HEC_URL
    const splunkToken = SPLUNK_HEC_TOKEN
    const method = request.method
    const url = request.url
    const targetFQDN = new URL(url).host
    const referrer = request.headers.get('referer')
    const userAgent = request.headers.get('user-agent')
    const cloudflareRayID = request.headers.get('cf-ray')
    const countryISO = request.headers.get('cf-ipcountry')
    const queryString = new URL(url).search
    const body = await request.text()
    const uriPath = new URL(url).pathname
    const ip = request.headers.get('cf-connecting-ip') 
    || request.headers.get('x-forwarded-for') 
    || request.headers.get('x-real-ip')
    const additionalHeaders = {}
    const excludedHeaders = [
        'referer', 
        'user-agent', 
        'cf-ray', 
        'cf-connecting-ip', 
        'x-forwarded-for', 
        'x-real-ip', 
        'cf-ipcountry', 
        'cf-visitor', 
        'x-forwarded-proto', 
        'host'
    ]    
    for (let pair of request.headers.entries()) {
        if (!excludedHeaders.includes(pair[0])) {
            additionalHeaders[pair[0]] = pair[1]
        }
    }
    const event = {
        time: Date.now(),
        host: targetFQDN,
        source: 'logd-worker',
        event: {
            http_method: method,
            url: url,
            http_referrer: referrer,
            http_user_agent: userAgent,
            cf_rayID: cloudflareRayID,
            uri_query: queryString,
            body: body,
            src: ip,
            headers: additionalHeaders,
            country: countryISO,
            url_domain: targetFQDN,
            url_length: url.length,
            uri_path: uriPath
        }
    };
    await fetch(splunkUrl, {
        method: 'POST',
        headers: {
            'Authorization': `Splunk ${splunkToken}`,
            'Content-Type': 'application/json',
            'CF-Access-Client-Id': CF_CLIENTID,
            'CF-Access-Client-Secret': CF_SECRET
        },
        body: JSON.stringify(event)
    })
}