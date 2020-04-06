import * as rac from "rest-api-client";
import * as MicrosoftGraph from "@microsoft/microsoft-graph-types";
import * as url from "url";

export interface MSGraphAPIODataRuturn<VT> {
    "@odata.context": string;
    "@odata.nextLink"?: string;
    value: VT[];
}

export class MSGraphSnapshot {
    constructor(private msGraphClient: rac.Client) {
    }
    // "GET" on MS Graph API
    private async msGraphAPIGet<VT>(path: string) {
        return await this.msGraphClient.api(path).get<MSGraphAPIODataRuturn<VT>>();
    }
    private getPath(urlString: string): string {
        let parts = url.parse(urlString, false);
        return parts.path;
    }
    async getAllObjets<O>(path: string) {
        let objs: O[] = [];
        let res = await this.msGraphAPIGet<O>(path);
        objs = objs.concat(res.value);
        while (res["@odata.nextLink"]) {
            res = await this.msGraphAPIGet<O>(this.getPath(res["@odata.nextLink"]));
            objs = objs.concat(res.value);
        }
        return objs;
    }
    async getAllUsers() {
        return await this.getAllObjets<MicrosoftGraph.User>(`/v1.0/users`);
    }
}