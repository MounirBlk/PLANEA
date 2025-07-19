'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "08358efb6b1a833471ed06a2c13a60f3",
"assets/assets/images/portal.png": "f2f64637dda305f0f4a8eab4b3a1f52a",
"assets/assets/images/trophies/trophy2.svg": "8d1534822682f0446c9d07e4f67b566a",
"assets/assets/images/trophies/trophy3.svg": "eda4dbf380c068696935a13d6b686225",
"assets/assets/images/trophies/trophy1.svg": "1cda26afacc40835982162ffd5c63feb",
"assets/assets/images/planea.svg": "9ddce3ffed2a02abf0a792ed82135054",
"assets/assets/images/background/layer1-sky.png": "a11d7a7438f401ca5160f51f5c5badbf",
"assets/assets/images/background/layer4-clouds.png": "2b5a59fc5807fb764e4c6f34192b8e31",
"assets/assets/images/background/parallax%2520backgound%2520pack.zip": "a6f2123e11aeb5a2f550995ca23a8377",
"assets/assets/images/background/layer5-huge-clouds.png": "4b6724dab35bac39330b592e0483b365",
"assets/assets/images/background/clouds/clouds_background1_1/3.png": "851ed1fe6853fa78641116abcd759073",
"assets/assets/images/background/clouds/clouds_background1_1/2.png": "db041793252fb5019bc8f0e809c9a228",
"assets/assets/images/background/clouds/clouds_background1_1/1.png": "5820e23d74d79cb1295941312334928a",
"assets/assets/images/background/clouds/clouds_background1_1/orig_big.png": "6b4b5723a17ba87a4f3cc4a6722826bd",
"assets/assets/images/background/clouds/clouds_background1_1/orig.png": "d445cb029a493943aa8c8390bfd98d4d",
"assets/assets/images/background/clouds/clouds_background1_1/4.png": "55906b2072b2b10ef7aa76c3ee458bb8",
"assets/assets/images/background/clouds/clouds_background2_3/3.png": "28da27859f3efd7ebb73d26433ed99dd",
"assets/assets/images/background/clouds/clouds_background2_3/2.png": "18b3e55146f0e7009060fd4b2bd90349",
"assets/assets/images/background/clouds/clouds_background2_3/1.png": "c3013b84b230cb361ee871fcc13bd4f8",
"assets/assets/images/background/clouds/clouds_background2_3/orig_big.png": "a3db82eb14745905c085f10c190b8678",
"assets/assets/images/background/clouds/clouds_background2_3/orig.png": "3eefef3e707e64bf2302330cfddafc04",
"assets/assets/images/background/clouds/clouds_background2_3/4.png": "2d3577036bb7fdb8e694e1384ca5de79",
"assets/assets/images/background/clouds/clouds_background2_2/3.png": "fbc8bee2d88d548d6689165b9296d711",
"assets/assets/images/background/clouds/clouds_background2_2/2.png": "8d9e9405b88762edce18c9a765470c34",
"assets/assets/images/background/clouds/clouds_background2_2/1.png": "5942dc40fab6279176989a8eb1fd333d",
"assets/assets/images/background/clouds/clouds_background2_2/orig_big.png": "e696b2c2e471dee67b040cb9cc8c8911",
"assets/assets/images/background/clouds/clouds_background2_2/orig.png": "5538e1d47effdda1c369a286d58cf28d",
"assets/assets/images/background/clouds/clouds_background2_2/5.png": "64c5026114a6d9a1c58aa7c0e46e37e2",
"assets/assets/images/background/clouds/clouds_background2_2/4.png": "f7f23d8c6b19768b507614c597d96b0b",
"assets/assets/images/background/clouds/clouds_background1_2/3.png": "548b6b6ef9222d7e21b97d1298426e90",
"assets/assets/images/background/clouds/clouds_background1_2/2.png": "1a51fcd2eeedd8b4d60668e336fd021f",
"assets/assets/images/background/clouds/clouds_background1_2/1.png": "8042246165860ed9a8e23d65a491f3c8",
"assets/assets/images/background/clouds/clouds_background1_2/orig_big.png": "5a14360b5f342a41921aa01b1e808463",
"assets/assets/images/background/clouds/clouds_background1_2/orig.png": "4a14a447c06db08c72d9d9de7ad92d0f",
"assets/assets/images/background/clouds/clouds_background1_2/5.png": "c1eacb4c9af4d67fedb6984e336ee4c2",
"assets/assets/images/background/clouds/clouds_background1_2/4.png": "29fa1d30f26c17b457ef929288654c8a",
"assets/assets/images/background/layer2-clouds.png": "27824b3fc4099e68b1999c4399fd76f8",
"assets/assets/images/background/parallax%2520saturated%2520background%2520pack.zip": "3d858fe15932a13b6d51446b071973ce",
"assets/assets/images/background/layer3-clouds.png": "c10ca64d4f2023bdd92570fe1ebc7e21",
"assets/assets/images/background/layer7-bushes.png": "4a53ec7605f19a6fb177d8b9b1ee0ffb",
"assets/assets/images/background/layer6-bushes.png": "901377f0826d264105f2707bb1c3367c",
"assets/assets/images/planeas/sky_planea.svg": "cc8de1d6d476b06c097cc00925369e2c",
"assets/assets/images/planeas/violet_planea.png": "82378d302cca033083e58bc7ae456b7f",
"assets/assets/images/planeas/rose_planea.svg": "ed5d217e8f4a6ca01d373b40a9ba9bc5",
"assets/assets/images/planeas/sand_planea.svg": "fb8d4480168cdd19bebb09d16753e20e",
"assets/assets/images/planeas/flutter_planea.svg": "9ddce3ffed2a02abf0a792ed82135054",
"assets/assets/images/planeas/lime_planea.png": "92b67d94298e414f36cecdfb34adca2e",
"assets/assets/images/planeas/flutter_planea.png": "72b9fdf7bf5562b08c106f1ceaee68aa",
"assets/assets/images/planeas/sunny_planea.png": "24fbac84d2add52a6e5fd955c06b9a50",
"assets/assets/images/planeas/rose_planea.png": "670c447e2ebc016581b70975050c5b92",
"assets/assets/images/planeas/violet_planea.svg": "5931b89a446e9d033bbf7f22099c9da3",
"assets/assets/images/planeas/scarlet_planea.svg": "3aef89da948511af4da90a331958f534",
"assets/assets/images/planeas/sand_planea.png": "646c3e70c5fa60f6803ba2022696803d",
"assets/assets/images/planeas/peachy_planea.svg": "fa80e0493be7fc1107eaf0712b7f5ecc",
"assets/assets/images/planeas/lime_planea.svg": "95a754cb57d669ec19d5eab126fded22",
"assets/assets/images/planeas/peachy_planea.png": "79d02fdd1f456bdc0c7e8f8d1d6bb10d",
"assets/assets/images/planeas/sunny_planea.svg": "8c4dab3d92651f0a92200b5830c17100",
"assets/assets/images/planeas/sky_planea.png": "b902cd9f51181d497c0e49d0e4e2c7e2",
"assets/assets/images/planeas/minty_planea.svg": "19c48cf6876cd4dda449ac2a1eef0209",
"assets/assets/images/planeas/scarlet_planea.png": "d5c3aecd235fb7e4f7b88e94b16052f1",
"assets/assets/images/planeas/minty_planea.png": "c150dce7ee4d6bf603f28a43e2724c72",
"assets/assets/images/planea.png": "56931f95d9062ce735dc0d92f8e03428",
"assets/assets/images/pipe.png": "ccbadae55474e53cc16f5268f3a809d5",
"assets/assets/images/multi_planea.svg": "0693839b246c67c0d389f525e2135a34",
"assets/assets/images/logo.png": "276a3da0529b5f057928cfa90ee5a753",
"assets/assets/images/blurred_background.png": "538676c07a0e09523778815af2f76e8a",
"assets/assets/audio/score.mp3": "fd7f3ff3f2c802d1fd238a4378fcb8fb",
"assets/assets/audio/background.mp3": "8cf92b060538044e62ae1b8e40670283",
"assets/assets/fonts/Chewy-Regular.ttf": "53ee0977b5f9f3afc1d18b4419264c8b",
"assets/assets/icons/ic_github.svg": "8dcc6b5262f3b6138b1566b357ba89a9",
"assets/assets/icons/ic_trophy.svg": "70e00ec9619fef0830e74631b86005b2",
"assets/assets/icons/ic_back.svg": "83e40138f06f8163af486505bc9188fc",
"assets/assets/icons/ic_close.svg": "63bda2f6191ad9b92d72e0d6e5fb2ce9",
"assets/assets/icons/ic_profile.svg": "db8773511fbb30df65dde72712699e62",
"assets/assets/icons/ic_qr.svg": "0c949e7ec7cdc32137c784502b458066",
"assets/assets/icons/ic_menu.svg": "ba05c07cf42de65584dfa04b9c6fe66f",
"assets/assets/icons/ic_home.svg": "83a4b484c2766ec3a052d3fa4ed4ada2",
"assets/assets/icons/ic_share.svg": "cb5d32bf25018f759d6cdbc484eeb059",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "b575fc56f51ada19bae272d1e4146bde",
"assets/AssetManifest.json": "5030682efd8717b9b0883e52faa9f55d",
"assets/fonts/MaterialIcons-Regular.otf": "8789d517929de2ae244062911733f660",
"assets/AssetManifest.bin.json": "dbddfec2834e0a4294e5c36f17cbf3c4",
"assets/logo.png": "276a3da0529b5f057928cfa90ee5a753",
"assets/NOTICES": "eb0149df902ce6ac6ecb65a5d0130ef8",
"assets/packages/flutter_soloud/web/init_module.dart.js": "ea0b343660fd4dace81cfdc2910d14e6",
"assets/packages/flutter_soloud/web/worker.dart.js": "2fddc14058b5cc9ad8ba3a15749f9aef",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.js": "4a75ad67ab9c05facbad1d2e80b7692a",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.wasm": "1b4b250f7af5205c361574dbe06d4771",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "6ebc7bc5b74956596611c6774d8beb5b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/share_plus_dialog/lib/fonts/SocialsIcons.ttf": "1c6067ea0aefee73fcbb673eab99c60d",
"version.json": "1537ab1be9c0521932a15f5817a02fd4",
"manifest.json": "f9024f28d0d7710a0fdfeeee746733b7",
"CNAME": "974b7b669b8c7cbb3d6877767d848ebf",
"flutter_bootstrap.js": "3f1caa600048a00d41db3df109d6c7ae",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"index.html": "f6d6cf119decc933adf036316ffc5e06",
"/": "f6d6cf119decc933adf036316ffc5e06",
"favicon.png": "cb36c7f9077eb3358b6dc8a6239b5685",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"icons/Icon-512.png": "b9ee0af6358d9ee032b9de65c831da46",
"icons/Icon-192.png": "7e19c3f935c05a4e6cdb056a3a0c3443",
"icons/Icon-maskable-512.png": "b9ee0af6358d9ee032b9de65c831da46",
"icons/Icon-maskable-192.png": "7e19c3f935c05a4e6cdb056a3a0c3443",
"main.dart.js": "0c17c68632c63a37e3d7559b408a68ba"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
