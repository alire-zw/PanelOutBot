import Redis from "ioredis";
import { env } from "../config/env.js";
import { logger } from "../lib/logger.js";

export const redis = new Redis(env.redisUrl, {
  maxRetriesPerRequest: 3,
  lazyConnect: true,
});

export async function connectRedis() {
  await redis.connect();
  logger.info("redis", "Connected");
}

export async function disconnectRedis() {
  await redis.quit();
  logger.info("redis", "Disconnected");
}
