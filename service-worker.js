const cacheName = "some-blog-v1";
const cacheAssets = [
	"./",
	"./index.html",
	"./style.css",
	"./favicon.ico",
	"./manifest.webmanifest",
	"./img/icon-192.png",
	"./img/icon-512.png",
	"./vendor/highlight/highlight.min.js",
	"./vendor/highlight/github.min.css",
	"./fonts/JetBrainsMono-Regular.woff2",
	"./fonts/JetBrainsMono-Bold.woff2"
];

self.addEventListener("install", (e) => {
	e.waitUntil(
		caches
			.open(cacheName)
			.then((cache) => cache.addAll(cacheAssets))
			.then(() => self.skipWaiting())
			.catch((err) => console.error(`Cache error: ${err}`))
	);
});

self.addEventListener("activate", (e) => {
	e.waitUntil(
		caches
			.keys()
			.then((cacheKeys) => {
				return Promise.all(
					cacheKeys.map((cacheKey) => {
						if (cacheKey !== cacheName) return caches.delete(cacheKey);
					})
				);
			})
			.then(() => self.clients.claim())
	);
});

self.addEventListener("fetch", (e) => {
	e.respondWith(
		fetch(e.request)
			.then((response) => {
				const resClone = response.clone();

				if (e.request.url.indexOf("http") === 0)
					caches
						.open(cacheName)
						.then((cache) => cache.put(e.request, resClone));

				return response;
			})
			.catch(() => caches.match(e.request).then((response) => response))
	);
});