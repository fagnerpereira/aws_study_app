// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Register service worker for PWA
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
      .then(registration => {
        console.log("ServiceWorker registration successful with scope: ", registration.scope);
      })
      .catch(err => {
        console.log("ServiceWorker registration failed: ", err);
      });
  });
}