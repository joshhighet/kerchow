addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
  })
// intended for use with cloudflare workers
// a basic encoded URL redirector
// i.e GET worker-url?url=aHR0cHM6Ly9nb29nbGUuY29tCg==
// should result in a 302 redirect to google.com (the encoded value)
  async function handleRequest(request) {
    const url = new URL(request.url)
    const encodedUrl = url.searchParams.get('url')
    if (!encodedUrl) {
      return Response.redirect('https://longdogechallenge.com', 302)
    }
    const decodedUrl = atob(encodedUrl)
    const redirectUrl = decodedUrl.startsWith('https://') ? decodedUrl : `https://${decodedUrl}`
    return Response.redirect(redirectUrl, 302)
  }
  