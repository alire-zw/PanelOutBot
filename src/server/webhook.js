import { GrammyError } from "grammy";
import { env } from "../config/env.js";
import { logger } from "../lib/logger.js";

const webhookOptions = {
  secret_token: env.webhookSecret,
  allowed_updates: ["message", "callback_query"],
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function isRateLimitError(err) {
  return err instanceof GrammyError && err.error_code === 429;
}

async function setWebhookWithRetry(bot) {
  const maxAttempts = 5;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      await bot.api.setWebhook(env.webhookUrl, webhookOptions);
      return;
    } catch (err) {
      if (!isRateLimitError(err) || attempt === maxAttempts) {
        throw err;
      }

      const retryAfter = (err.parameters?.retry_after ?? 1) * 1000;
      logger.warn("webhook", `retry ${attempt}/${maxAttempts} in ${retryAfter}ms`);
      await sleep(retryAfter);
    }
  }
}

function isWebhookConfigured(info) {
  const allowed = webhookOptions.allowed_updates ?? [];
  const current = info.allowed_updates ?? [];

  return (
    info.url === env.webhookUrl &&
    allowed.length === current.length &&
    allowed.every((update, index) => update === current[index])
  );
}

export async function setupWebhook(bot) {
  const info = await bot.api.getWebhookInfo();

  if (isWebhookConfigured(info)) {
    await setWebhookWithRetry(bot);
    logger.info("webhook", "ready");
    return;
  }

  if (info.url) {
    logger.info("webhook", "updating");
  }

  await setWebhookWithRetry(bot);
  logger.info("webhook", "registered");
}
