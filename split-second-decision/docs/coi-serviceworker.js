/*! coi-serviceworker v0.1.7 | MIT License | © GZGuidoti */
if (typeof window === 'undefined') {
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", event => event.waitUntil(self.clients.claim()));

self.addEventListener("fetch", event => {
if (event.request.cache === "only-if-cached" && event.request.mode !== "same-origin") {
return;
}

event.respondWith(
fetch(event.request)
.then(response => {
if (response.status === 0) {
return response;
}

const newHeaders = new Headers(response.headers);
newHeaders.set("Cross-Origin-Opener-Policy", "same-origin");
newHeaders.set("Cross-Origin-Embedder-Policy", "require-corp");

return new Response(response.body, {
status: response.status,
statusText: response.statusText,
headers: newHeaders,
});
})
.catch(error => console.error(error))
);
});
} else {
(() => {
const script = document.currentScript;
const reloader = () => {
navigator.serviceWorker.register(script.src).then(registration => {
registration.addEventListener("updatefound", () => {
location.reload();
});
if (navigator.serviceWorker.controller) {
// Already controlled
} else {
location.reload();
}
}, error => {
console.error("Service worker registration failed:", error);
});
};

if (window.crossOriginIsolated) {
// Already isolated
} else if (window.isSecureContext) {
if (navigator.serviceWorker) {
reloader();
}
} else {
console.warn("COI Service Worker requires a secure context (HTTPS/localhost)");
}
})();
}
