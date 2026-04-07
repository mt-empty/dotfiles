// Firefox user.js - Minimal essential privacy settings
// Copy this to ~/.mozilla/firefox/[profile-id]/user.js or run install_firefox.sh

// ─── Telemetry & Data Collection ────────────────────────────────────────────
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "1");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);

// ─── Pocket & Sponsored Content ─────────────────────────────────────────────
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// ─── Security ────────────────────────────────────────────────────────────────
user_pref("dom.security.https_only_mode", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

// ─── Startup ─────────────────────────────────────────────────────────────────
user_pref("browser.startup.homepage", "about:blank");

// ─── Recommended Extensions ──────────────────────────────────────────────────
// Install these manually from addons.mozilla.org or via install_firefox.sh:
//
//   uBlock Origin     - https://addons.mozilla.org/addon/ublock-origin/
//   KeePassXC-Browser - https://addons.mozilla.org/addon/keepassxc-browser/
//   Dark Reader       - https://addons.mozilla.org/addon/darkreader/

// ─── Keyword Bookmarks (%s shortcuts) ────────────────────────────────────────
// Set these up manually in Firefox:
//   1. Bookmark a URL that contains %s as the query placeholder
//   2. Right-click the bookmark → Edit Bookmark → set a Keyword
//   3. In the address bar, type: keyword<space>query
//
// Suggested keywords to add:
//
//   Keyword  URL
//   ───────  ──────────────────────────────────────────────────────────────────
//   gh       https://github.com/search?q=%s&type=repositories
//   ghpr     https://github.com/pulls?q=%s
//   ghi      https://github.com/issues?q=%s
//   jira     https://[your-jira-domain]/issues/?jql=text+~+"%s"
//   jirat    https://[your-jira-domain]/browse/%s
//
// Examples:
//   "gh dotfiles"      → searches GitHub repos for dotfiles
//   "jirat PROJ-123"   → opens Jira ticket PROJ-123 directly
