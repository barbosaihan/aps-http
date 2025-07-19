import { z } from "zod";
import { IssuesClient } from "@aps_sdk/construction-issues";
import { getAccessToken } from "./common.js";
import type { Tool } from "./common.js";

const schema = {
    projectId: z.string().nonempty(),
    title: z.string().nonempty(),
    description: z.string().optional(),
    issueTypeId: z.string().nonempty(),
    issueSubtypeId: z.string().nonempty(),
};

export const createIssue: Tool<typeof schema> = {
    title: "create-issue",
    description: "Create a new issue in a project",
    schema,
    callback: async ({ projectId, title, description, issueTypeId, issueSubtypeId }) => {
        const accessToken = await getAccessToken(["data:write"]);
        const issuesClient = new IssuesClient();
        const issue = await issuesClient.createIssue(projectId, {
            title,
            description,
            issueTypeId,
            issueSubtypeId,
        }, accessToken);
        return {
            content: [{
                type: "text",
                text: JSON.stringify(issue),
            }],
        };
    },
};
