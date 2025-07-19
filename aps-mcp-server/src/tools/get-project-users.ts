import { z } from "zod";
import { AccountAdminClient } from "@aps_sdk/construction-account-admin";
import { getAccessToken } from "./common.js";
import type { Tool } from "./common.js";

const schema = {
    projectId: z.string().nonempty(),
};

export const getProjectUsers: Tool<typeof schema> = {
    title: "get-project-users",
    description: "List all available users in a project",
    schema,
    callback: async ({ projectId }) => {
        const accessToken = await getAccessToken(["user:read"]);
        const adminClient = new AccountAdminClient();
        const users = await adminClient.getProjectUsers(projectId, undefined, accessToken);
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
