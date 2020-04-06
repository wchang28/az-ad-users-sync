
import * as sql from "mssql";

function connection(config: sql.config) {
    if (config.options && typeof config.options.trustedConnection === "boolean" && config.options.trustedConnection) {
        const nsql = require('mssql/msnodesqlv8');
        return (new nsql.ConnectionPool(config)) as sql.ConnectionPool;
    } else {
        return new sql.ConnectionPool(config);
    }
}

export class DBBase {
    private connected: Promise<sql.ConnectionPool>;

    constructor(config: sql.config) {
        this.connected = connection(config).connect();
    }
    protected async reqReady() {
        const pool = await this.connected;
        return pool.request();
    }
    protected async prepare(params?: {[field:string]: any}) {
        let req = await this.reqReady();
        if (params) {
            for (const field in params) {
                req = req.input(field, params[field]);
            }
        }
        return req;
    }
    async query(command: string, params?: {[field:string]: any}) {
        const req = await this.prepare(params);
        return req.query(command);
    }
    async execute(procedure: string, params?: {[field:string]: any}) {
        const req = await this.prepare(params);
        return req.execute(procedure);
    }
    async close() {
        const pool = await this.connected;
        pool.close();
    }
}