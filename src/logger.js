/**
 * Logger module using pino.
 */
import pino from 'pino';

// Determine if we are in development (non-production) mode
const isDevelopment = process.env.NODE_ENV !== 'production';

/**
 * Pino logger instance.
 * @type {import('pino').Logger}
 */
let logger;
if (isDevelopment) {
  // Use pino-pretty for pretty-printing JSON logs in development
  const transport = pino.transport({
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'yyyy-mm-dd HH:MM:ss.l o',
      ignore: 'pid,hostname'
    }
  });
  logger = pino(
    { level: process.env.LOG_LEVEL || 'info' },
    transport
  );
} else {
  // Use JSON output in production
  logger = pino({ level: process.env.LOG_LEVEL || 'info' });
}

export default logger;