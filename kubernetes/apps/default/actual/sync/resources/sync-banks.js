// Self-contained Actual Budget bank-sync trigger.
// Connects to an Actual server, downloads the budget file, runs the
// bank sync (GoCardless / SimpleFIN) for all linked accounts, then shuts down.
//
// Env vars:
//   ACTUAL_SERVER_URL       (required)  e.g. http://localhost:5006
//   ACTUAL_SERVER_PASSWORD  (required)  the server/login password
//   ACTUAL_SYNC_ID          (required)  budget Sync ID (Settings > Advanced > Sync ID)
//   ACTUAL_FILE_PASSWORD    (optional)  only if the budget file is end-to-end encrypted
//   ACTUAL_CACHE_DIR        (optional)  local budget cache dir (default ./cache)

const api = require('@actual-app/api');
const fs = require('fs');

const {
  ACTUAL_SERVER_URL,
  ACTUAL_SERVER_PASSWORD,
  ACTUAL_SYNC_ID,
  ACTUAL_FILE_PASSWORD,
  ACTUAL_CACHE_DIR = './cache',
} = process.env;

function requireEnv(name, value) {
  if (!value) {
    console.error(`ERROR: missing required env var ${name}`);
    process.exit(1);
  }
}

(async () => {
  requireEnv('ACTUAL_SERVER_URL', ACTUAL_SERVER_URL);
  requireEnv('ACTUAL_SERVER_PASSWORD', ACTUAL_SERVER_PASSWORD);
  requireEnv('ACTUAL_SYNC_ID', ACTUAL_SYNC_ID);

  fs.mkdirSync(ACTUAL_CACHE_DIR, { recursive: true });

  console.log(`Connecting to Actual server at ${ACTUAL_SERVER_URL} ...`);
  await api.init({
    dataDir: ACTUAL_CACHE_DIR,
    serverURL: ACTUAL_SERVER_URL,
    password: ACTUAL_SERVER_PASSWORD,
  });

  console.log(`Downloading budget ${ACTUAL_SYNC_ID} ...`);
  const downloadOpts = ACTUAL_FILE_PASSWORD ? { password: ACTUAL_FILE_PASSWORD } : undefined;
  await api.downloadBudget(ACTUAL_SYNC_ID, downloadOpts);

  console.log('Running bank sync for all linked accounts ...');
  await api.runBankSync();
  console.log('Bank sync finished.');

  await api.shutdown();
  console.log('Done.');
})().catch(async (err) => {
  console.error('Bank sync failed:', err && err.stack ? err.stack : err);
  try { await api.shutdown(); } catch (_) { /* ignore */ }
  process.exit(1);
});
