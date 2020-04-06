/*
environment variables supported:
 1. USER_ID (required)
 2. TENANT_ID (required)
 3. APP_CLIENT_ID (required)
 4. APP_CLIENT_SECRET (required)
 5. DB_CONFIG_JSON (required)
 6. SYNC_INETRVAL_SECONDS (required)
 */
import {TokensAcquisition} from "./az-ad-token-acq";
import * as rac from "rest-api-client";
import {MSGraphSnapshot} from "./ms-graph-snapshot";
import {DBBase} from "./db-base";
import * as sql from "mssql";
import {User} from "@microsoft/microsoft-graph-types";
import * as pp from "periodic-polling";

const USER_ID = process.env["USER_ID"];
if (!USER_ID) {
    console.error(`${new Date().toISOString()}: env. var. USER_ID is not defined`);
    process.exit(1);
}

const TENANT_ID = process.env["TENANT_ID"];
if (!TENANT_ID) {
    console.error(`${new Date().toISOString()}: env. var. TENANT_ID is not defined`);
    process.exit(1);
}

const APP_CLIENT_ID = process.env["APP_CLIENT_ID"];
if (!APP_CLIENT_ID) {
    console.error(`${new Date().toISOString()}: env. var. APP_CLIENT_ID is not defined`);
    process.exit(1);
}

const APP_CLIENT_SECRET = process.env["APP_CLIENT_SECRET"];
if (!APP_CLIENT_SECRET) {
    console.error(`${new Date().toISOString()}: env. var. APP_CLIENT_SECRET is not defined`);
    process.exit(1);
}

const DB_CONFIG_JSON = process.env["DB_CONFIG_JSON"];
if (!APP_CLIENT_SECRET) {
    console.error(`${new Date().toISOString()}: env. var. DB_CONFIG_JSON is not defined`);
    process.exit(1);
}

const dbConfig: sql.config = JSON.parse(DB_CONFIG_JSON);
//console.log(JSON.stringify(dbConfig));

const SYNC_INETRVAL_SECONDS = process.env["SYNC_INETRVAL_SECONDS"] || "60";
const syncIntervalSec = parseInt(SYNC_INETRVAL_SECONDS);

const msGraphClient = rac.Client.init(async () => {
    const {token_type, access_token} = await new TokensAcquisition(TENANT_ID, APP_CLIENT_ID, APP_CLIENT_SECRET).getMSGraphAccessToken();
    return {baseUrl: "https://graph.microsoft.com", credentialPlacement: "header", credential: {value: `${token_type} ${access_token}`}};
});
const snapshot = new MSGraphSnapshot(msGraphClient);

class DB extends DBBase {
    constructor(config: sql.config) {
        super(config);
    }
    async syncADUsers(userId: string, users: User[]) {
        const result = await this.execute("[dbo].[stp_SyncADUsers]", {userId, json: JSON.stringify(users), numUsers: users.length});
        if (result && result.recordset && result.recordset[0] && result.recordset[0]["id"])
            return result.recordset[0]["id"] as number;
        else {
            throw "unable to sync AD users";
        }
    }
}

const db = new DB(dbConfig);

async function runProc() {
    console.log("");
    try {
        console.log(`${new Date().toISOString()}: taking users snapshot from Azure AD...`);
        const users = await snapshot.getAllUsers(); 
        console.log(`${new Date().toISOString()}: done snapshot. number of users = ${users.length}`);
        console.log(`${new Date().toISOString()}: sync. to the database...`);
        const syncId = await db.syncADUsers(USER_ID, users);
        console.log(`${new Date().toISOString()}: syncId = ${syncId}`);
    } catch(e) {
        console.error(`${new Date().toISOString()}: !!! Error: ${JSON.stringify(e)}`);
    }
    console.log("");
}

const polling = pp.PeriodicPolling.get<void>(async (pollInfo) => {await runProc();}, syncIntervalSec);
polling.start();

/*
runProc()
.then(() => {
    console.log("\nDone");
    process.exit(0);
}).catch((err) => {
    console.error(`!!! Error: ${JSON.stringify(err)}`);
    process.exit(1);
});
*/