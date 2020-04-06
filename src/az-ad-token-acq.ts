import * as rac from "rest-api-client";

export interface AzureADTokenGrant {
    token_type: string;     // ex. "Bearer"
    access_token: string;   // ex. "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIs...""
    refresh_token?: string;
    resource: string;       // ex. "https://graph.microsoft.com" or "https://graph.windows.net"
    expires_in: string;     // ex. "3600"
    ext_expires_in: string; // ex. "0"
    expires_on: string;     // ex. "1521042398"
    not_before: string;     // ex. "1521038498"
}

export class TokensAcquisition {
    constructor(private tenant_id: string, private client_id: string, private client_secret: string) {
    }
    private static async getAzureADTokenGrantEndpoint(tenant_id: string) {
        const ret: {token_endpoint: string}  = await rac.Client.init(async () => ({baseUrl: `https://login.microsoftonline.com/${tenant_id}/v2.0/.well-known/openid-configuration`}))
        .api("/")
        .get();
		return ret.token_endpoint;
    }
    public async getAccessTokenForScope(scope: string) {
        const tokenGrant: AzureADTokenGrant = await rac.Client.init(() => TokensAcquisition.getAzureADTokenGrantEndpoint(this.tenant_id).then((tokenEndpoint: string) => ({baseUrl: tokenEndpoint})))
        .api("/")
        .form()
        .send({grant_type: "client_credentials"})
        .send({client_id: this.client_id})
        .send({client_secret: this.client_secret})
        .send({scope})
        .post();
		return tokenGrant;
    }
    public async getMSGraphAccessToken() {
        return await this.getAccessTokenForScope("https://graph.microsoft.com/.default");
    }
}