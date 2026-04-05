if (!window._flutter) {
    window._flutter = {};
}
_flutter.loader = null;

(function() {
    "use strict";
    const baseUri = ensureTrailingSlash(getBaseURI());

    function getBaseURI() {
        const base = document.querySelector('base');
        return (base && base.getAttribute('href')) || '';
    }

    function ensureTrailingSlash(uri) {
        if (uri == '') return uri;
        return uri.endsWith('/') ? uri : uri + '/';
    }

    function loadMainDartJs() {
        return loadScript(baseUri + 'main.dart.js');
    }

    function loadScript(src) {
        return new Promise(function(resolve, reject) {
            const script = document.createElement('script');
            script.src = src;
            script.defer = true;
            script.onload = resolve;
            script.onerror = reject;
            document.head.appendChild(script);
        });
    }

    async function main() {
        if (typeof _flutter != "undefined") {
            _flutter.loader = {
                loadEntrypoint: async function(options) {
                    const { entrypointUrl = baseUri + 'main.dart.js' } = options || {};
                    return loadScript(entrypointUrl);
                }
            };
        }
    }

    main();
})();