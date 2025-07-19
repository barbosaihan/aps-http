import { z } from "zod";
import { AccountAdminClient } from "@aps_sdk/construction-account-admin";
import { getAccessToken } from "./common.js";
import type { Tool } from "./common.js";

const schema = {
    accountId: z.string().nonempty(),
};

export const getUsers: Tool<typeof schema> = {
    title: "get-users",
    description: "List all available users in an Autodesk Construction Cloud account",
    schema,
    callback: async ({ accountId }) => {
        const accessToken = await getAccessToken(["user:read"]);
        const adminClient = new AccountAdminClient();
        const users = await adminClient.getUsers(accountId, undefined, accessToken);
        if (!users.results) {
            throw new Error("No users found");
        }
        return {
            content: users.results.map((user) => ({
                type: "text",
                text: JSON.stringify({
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    status: user.status,
                }),
            })),
        };
    },
};
