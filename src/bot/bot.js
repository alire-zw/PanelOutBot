import { Bot } from "grammy";
import { env } from "../config/env.js";
import { registerHandlers } from "../handlers/index.js";
import { logger } from "../lib/logger.js";

export function createBot() {
  const bot = new Bot(env.botToken);

  registerHandlers(bot);

  bot.catch((err) => {
    const message = err.error?.description ?? err.error?.message ?? err.message;

    if (
      message?.includes("query is too old") ||
      message?.includes("query ID is invalid")
    ) {
      return;
    }

    logger.error("bot", message);
  });

  return bot;
}
