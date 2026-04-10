// ============================================================
// HTI Proposal Builder — Service Worker
// ============================================================
// Strategy:
//   - On install: cache the app shell (index.html + CDN scripts)
//   - On fetch: serve from cache first, fall back to network
//   - On activate: clean up old caches from previous versions
//   - Supabase API calls are NOT cached — always fresh from the network
// ============================================================

// Bump this version string whenever you want the browser to force-refresh the cache
const CACHE_VERSION = 'hti-proposal-builder-v1';

// Files to cache on install (the "app shell")
const APP_SHELL = [
  './',
  './index.html',
  'https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2'
];

// Install: pre-cache the app shell
self.addEventListener('install', event => {
  console.log('[SW] Install:', CACHE_VERSION);
  event.waitUntil(
    caches.open(CACHE_VERSION).then(cache => {
      // Use {cache: 'reload'} to bypass browser's own cache for fresh copies
      return Promise.all(
        APP_SHELL.map(url =>
          cache.add(new Request(url, { cache: 'reload' })).catch(err => {
            console.warn('[SW] Failed to cache:', url, err);
          })
        )
      );
    }).then(() => self.skipWaiting())
  );
});

// Activate: clean up old caches + take control immediately
self.addEventListener('activate', event => {
  console.log('[SW] Activate:', CACHE_VERSION);
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_VERSION).map(k => {
        console.log('[SW] Deleting old cache:', k);
        return caches.delete(k);
      })
    )).then(() => self.clients.claim())
  );
});

// Fetch: cache-first for GET requests, network-only for everything else
self.addEventListener('fetch', event => {
  const req = event.request;

  // Only handle GET (no POST/PUT/DELETE caching — those go to the server)
  if (req.method !== 'GET') return;

  const url = new URL(req.url);

  // Never cache Supabase API calls — auth and data must be fresh
  if (url.hostname.includes('supabase.co') || url.hostname.includes('supabase.in')) {
    return; // let the browser handle it normally
  }

  // Never cache chrome-extension://, file://, etc.
  if (!url.protocol.startsWith('http')) return;

  event.respondWith(
    caches.match(req).then(cached => {
      // Return cached response if available
      if (cached) {
        // In the background, try to fetch a fresh copy and update the cache
        // (stale-while-revalidate pattern for CDN scripts)
        fetch(req).then(fresh => {
          if (fresh && fresh.ok && (fresh.type === 'basic' || fresh.type === 'cors')) {
            caches.open(CACHE_VERSION).then(cache => cache.put(req, fresh));
          }
        }).catch(() => {}); // ignore network errors
        return cached;
      }

      // Not in cache — fetch from network and store it for next time
      return fetch(req).then(response => {
        if (response && response.ok && (response.type === 'basic' || response.type === 'cors')) {
          const clone = response.clone();
          caches.open(CACHE_VERSION).then(cache => cache.put(req, clone));
        }
        return response;
      }).catch(() => {
        // Offline and not in cache — fallback to index.html for navigation requests
        if (req.mode === 'navigate') {
          return caches.match('./index.html');
        }
        return new Response('Offline', { status: 503, statusText: 'Offline' });
      });
    })
  );
});

// Allow the page to trigger an update via postMessage
self.addEventListener('message', event => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
