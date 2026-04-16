{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.textfox.homeManagerModules.default
    inputs.arkenfox.hmModules.arkenfox
  ];

  programs.firefox = {
    enable = true;
    profiles.elaine = {
      isDefault = true;
        extraConfig = ''
        user_pref("_user.js.parrot", "START: Oh yes, the Norwegian Blue... what's wrong with it?");

        user_pref("browser.aboutConfig.showWarning", false);

        user_pref("_user.js.parrot", "0100 syntax error: the parrot's dead!");
        user_pref("browser.startup.page", 0);
        user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
        user_pref("browser.newtabpage.enabled", false);
        user_pref("browser.newtabpage.activity-stream.showSponsored", false); // [FF58+] Sponsored stories
        user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // [FF83+] Sponsored shortcuts
        user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false); // [FF140+] Support Firefox
        user_pref("browser.newtabpage.activity-stream.default.sites", "");

        user_pref("_user.js.parrot", "0200 syntax error: the parrot's definitely deceased!");
        user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
        user_pref("geo.provider.use_corelocation", false); // [MAC]
        user_pref("geo.provider.use_geoclue", false); // [FF102+] [LINUX]

        user_pref("_user.js.parrot", "0300 syntax error: the parrot's not pinin' for the fjords!");
        user_pref("extensions.getAddons.showPane", false); // [HIDDEN PREF]
        user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
        user_pref("browser.discovery.enabled", false);

        user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
        user_pref("browser.newtabpage.activity-stream.telemetry", false);

        user_pref("app.shield.optoutstudies.enabled", false);
        user_pref("app.normandy.enabled", false);
        user_pref("app.normandy.api_url", "");

        user_pref("breakpad.reportURL", "");
        user_pref("browser.tabs.crashReporting.sendReport", false); // [FF44+]
        user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false); // [DEFAULT: false]

        user_pref("captivedetect.canonicalURL", "");
        user_pref("network.captive-portal-service.enabled", false); // [FF52+]
        user_pref("network.connectivity-service.enabled", false);

        user_pref("_user.js.parrot", "0400 syntax error: the parrot's passed on!");

        user_pref("_user.js.parrot", "0600 syntax error: the parrot's no more!");
        user_pref("network.prefetch-next", false);
        user_pref("network.dns.disablePrefetch", true);
        user_pref("network.dns.disablePrefetchFromHTTPS", true);
        user_pref("network.predictor.enabled", false);
        user_pref("network.predictor.enable-prefetch", false); // [FF48+] [DEFAULT: false]
        user_pref("network.http.speculative-parallel-limit", 0);
        user_pref("browser.places.speculativeConnect.enabled", false);

        user_pref("_user.js.parrot", "0700 syntax error: the parrot's given up the ghost!");
        user_pref("network.proxy.socks_remote_dns", true);
        user_pref("network.file.disable_unc_paths", true); // [HIDDEN PREF]
        user_pref("network.gio.supported-protocols", ""); // [HIDDEN PREF] [DEFAULT: ""]
           // user_pref("network.proxy.allow_bypass", false);

        /*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
        user_pref("_user.js.parrot", "0800 syntax error: the parrot's ceased to be!");
        /* 0801: disable location bar making speculative connections [FF56+]
         * [1] https://bugzilla.mozilla.org/1348275 ***/
        user_pref("browser.urlbar.speculativeConnect.enabled", false);
        /* 0802: disable location bar contextual suggestions
         * [NOTE] The UI is controlled by the .enabled pref
         * [SETTING] Search>Address Bar>Suggestions from...
         * [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/ ***/
        user_pref("browser.urlbar.quicksuggest.enabled", false); // [FF92+]
        user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false); // [FF95+]
        user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false); // [FF92+]
        /* 0803: disable live search suggestions
         * [NOTE] Both must be true for live search to work in the location bar
         * [SETUP-CHROME] Override these if you trust and use a privacy respecting search engine
         * [SETTING] Search>Show search suggestions | Show search suggestions in address bar results ***/
        user_pref("browser.search.suggest.enabled", false);
        user_pref("browser.urlbar.suggest.searches", false);
        /* 0805: disable urlbar trending search suggestions [FF118+]
         * [SETTING] Search>Search Suggestions>Show trending search suggestions (FF119) ***/
        user_pref("browser.urlbar.trending.featureGate", false);
        /* 0806: disable urlbar suggestions ***/
        user_pref("browser.urlbar.addons.featureGate", false); // [FF115+]
        user_pref("browser.urlbar.amp.featureGate", false); // [FF141+] adMarketplace
        user_pref("browser.urlbar.fakespot.featureGate", false); // [FF130+] [DEFAULT: false]
        user_pref("browser.urlbar.mdn.featureGate", false); // [FF117+]
        user_pref("browser.urlbar.weather.featureGate", false); // [FF108+]
        user_pref("browser.urlbar.wikipedia.featureGate", false); // [FF141+]
        user_pref("browser.urlbar.yelp.featureGate", false); // [FF124+]
        /* 0807: disable urlbar clipboard suggestions [FF118+] ***/
           // user_pref("browser.urlbar.clipboard.featureGate", false);
        /* 0808: disable recent searches [FF120+]
         * [NOTE] Recent searches are cleared if history is cleared (2811+)
         * [1] https://support.mozilla.org/kb/search-suggestions-firefox ***/
           // user_pref("browser.urlbar.recentsearches.featureGate", false);
        /* 0810: disable search and form history
         * [NOTE] We also clear formdata on exit (2811+)
         * [SETUP-WEB] Be aware that autocomplete form data can be read by third parties [1][2]
         * [SETTING] Privacy & Security>History>Custom Settings>Remember search and form history
         * [1] https://blog.mindedsecurity.com/2011/10/autocompleteagain.html
         * [2] https://bugzilla.mozilla.org/381681 ***/
        user_pref("browser.formfill.enable", false);
        /* 0815: disable tab-to-search [FF85+]
         * Alternatively, you can exclude on a per-engine basis by unchecking them in Options>Search
         * [SETTING] Search>Address Bar>When using the address bar, suggest>Search engines ***/
           // user_pref("browser.urlbar.suggest.engines", false);
        /* 0820: disable coloring of visited links
         * [SETUP-HARDEN] Bulk rapid history sniffing was mitigated in 2010 [1][2]. Slower and more expensive
         * redraw timing attacks were largely mitigated in FF77+ [3]. Using RFP (4501) further hampers timing
         * attacks. History can also be cleared on exit (2811+). However, social engineering [2#limits][4][5]
         * and advanced targeted timing attacks could still produce usable results
         * [1] https://developer.mozilla.org/docs/Web/CSS/Privacy_and_the_:visited_selector
         * [2] https://dbaron.org/mozilla/visited-privacy
         * [3] https://bugzilla.mozilla.org/1632765
         * [4] https://earthlng.github.io/testpages/visited_links.html (see github wiki APPENDIX A on how to use)
         * [5] https://lcamtuf.blogspot.com/2016/08/css-mix-blend-mode-is-bad-for-keeping.html ***/
           // user_pref("layout.css.visited_links_enabled", false);
        /* 0830: enable separate default search engine in Private Windows and its UI setting
         * [SETTING] Search>Default Search Engine>Choose a different default search engine for Private Windows only ***/
        user_pref("browser.search.separatePrivateDefault", true); // [FF70+]
        user_pref("browser.search.separatePrivateDefault.ui.enabled", true); // [FF71+]

        /*** [SECTION 0900]: PASSWORDS
           [1] https://support.mozilla.org/kb/use-primary-password-protect-stored-logins-and-pas
        ***/
        user_pref("_user.js.parrot", "0900 syntax error: the parrot's expired!");
        /* 0903: disable auto-filling username & password form fields
         * can leak in cross-site forms *and* be spoofed
         * [NOTE] Username & password is still available when you enter the field
         * [SETTING] Privacy & Security>Passwords>Autofill logins and passwords
         * [1] https://freedom-to-tinker.com/2017/12/27/no-boundaries-for-user-identities-web-trackers-exploit-browser-login-managers/
         * [2] https://homes.esat.kuleuven.be/~asenol/leaky-forms/ ***/
        user_pref("signon.autofillForms", false);
        /* 0904: disable formless login capture for Password Manager [FF51+] ***/
        user_pref("signon.formlessCapture.enabled", false);
        /* 0905: limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
         * hardens against potential credentials phishing
         * 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
         * 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
         * 2 = allow sub-resources to open HTTP authentication credentials dialogs (default) ***/
        user_pref("network.auth.subresource-http-auth-allow", 1);
        /* 0906: enforce no automatic authentication on Microsoft sites [FF91+] [WINDOWS 10+]
         * [SETTING] Privacy & Security>Logins and Passwords>Allow Windows single sign-on for...
         * [1] https://support.mozilla.org/kb/windows-sso ***/
           // user_pref("network.http.windows-sso.enabled", false); // [DEFAULT: false]
        /* 0907: enforce no automatic authentication on Microsoft sites [FF131+] [MAC]
         * On macOS, SSO only works on corporate devices ***/
           // user_pref("network.http.microsoft-entra-sso.enabled", false); // [DEFAULT: false]

        /*** [SECTION 1000]: DISK AVOIDANCE ***/
        user_pref("_user.js.parrot", "1000 syntax error: the parrot's gone to meet 'is maker!");
        /* 1001: disable disk cache
         * [NOTE] We also clear cache on exit (2811+)
         * [SETUP-CHROME] If you think disk cache helps perf, then feel free to override this ***/
        user_pref("browser.cache.disk.enable", false);
        /* 1002: set media cache in Private Browsing to in-memory and increase its maximum size
         * [NOTE] MSE (Media Source Extensions) are already stored in-memory in PB ***/
        user_pref("browser.privatebrowsing.forceMediaMemoryCache", true); // [FF75+]
        user_pref("media.memory_cache_max_size", 65536);
        /* 1003: disable storing extra session data [SETUP-CHROME]
         * define on which sites to save extra session data such as form content, cookies and POST data
         * 0=everywhere, 1=unencrypted sites, 2=nowhere ***/
        user_pref("browser.sessionstore.privacy_level", 2);
        /* 1005: disable automatic Firefox start and session restore after reboot [FF62+] [WINDOWS]
         * [1] https://bugzilla.mozilla.org/603903 ***/
        user_pref("toolkit.winRegisterApplicationRestart", false);
        /* 1006: disable favicons in shortcuts [WINDOWS]
         * URL shortcuts use a cached randomly named .ico file which is stored in your
         * profile/shortcutCache directory. The .ico remains after the shortcut is deleted
         * If set to false then the shortcuts use a generic Firefox icon ***/
        user_pref("browser.shell.shortcutFavicons", false);

        /*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
           Your cipher and other settings can be used in server side fingerprinting
           [TEST] https://www.ssllabs.com/ssltest/viewMyClient.html
           [TEST] https://browserleaks.com/ssl
           [TEST] https://ja3er.com/
           [1] https://www.securityartwork.es/2017/02/02/tls-client-fingerprinting-with-bro/
        ***/
        user_pref("_user.js.parrot", "1200 syntax error: the parrot's a stiff!");
        /** SSL (Secure Sockets Layer) / TLS (Transport Layer Security) ***/
        /* 1201: require safe negotiation
         * Blocks connections to servers that don't support RFC 5746 [2] as they're potentially vulnerable to a
         * MiTM attack [3]. A server without RFC 5746 can be safe from the attack if it disables renegotiations
         * but the problem is that the browser can't know that. Setting this pref to true is the only way for the
         * browser to ensure there will be no unsafe renegotiations on the channel between the browser and the server
         * [SETUP-WEB] SSL_ERROR_UNSAFE_NEGOTIATION: is it worth overriding this for that one site?
         * [STATS] SSL Labs (May 2024) reports over 99.7% of top sites have secure renegotiation [4]
         * [1] https://wiki.mozilla.org/Security:Renegotiation
         * [2] https://datatracker.ietf.org/doc/html/rfc5746
         * [3] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3555
         * [4] https://www.ssllabs.com/ssl-pulse/ ***/
        user_pref("security.ssl.require_safe_negotiation", true);
        /* 1206: disable TLS1.3 0-RTT (round-trip time) [FF51+]
         * This data is not forward secret, as it is encrypted solely under keys derived using
         * the offered PSK. There are no guarantees of non-replay between connections
         * [1] https://github.com/tlswg/tls13-spec/issues/1001
         * [2] https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt
         * [3] https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a/ ***/
        user_pref("security.tls.enable_0rtt_data", false);

        /** OCSP (Online Certificate Status Protocol)
           [1] https://scotthelme.co.uk/revocation-is-broken/
           [2] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
        ***/
        /* 1211: enforce OCSP fetching to confirm current validity of certificates
         * 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
         * OCSP (non-stapled) leaks information about the sites you visit to the CA (cert authority)
         * It's a trade-off between security (checking) and privacy (leaking info to the CA)
         * [NOTE] This pref only controls OCSP fetching and does not affect OCSP stapling
         * [SETTING] Privacy & Security>Security>Certificates>Query OCSP responder servers...
         * [1] https://en.wikipedia.org/wiki/Ocsp ***/
        user_pref("security.OCSP.enabled", 1); // [DEFAULT: 1]
        /* 1212: set OCSP fetch failures (non-stapled, see 1211) to hard-fail
         * [SETUP-WEB] SEC_ERROR_OCSP_SERVER_ERROR | SEC_ERROR_OCSP_UNAUTHORIZED_REQUEST
         * When a CA cannot be reached to validate a cert, Firefox just continues the connection (=soft-fail)
         * Setting this pref to true tells Firefox to instead terminate the connection (=hard-fail)
         * It is pointless to soft-fail when an OCSP fetch fails: you cannot confirm a cert is still valid (it
         * could have been revoked) and/or you could be under attack (e.g. malicious blocking of OCSP servers)
         * [1] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
         * [2] https://www.imperialviolet.org/2014/04/19/revchecking.html
         * [3] https://letsencrypt.org/2024/12/05/ending-ocsp/ ***/
        user_pref("security.OCSP.require", true);

        /** CERTS / HPKP (HTTP Public Key Pinning) ***/
        /* 1223: enable strict PKP (Public Key Pinning)
         * 0=disabled, 1=allow user MiTM (default; such as your antivirus), 2=strict
         * [SETUP-WEB] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE ***/
        user_pref("security.cert_pinning.enforcement_level", 2);
        /* 1224: enable CRLite [FF73+]
         * 0 = disabled
         * 1 = consult CRLite but only collect telemetry
         * 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
         * 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (default)
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1429800,1670985,1753071
         * [2] https://blog.mozilla.org/security/tag/crlite/ ***/
        user_pref("security.remote_settings.crlite_filters.enabled", true); // [DEFAULT: true FF137+]
        user_pref("security.pki.crlite_mode", 2);

        /** MIXED CONTENT ***/
        /* 1241: disable insecure passive content (such as images) on https pages ***/
           // user_pref("security.mixed_content.block_display_content", true); // Defense-in-depth (see 1244)
        /* 1244: enable HTTPS-Only mode in all windows
         * When the top-level is HTTPS, insecure subresources are also upgraded (silent fail)
         * [SETTING] to add site exceptions: Padlock>HTTPS-Only mode>On (after "Continue to HTTP Site")
         * [SETTING] Privacy & Security>HTTPS-Only Mode (and manage exceptions)
         * [TEST] http://example.com [upgrade]
         * [TEST] http://httpforever.com/ | http://http.rip [no upgrade] ***/
        user_pref("dom.security.https_only_mode", true); // [FF76+]
           // user_pref("dom.security.https_only_mode_pbm", true); // [FF80+]
        /* 1245: enable HTTPS-Only mode for local resources [FF77+] ***/
           // user_pref("dom.security.https_only_mode.upgrade_local", true);
        /* 1246: disable HTTP background requests [FF82+]
         * When attempting to upgrade, if the server doesn't respond within 3 seconds, Firefox sends
         * a top-level HTTP request without path in order to check if the server supports HTTPS or not
         * This is done to avoid waiting for a timeout which takes 90 seconds
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1642387,1660945 ***/
        user_pref("dom.security.https_only_mode_send_http_background_request", false);

        /** UI (User Interface) ***/
        /* 1270: display warning on the padlock for "broken security" (if 1201 is false)
         * Bug: warning padlock not indicated for subresources on a secure page! [2]
         * [1] https://wiki.mozilla.org/Security:Renegotiation
         * [2] https://bugzilla.mozilla.org/1353705 ***/
        user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
        /* 1272: display advanced information on Insecure Connection warning pages
         * only works when it's possible to add an exception
         * i.e. it doesn't work for HSTS discrepancies (https://subdomain.preloaded-hsts.badssl.com/)
         * [TEST] https://expired.badssl.com/ ***/
        user_pref("browser.xul.error_pages.expert_bad_cert", true);

        /*** [SECTION 1600]: REFERERS
                          full URI: https://example.com:8888/foo/bar.html?id=1234
             scheme+host+port+path: https://example.com:8888/foo/bar.html
                  scheme+host+port: https://example.com:8888
           [1] https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/
        ***/
        user_pref("_user.js.parrot", "1600 syntax error: the parrot rests in peace!");
        /* 1602: control the amount of cross-origin information to send [FF52+]
         * 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port ***/
        user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

        /*** [SECTION 1700]: CONTAINERS ***/
        user_pref("_user.js.parrot", "1700 syntax error: the parrot's bit the dust!");
        /* 1701: enable Container Tabs and its UI setting [FF50+]
         * [SETTING] General>Tabs>Enable Container Tabs
         * https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers ***/
        user_pref("privacy.userContext.enabled", true);
        user_pref("privacy.userContext.ui.enabled", true);
        /* 1702: set behavior on "+ Tab" button to display container menu on left click [FF74+]
         * [NOTE] The menu is always shown on long press and right click
         * [SETTING] General>Tabs>Enable Container Tabs>Settings>Select a container for each new tab ***/
           // user_pref("privacy.userContext.newTabContainerOnLeftClick.enabled", true);
        /* 1703: set external links to open in site-specific containers [FF123+]
         * [SETUP-WEB] Depending on your container extension(s) and their settings
         * true=Firefox will not choose a container (so your extension can)
         * false=Firefox will choose the container/no-container (default)
         * [1] https://bugzilla.mozilla.org/1874599 ***/
           // user_pref("browser.link.force_default_user_context_id_for_external_opens", true);

        /*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
        user_pref("_user.js.parrot", "2000 syntax error: the parrot's snuffed it!");
        /* 2002: force WebRTC inside the proxy [FF70+] ***/
        user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
        /* 2003: force a single network interface for ICE candidates generation [FF42+]
         * When using a system-wide proxy, it uses the proxy interface
         * [1] https://developer.mozilla.org/docs/Web/API/RTCIceCandidate
         * [2] https://wiki.mozilla.org/Media/WebRTC/Privacy ***/
        user_pref("media.peerconnection.ice.default_address_only", true);
        /* 2004: force exclusion of private IPs from ICE candidates [FF51+]
         * [SETUP-HARDEN] This will protect your private IP even in TRUSTED scenarios after you
         * grant device access, but often results in breakage on video-conferencing platforms ***/
           // user_pref("media.peerconnection.ice.no_host", true);
        /* 2020: disable GMP (Gecko Media Plugins)
         * [1] https://wiki.mozilla.org/GeckoMediaPlugins ***/
           // user_pref("media.gmp-provider.enabled", false);

        /*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
        user_pref("_user.js.parrot", "2400 syntax error: the parrot's kicked the bucket!");
        /* 2402: prevent scripts from moving and resizing open windows ***/
        user_pref("dom.disable_window_move_resize", true);

        /*** [SECTION 2600]: MISCELLANEOUS ***/
        user_pref("_user.js.parrot", "2600 syntax error: the parrot's run down the curtain!");
        /* 2603: remove temp files opened from non-PB windows with an external application
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=302433,1738574 ***/
        user_pref("browser.download.start_downloads_in_tmp_dir", true); // [FF102+]
        user_pref("browser.helperApps.deleteTempFileOnExit", true);
        /* 2606: disable UITour backend so there is no chance that a remote page can use it ***/
        user_pref("browser.uitour.enabled", false);
           // user_pref("browser.uitour.url", ""); // Defense-in-depth
        /* 2608: reset remote debugging to disabled
         * [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16222 ***/
        user_pref("devtools.debugger.remote-enabled", false); // [DEFAULT: false]
        /* 2615: disable websites overriding Firefox's keyboard shortcuts [FF58+]
         * 0 (default) or 1=allow, 2=block
         * [SETTING] to add site exceptions: Ctrl+I>Permissions>Override Keyboard Shortcuts ***/
           // user_pref("permissions.default.shortcuts", 2);
        /* 2616: remove special permissions for certain mozilla domains [FF35+]
         * [1] resource://app/defaults/permissions ***/
        user_pref("permissions.manager.defaultsUrl", "");
        /* 2619: use Punycode in Internationalized Domain Names to eliminate possible spoofing
         * [SETUP-WEB] Might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded
         * [TEST] https://www.xn--80ak6aa92e.com/ (www.apple.com)
         * [1] https://wiki.mozilla.org/IDN_Display_Algorithm
         * [2] https://en.wikipedia.org/wiki/IDN_homograph_attack
         * [3] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=punycode+firefox
         * [4] https://www.xudongz.com/blog/2017/idn-phishing/ ***/
        user_pref("network.IDN_show_punycode", true);
        /* 2620: enforce PDFJS, disable PDFJS scripting
         * This setting controls if the option "Display in Firefox" is available in the setting below
         *   and by effect controls whether PDFs are handled in-browser or externally ("Ask" or "Open With")
         * [WHY] pdfjs is lightweight, open source, and secure: the last exploit was June 2015 [1]
         *   It doesn't break "state separation" of browser content (by not sharing with OS, independent apps).
         *   It maintains disk avoidance and application data isolation. It's convenient. You can still save to disk.
         * [NOTE] JS can still force a pdf to open in-browser by bundling its own code
         * [SETUP-CHROME] You may prefer a different pdf reader for security/workflow reasons
         * [SETTING] General>Applications>Portable Document Format (PDF)
         * [1] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=pdf.js+firefox ***/
        user_pref("pdfjs.disabled", false); // [DEFAULT: false]
        user_pref("pdfjs.enableScripting", false); // [FF86+]
        /* 2624: disable middle click on new tab button opening URLs or searches using clipboard [FF115+] ***/
        user_pref("browser.tabs.searchclipboardfor.middleclick", false); // [DEFAULT: false NON-LINUX]
        /* 2630: disable content analysis by DLP (Data Loss Prevention) agents
         * DLP agents are background processes on managed computers that allow enterprises to monitor locally running
         * applications for data exfiltration events, which they can allow/block based on customer defined DLP policies.
         * 0=Block all requests, 1=Warn on all requests (which lets the user decide), 2=Allow all requests
         * [1] https://github.com/chromium/content_analysis_sdk ***/
        user_pref("browser.contentanalysis.enabled", false); // [FF121+] [DEFAULT: false]
        user_pref("browser.contentanalysis.default_result", 0); // [FF127+] [DEFAULT: 0]
        /* 2635: disable referrer and storage access for resources injected by content scripts [FF139+] ***/
           // user_pref("privacy.antitracking.isolateContentScriptResources", true);
        /* 2640: disable CSP Level 2 Reporting [FF140+] ***/
        user_pref("security.csp.reporting.enabled", false);

        /** DOWNLOADS ***/
        /* 2651: enable user interaction for security by always asking where to download
         * [SETUP-CHROME] On Android this blocks longtapping and saving images
         * [SETTING] General>Downloads>Always ask you where to save files ***/
        user_pref("browser.download.useDownloadDir", false);
        /* 2652: disable downloads panel opening on every download [FF96+] ***/
        user_pref("browser.download.alwaysOpenPanel", false);
        /* 2653: disable adding downloads to the system's "recent documents" list ***/
        user_pref("browser.download.manager.addToRecentDocs", false);
        /* 2654: enable user interaction for security by always asking how to handle new mimetypes [FF101+]
         * [SETTING] General>Files and Applications>What should Firefox do with other files ***/
        user_pref("browser.download.always_ask_before_handling_new_types", true);

        /** EXTENSIONS ***/
        /* 2660: limit allowed extension directories
         * 1=profile, 2=user, 4=application, 8=system, 16=temporary, 31=all
         * The pref value represents the sum: e.g. 5 would be profile and application directories
         * [SETUP-CHROME] Breaks usage of files which are installed outside allowed directories
         * [1] https://archive.is/DYjAM ***/
        user_pref("extensions.enabledScopes", 5); // [HIDDEN PREF]
           // user_pref("extensions.autoDisableScopes", 15); // [DEFAULT: 15]
        /* 2661: disable bypassing 3rd party extension install prompts [FF82+]
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1659530,1681331 ***/
        user_pref("extensions.postDownloadThirdPartyPrompt", false);
        /* 2662: disable webextension restrictions on certain mozilla domains (you also need 4503) [FF60+]
         * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330,1406795,1415644,1453988 ***/
           // user_pref("extensions.webextensions.restrictedDomains", "");

        /*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
        user_pref("_user.js.parrot", "2700 syntax error: the parrot's joined the bleedin' choir invisible!");
        /* 2701: enable ETP Strict Mode [FF86+]
         * ETP Strict Mode enables Total Cookie Protection (TCP)
         * [NOTE] Adding site exceptions disables all ETP protections for that site and increases the risk of
         * cross-site state tracking e.g. exceptions for SiteA and SiteB means PartyC on both sites is shared
         * [1] https://blog.mozilla.org/security/2021/02/23/total-cookie-protection/
         * [SETTING] to add site exceptions: Urlbar>ETP Shield
         * [SETTING] to manage site exceptions: Options>Privacy & Security>Enhanced Tracking Protection>Manage Exceptions ***/
        user_pref("browser.contentblocking.category", "strict"); // [HIDDEN PREF]
        /* 2702: disable ETP web compat features [FF93+]
         * [SETUP-HARDEN] Includes skip lists, heuristics (SmartBlock) and automatic grants
         * Opener and redirect heuristics are granted for 30 days, see [3]
         * [1] https://blog.mozilla.org/security/2021/07/13/smartblock-v2/
         * [2] https://hg.mozilla.org/mozilla-central/rev/e5483fd469ab#l4.12
         * [3] https://developer.mozilla.org/docs/Web/Privacy/State_Partitioning#storage_access_heuristics ***/
           // user_pref("privacy.antitracking.enableWebcompat", false);

        /*** [SECTION 2800]: SHUTDOWN & SANITIZING
           We enable sanitizeOnShutdown to help prevent 1st party website tracking across sessions.
           We consider history/downloads, which are not accessible to websites, as orthogonal and exempt these

           [SETUP-HARDEN] to clear all history/downloads on close, add the appropriate overrides from 2800's
        ***/
        user_pref("_user.js.parrot", "2800 syntax error: the parrot's bleedin' demised!");
        /* 2810: enable Firefox to clear items on shutdown
         * [NOTE] In FF129+ clearing "siteSettings" on shutdown (2811+), or manually via site data (2820+) and
         * via history (2830), will no longer remove sanitize on shutdown "cookie and site data" site exceptions (2815)
         * [SETTING] Privacy & Security>History>Custom Settings>Clear history when Firefox closes | Settings ***/
        user_pref("privacy.sanitize.sanitizeOnShutdown", true);

        user_pref("privacy.clearOnShutdown_v2.cache", true); // [DEFAULT: true]
        user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // [DEFAULT: true]
        user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false); // [DEFAULT: true]
        user_pref("privacy.clearOnShutdown_v2.downloads", false); // [HIDDEN]
        user_pref("privacy.clearOnShutdown_v2.formdata", true);
           // user_pref("privacy.clearOnShutdown.openWindows", true);

        user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);

        user_pref("privacy.clearSiteData.cache", true);
        user_pref("privacy.clearSiteData.cookiesAndStorage", false); // keep false until it respects "allow" site exceptions
        user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false);
        user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false);
        user_pref("privacy.clearSiteData.formdata", true);

        user_pref("privacy.clearHistory.cache", true); // [DEFAULT: true]
        user_pref("privacy.clearHistory.cookiesAndStorage", false);
        user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // [DEFAULT: true]
        user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false); // [DEFAULT: true]
        user_pref("privacy.clearHistory.formdata", true);

        user_pref("privacy.sanitize.timeSpan", 0);

        user_pref("_user.js.parrot", "8500 syntax error: the parrot's off the twig!");
        user_pref("datareporting.policy.dataSubmissionEnabled", false);
        user_pref("datareporting.healthreport.uploadEnabled", false);
        user_pref("toolkit.telemetry.unified", false);
        user_pref("toolkit.telemetry.enabled", false); // see [NOTE]
        user_pref("toolkit.telemetry.server", "data:,");
        user_pref("toolkit.telemetry.archive.enabled", false);
        user_pref("toolkit.telemetry.newProfilePing.enabled", false); // [FF55+]
        user_pref("toolkit.telemetry.shutdownPingSender.enabled", false); // [FF55+]
        user_pref("toolkit.telemetry.updatePing.enabled", false); // [FF56+]
        user_pref("toolkit.telemetry.bhrPing.enabled", false); // [FF57+] Background Hang Reporter
        user_pref("toolkit.telemetry.firstShutdownPing.enabled", false); // [FF57+]
        user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
        user_pref("toolkit.coverage.opt-out", true); // [FF64+] [HIDDEN PREF]
        user_pref("toolkit.coverage.endpoint.base", "");

        user_pref("_user.js.parrot", "9000 syntax error: the parrot's cashed in 'is chips!");
        user_pref("browser.startup.homepage_override.mstone", "ignore"); // [HIDDEN PREF]
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
        user_pref("browser.urlbar.showSearchTerms.enabled", false);

        user_pref("browser.urlbar.pocket.featureGate", false); // [FF116+] [DEFAULT: false]
        user_pref("_user.js.parrot", "SUCCESS: No no he's not dead, he's, he's restin'!");
          // Overrides on top of arkenfox
          user_pref("general.smoothScroll", true);
          user_pref("apz.overscroll.enabled", true);

          // Required for textfox chrome to work
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("svg.context-properties.content.enabled", true);
          user_pref("layout.css.has-selector.enabled", true);

            // DNS over https
            user_pref("network.trr.mode", 3);
            user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
            user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");
        '';

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          bitwarden
          sponsorblock
          darkreader
          sidebery
          stylus
          vimium-c
          multi-account-containers
          mtab
          violentmonkey
          zotero-connector
          dearrow
          skip-redirect
          firefox-color
        ];

      search = {
        force = true;
        default = "SearXNG";
        engines = {
          "SearXNG" = {
              urls = [{
                template = "http://localhost:8080/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              updateInterval = 24 * 60 * 60 * 1000; # update icon every 24h
              definedAliases = [ "@s" ];
            };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type";  value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@no" ];
          };
        };
      };
    };
  };
  textfox = {
    enable = true;
    profiles = [ "elaine" ];
    config = {
      displayWindowControls = false;
      displayNavButtons = false;
      displayUrlbarIcons = false;
      displaySidebarTools = false;
      font = {
          family = "Iosevka Nerd Font Mono";
          size = "14px";
        };
      tabs = {
        horizontal.enable = false;
        vertical.enable = true;
      };
    };
  };
}
