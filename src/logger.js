/**
 * Logger module using pino.
 */
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
});

export default logger;